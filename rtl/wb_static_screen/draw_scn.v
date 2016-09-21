`timescale 1ns / 100ps

/*
 * this module interfaces a ram memory with the spi_sender module
 * the ram memory contains the lcd config bytes in the first five addresses
 * and the rest is actual screen data previously defined and translated to hex
 * from .png images usign the following tool
 * 
 * https://github.com/riuson/lcd-image-converter 
 * http://www.riuson.com/lcd-image-converter
 * 
 * relevant inputs are opt_scn and init_draw, 
 * opt_scn indicates the number of the  screen that should be drawn on the lcd
 * init_draw starts the sequential reading and sending of data that draws the desired
 * screen on the lcd.
 * 
 * the outputs are just the signals that drive the lcd and go the pmod pins
 * 
 */

module draw_scn(clk, init_draw, opt_scn, done_draw,
		w_mosi, w_dc_out, w_sce, w_sck, w_rst_scn_out);
   
   parameter COUNTER_SIZE = 9;
   parameter NUM_BYTES = 504;   // 504 are the number of bytes to draw a full screen
   parameter DATA_SIZE = 8;     // groups of 8 bits are read and sent sequentially
   
   input clk;
   input init_draw;
   input [3:0] opt_scn;         // the value of the desired screen
   
   output reg  done_draw;       // done output, indicates that a whole screen has been drawn

   // output signals that drive the lcd screen
   output wire w_sck;
   output wire w_dc_out;
   output wire w_rst_scn_out;
   output wire w_sce;
   output wire w_mosi;

   wire [COUNTER_SIZE-1:0] sent_bytes; // when it hits 504, a whole screen has been drawn

   wire [DATA_SIZE-1:0]    w_data; // connects the output of the ram with the input of the spi_sender

   // wiring between state machine and datapath modules   
   wire                    w_rst;
   wire                    w_add;
   wire                    w_x;
   wire                    w_spi_done;
   wire                    w_done_ctrl;
   wire                    w_start_spi;
   wire                    w_read_mem;

   wire                    w_dc_in; // carries the value of the dc line

   reg [12:0]              init_addr; // stores the initial address depending on the value of opt_scn
   reg [12:0]              var_addr;  // stores the value of the address, possibly redundant, fixme.
   
   wire [12:0]             w_var_addr;      // carries the value of the address, this bus should be enough for it,

   
   // the value of the reg done_draw is set, xst outputs a warning saying this is equivalent to a wire
   // this needs to be removed and tested, fixme
   always @(w_done_ctrl)
     begin
	done_draw <= w_done_ctrl;
     end

   
   // the value of the reg var_addr is set, xst outputs a warning saying this is equivalent to a wire
   // this needs to be removed and tested, fixme
   always @(w_var_addr)
     begin
	var_addr <= w_var_addr;
     end

   
   // depending on opt_scn, the value of the inital address for the corresponding screen is set
   always @(opt_scn)
     begin
	case(opt_scn)
	  4'h0: init_addr = 0;
	  4'h1: init_addr = 509;
	  4'h2: init_addr = 1013;
	  4'h3: init_addr = 1517;
	  4'h4: init_addr = 2021;
	  4'h5: init_addr = 2525;
	  4'h6: init_addr = 3029;
	  4'h7: init_addr = 3533;
	  4'h8: init_addr = 4037;
	  4'h9: init_addr = 4541;
	  4'ha: init_addr = 5045;
	  4'hb: init_addr = 5549;
	  4'hc: init_addr = 6053;
	  4'hd: init_addr = 6557;
	  4'he: init_addr = 7061;
	  4'hf: init_addr = 7565;
	endcase;
     end

   
   scn_mem memoria0 (
	             .sck(w_sck),
	             .read(w_read_mem),
	             .addr(var_addr),
	             .data_out(w_data)
	             );
   
   acc_input acc_addr0 (
	                .sck(w_sck),
	                .rst(w_rst),
	                .add1(w_add),
	                .init_val(init_addr),
	                .count(w_var_addr)
	                );
   
   acc #(COUNTER_SIZE) sent_counter0 (
	                              .sck(w_sck), 
	                              .rst(w_rst), 
	                              .add1(w_add && w_dc_in), 
	                              .count(sent_bytes)
	                              );

   comp #(COUNTER_SIZE, NUM_BYTES) comp0 (
	                                  .count(sent_bytes), 
	                                  .x(w_x)
	                                  );
   
   dc_set dc_set0(
	          .sck(w_sck),
	          .addr(var_addr),
	          .dc_val(w_dc_in)
	          );

   
   spi_sender sender0 (                       
	                                      .clk(clk), 
	                                      .data(w_data), 
	                                      .spi_start(w_start_spi), 
	                                      .dc_in(w_dc_in),
	                                      .mosi(w_mosi), 
	                                      .dc_out(w_dc_out), 
	                                      .sce(w_sce), 
	                                      .sck(w_sck), 
	                                      .rst_scn_neg(w_rst_scn_out),
	                                      .spi_done(w_spi_done)
	                                      );
   
   draw_control control0 (
	                  .sck(w_sck), 
	                  .rst_in(init_draw), 
	                  .spi_done(w_spi_done), 
	                  .init_in(init_draw), 
	                  .x(w_x),
	                  .add(w_add), 
	                  .done(w_done_ctrl), 
	                  .start_spi(w_start_spi), 
	                  .read_mem(w_read_mem), 
	                  .rst_out(w_rst) 
	                  );
   
endmodule // draw_scn

