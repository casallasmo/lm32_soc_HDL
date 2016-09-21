`timescale 1ns / 1ps

module draw_w_switches_TB;

   // Inputs
   reg clk;
   reg [15:0] switches;
   reg        draw;

   // just to check that transmission has ended
   wire       done;
   
   // Outputs, driving lines for the lcd
   wire       rst_lcd;
   wire       sce;
   wire       dc;
   wire       mosi;
   wire       sck;

   // Instantiate the Unit Under Test (UUT)
   draw_w_switches uut (
		        .clk(clk), 
		        .switches(switches), 
		        .draw(draw), 
		        .done(done), 
		        .rst_lcd(rst_lcd), 
		        .sce(sce), 
		        .dc(dc), 
		        .mosi(mosi), 
		        .sck(sck)
	                );

   initial begin
      // Initialize Inputs
      clk = 0;
      switches = 0;
      draw = 0;

      // we wait for the initial reset of the lcd to finish and then
      // set the opt_scn with the switches, push the button and the
      // transmission should start
      #348155
	#0 switches = 16'b1000_0000_0000_0000;
      #40960 draw = 1'b1;
      #40960 draw = 1'b0;

   end
   
   always
     #5 clk = !clk;             // simple clock generator for simulation
   

endmodule // draw_w_switches_TB

