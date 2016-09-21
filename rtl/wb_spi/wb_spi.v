//-----------------------------------------------------------------
// SPI Master
// map memory
//
// 0x00 rst_done
// 0x01 dc
// 0x02 sreg
// 0x03 x_pos
// 0x04 y_pos
// 0x05 spi_cs
// 0x06 divisor
// 0x07 state

// register Description

// dc:		|31'b0|dc_bit|
// 			dc_bit: if set to 0 the byte send is interpreted as a command by the
// 			screen, is set to 1 the byte is interpreted as data to be put on screen.
// sreg: |8'bXXXXXXXX|
// 			actual data to be sent thru mosi
// x_pos |25'b0|x6|x5|x4|x3|x2|x1|x0|
// 			number of actual pixel column on lcd, set at 0 at start, modified
// 			everytime a data byte is sent and set when x is set with commands (dc = 0
// 				and corresponding command, see datasheet page 14)
// y_pos |29'b0|y2|y1|y0|
// 			number of actual row on lcd, set at 0 at start, modified everytime a data
// 			84 bytes are sent and set when y is set with commands (dc = 0 and
// 			corresponding command, see datasheet page 14)

//-----------------------------------------------------------------

module wb_spi(
	input               clk,
	input               reset,
	// Wishbone bus
	input      [31:0]   wb_adr_i,
	input      [31:0]   wb_dat_i,
	output reg [31:0]   wb_dat_o,
	input      [ 3:0]   wb_sel_i,
	input               wb_cyc_i,
	input               wb_stb_i,
	output              wb_ack_o,
	input               wb_we_i,
	// SPI
	output              spi_sck,
	output              spi_mosi,
	input               spi_miso,
	output    			spi_cs_out,
	output 							spi_lcd_rst, // specific signal for nokia lcd
	output 							spi_lcd_dc // specific signal for nokia lcd
);

// wishbone peripherial registers
reg rst_done; // shows if the lcd has already been reset
reg dc; // indicates if the byte being sent is screen data or a lcd command,
// please check see// datasheet.
reg [7:0] spi_cs; // chip select we only use spi_cs[0] for the lcd
reg [7:0] sreg; // actual data to be sent
reg [6:0] x_pos; // cursor position 0-83 (columns)
reg [2:0] y_pos; // cursor position 0-5 (rows)
reg [7:0] divisor; // freq divisor to spi slave
reg [7:0] state; // busy state (sending data ?)

// internal register stuff
reg [2:0] bitcount; // counter for bits sent
reg ilatch; // register to hold miso bit
reg run; // indicates busy state and start condition
reg sck; // slave clock
reg [7:0] prescaler; // hold the value for the freq divider
reg  ack;
// internal register to hold hmode instruction mode specific lcd values
reg hmode;

// specific lcd reset module used to send a reset signal for startup
// please check PCD8544 datasheet page 15
wire o_w_rst_done;
first_reset first_rst0(
	.clk(clk),
	.init(reset),
	.rst(spi_lcd_rst),
	.done(o_w_rst_done)
);

always @ (o_w_rst_done ) begin
	rst_done <= o_w_rst_done;
end
// wishbone ack output
assign wb_ack_o = wb_stb_i & wb_cyc_i & ack;
// read cycle
wire wb_rd = wb_stb_i & wb_cyc_i & ~ack & ~wb_we_i;
// write cycle
wire wb_wr = wb_stb_i & wb_cyc_i & ~ack & wb_we_i;

assign spi_sck = sck;
assign spi_mosi = sreg[7];
assign spi_lcd_dc = dc;
assign spi_cs_out = spi_cs[0];



always @(posedge clk) begin
	if (reset == 1'b1) begin
		ack <= 0;
		sck <= 1'b0;
		bitcount <= 3'b000;
		run <= 1'b0;
		prescaler <= 8'h00;
		divisor <= 8'hff;
		x_pos <= 7'b0000000;
		y_pos <= 3'b000;
		dc <= 0;
		spi_cs <= 8'hF;
		hmode <= 0;
	end else begin
		prescaler <= prescaler + 1;
		if (prescaler == divisor) begin
			prescaler <= 8'h00;
			if (run == 1'b1) begin
				sck <= ~sck;
				if(sck == 1'b1) begin
					bitcount <= bitcount + 1;
					if (bitcount == 3'b001 && dc == 1'b1)
						x_pos <= x_pos + 1;
					if(bitcount == 3'b111) begin
						run <= 1'b0;
						dc <= 1'b1;
						spi_cs <= 8'hF;
						if (x_pos == 7'b101_0011) begin  // if x_pos hits 83 it must be reset to 0 (first col, next row)
							x_pos <= 7'b0000000;
							y_pos <= y_pos + 1; // y_pos row position must go up by 1
							if (y_pos == 3'b101) begin // if y_pos hits 5 it must be reset to 0 (first col, first row)
								y_pos <= 3'b000;
							end
						end
					end
					sreg [7:0] <= {sreg[6:0], ilatch};
				end else begin
					ilatch <= spi_miso;
				end
			end
		end

		ack <= wb_stb_i & wb_cyc_i;
		state <= {7'b0000000 , run};

		if (wb_rd) begin           // read cycle
			case (wb_adr_i[5:2])
				4'b0000: wb_dat_o <= {7'b0000000, rst_done};
				// 4'b0001: wb_dat_o <= {7'b0, dc};
				4'b0010: wb_dat_o <= sreg;
				4'b0011: wb_dat_o <= {1'b0, x_pos};
				4'b0100: wb_dat_o <= {5'b0, y_pos};
				// 4'b0101: wb_dat_o <= ; // no need to read spi_cs
				// 4'b0110: wb_dat_o <= ; // no need to read divisor
				4'b0111: wb_dat_o <= state;
			endcase
		end


		if (wb_wr) begin // write cycle
			case (wb_adr_i[5:2])
			//4'b0000: wb_dat_o <= rst_done;
			4'b0001: dc <= wb_dat_i[0];
			4'b0010: begin
				sreg <= wb_dat_i[7:0];
				if (dc == 1'b0) begin
					if(wb_dat_i [7:3] == 5'b00100 )
						hmode <= wb_dat_i[0];
					if (wb_dat_i[7] == 1'b1 && hmode == 0) begin
						x_pos <= wb_dat_i[6:0];
					end else if (wb_dat_i[7:3] == 5'b01000) begin
						y_pos <= wb_dat_i[2:0];
					end
				end
				run <= 1'b1;
			end
			// 4'b0011: x_pos <= x_pos; // xpos is set by commands
			// 4'b0100: y_pos <= y_pos; // ypos is set by commands
			4'b0101: spi_cs <= wb_dat_i[7:0];
			4'b0110: divisor <= wb_dat_i[7:0];
			// 4'b0111: wb_dat_o <= state; state is set internally
			endcase
		end
	end
end


endmodule
