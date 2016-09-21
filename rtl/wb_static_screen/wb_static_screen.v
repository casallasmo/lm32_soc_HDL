//---------------------------------------------------------------------------
// Wishbone static_screen module
//
// Register Description:
//
//    0x00 scr_stt      [ o_w_done | wb_dat_i[14:0]]
//
//---------------------------------------------------------------------------

module wb_static_screen (

	input              clk,
	input              reset,
	// Wishbone interface
	input              wb_stb_i,
	input              wb_cyc_i,
	output             wb_ack_o,
	input              wb_we_i,
	input       [31:0] wb_adr_i,
	input        [3:0] wb_sel_i,
	input       [31:0] wb_dat_i,
	output reg  [31:0] wb_dat_o,
	// pinout to lcd screen
	output		o_w_dc,
	output          o_w_mosi,
	output		o_w_rst_lcd,
	output		o_w_sce,
	output		o_w_sck
);

//---------------------------------------------------------------------------
// screen modul instance and wiring
//---------------------------------------------------------------------------

wire [15:0] i_w_select_scn;
wire i_w_draw;
wire o_w_done

draw_w_switches(
		.clk(clk),
		.switches(i_w_select_scn),
		.draw(i_w_draw),
		.done(o_w_done),
		.rst_lcd(o_w_rst_lcd),
		.sce(o_w_dc),
		.dc(o_w_dc),
		.mosi(o_w_mosi),
		.sck(o_w_sck)
);

//---------------------------------------------------------------------------
//  internal wishbone signal logic
//---------------------------------------------------------------------------

assign i_w_select_scn = wb_dat_i[15:0];

// screen state register
wire [15:0] scr_stt = { o_w_done, i_w_select_scn[14:0] };

// internal write and read signals for wishbone
wire wb_rd = wb_stb_i & wb_cyc_i & ~wb_we_i;
wire wb_wr = wb_stb_i & wb_cyc_i &  wb_we_i;

reg  ack;
assign wb_ack_o = wb_stb_i & wb_cyc_i & ack;

always @(posedge clk)
begin
	if (reset) begin
		wb_dat_o <= 32'b0;
		i_w_draw <= 0;
		ack    <= 0;
	end
	else begin
		wb_dat_o <= 32'b0;
		i_w_draw <= 0;
		ack    <= 0;
		if (wb_rd & ~ack) begin
			ack <= 1;

			case (wb_adr_i[5:2])
			3'b001: begin
				wb_dat_o[15:0] <= scr_stt;
			end
			default: begin
				wb_dat_o[15:0] <= 16'b0;
			end
			endcase
		end else if (wb_wr & ~ack ) begin
			ack <= 1;

			if ((wb_adr_i[5:2] == 3'b1) && done) begin
				w <= 1;
			end
		end
	end
end


endmodule
