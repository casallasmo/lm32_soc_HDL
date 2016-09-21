`timescale 1ns / 100ps

/*
 * this module is used to test the draw_scn module
 * it contains the logic to get a value for the opt_scn from 
 * the 16 onboard switches, the start signal for drawing is given with
 * a button, the outputs are the driving lines for the lcd which are 
 * assigned to the pmod A in the .ucf file (nexys 4 board)
 */

module draw_w_switches(clk, switches, draw, done, rst_lcd, sce, dc, mosi, sck);
   
   input clk;
   input [15:0] switches;       // onboard switches
   input        draw;           // onboard button

   output wire  done;           // this can be assigned to a led for checking

   // driving lines for the lcd, assigned to the pmod pins 
   output wire  rst_lcd;
   output wire  sce;
   output wire  dc;
   output wire  mosi;
   output wire  sck;
   
   reg [3:0]    opt_scn;        // the number of the screen that should be drawn

   // logic to get the opt_scn value from the switches
   always @(switches)
     begin
	case(switches)
          
          /*
           * the cases are on binary so each bit represents the state of a switch
           * it's more intuitive for debugging and i am too lazy to put this on hex.
           */
          
	  16'b1000_0000_0000_0000: opt_scn <= 4'h1;
	  16'b0100_0000_0000_0000: opt_scn <= 4'h2;
	  16'b0010_0000_0000_0000: opt_scn <= 4'h3;
	  16'b0001_0000_0000_0000: opt_scn <= 4'h4;
	  16'b0000_1000_0000_0000: opt_scn <= 4'h5;
	  16'b0000_0100_0000_0000: opt_scn <= 4'h6;
	  16'b0000_0010_0000_0000: opt_scn <= 4'h7;
	  16'b0000_0001_0000_0000: opt_scn <= 4'h8;
	  16'b0000_0000_1000_0000: opt_scn <= 4'h9;
	  16'b0000_0000_0100_0000: opt_scn <= 4'ha;
	  16'b0000_0000_0010_0000: opt_scn <= 4'hb;
	  16'b0000_0000_0001_0000: opt_scn <= 4'hc;
	  16'b0000_0000_0000_1000: opt_scn <= 4'hd;
	  16'b0000_0000_0000_0100: opt_scn <= 4'he;
	  16'b0000_0000_0000_0010: opt_scn <= 4'hf;
	  default: opt_scn <= 4'h0;
	endcase
     end
   
   // instatiation of the module
   draw_scn draw_scn0 (
	               .clk(clk), 
	               .init_draw(draw), 
	               .opt_scn(opt_scn), 
	               .done_draw(done),
	               .w_mosi(mosi), 
	               .w_dc_out(dc), 
	               .w_sce(sce), 
	               .w_sck(sck), 
	               .w_rst_scn_out(rst_lcd)
	               );
   
endmodule // draw_w_switches

