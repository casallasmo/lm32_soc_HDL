`timescale 1ns / 100ps

/*
 * simple testbench to test the first_reset.v module
 * really simple
 */

module first_reset_TB;

   // Inputs
   reg clk;

   // Outputs
   wire rst;
   wire done;

   // Instantiate the Unit Under Test (UUT)
   first_reset uut (
		    .clk(clk), 
		    .rst(rst),
		    .done(done)
	            );

   initial begin
      // Initialize Inputs
      clk = 0;

      // Wait 100 ns for global reset to finish
      #100;
      
      // Add stimulus here

   end

   always
     #640 clk = !clk;           // simple clock generator
   
endmodule // first_reset_TB

