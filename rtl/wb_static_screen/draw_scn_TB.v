`timescale 1ns / 1ps

/*
 * testbench fot the draw_scn.v module
 */

module draw_scn_TB;

   // Inputs
   reg clk;
   reg init_draw;
   reg [3:0] opt_scn;

   // Outputs
   wire      done_draw;

   // Instantiate the Unit Under Test (UUT)
   draw_scn uut (
		 .clk(clk), 
		 .init_draw(init_draw), 
		 .opt_scn(opt_scn), 
		 .done_draw(done_draw)
	         );

   initial begin
      // Initialize Inputs
      clk = 0;
      init_draw = 0;
      opt_scn = 0;

      // the lcd has time for reseting, after that time the opt_scn and init_draw can be set
      // opt_scn should be set before forcing init_draw to 1
      #348155
	#0 opt_scn = 4'b0000;
      #40960  init_draw = 1'b1;
      #40960 init_draw = 1'b0;


      // it takes around 210ms for a screen to be drawn
      // after 220ms the opt_scn is changed and init_draw is triggered to see if the module
      // is working as it should
      #220000000
	#0 opt_scn = 4'b0001;
      #40960 init_draw = 1'b1;
      #204800 init_draw = 1'b0;
      
   end
   
   always
     #5 clk = !clk;             // generating a simple clock
   
endmodule // draw_scn_TB

