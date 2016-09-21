`timescale 1ns / 100ps

/*
 * testbench for the button_counter_clocked.v module
 */

module button_counter_clocked_TB;

   // Inputs
   reg reset;
   reg clk;
   reg up;
   reg down;

   // Outputs
   wire [7:0] leds_output;
   
   // Instantiate the Unit Under Test (UUT)
   button_counter_clocked uut (
		               .reset(reset), 
		               .clk(clk), 
		               .up(up), 
		               .down(down), 
		               .leds(leds_output)
	                       );
   
   always
     #5 clk = !clk;
   
   initial begin
      // Initialize Inputs
      reset = 0;
      clk = 0;
      up = 0;
      down = 0;

      // Wait 100 ns for global reset to finish
      #95;
      
      // Add stimulus here
      #20 reset = 1;
      #20 reset = 0;
      
      #20 up = 1;
      #20 up = 1;
      #20 up = 1;
      #20 up = 1;
      #20 up = 1;
      #20 down = 1;
      #20 down = 0;
      #20 up = 0;
      #20 down = 1;
      #20 down = 1;
      #20 down = 1;
      

   end
   
endmodule // button_counter_clocked_TB

