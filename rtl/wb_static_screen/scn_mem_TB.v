`timescale 1ns / 100ps

/*
 * simple testbench for testing the RAM module
 * an address is set along with a read signal to check that 
 * the output data is the correct one, this can be seen while
 * looking at the text file for the address requested
 */

module scn_mem_TB;

   // Inputs
   reg sck;
   reg read;
   reg [12:0] addr;

   // Outputs
   wire [7:0] data_out;

   // Instantiate the Unit Under Test (UUT)
   scn_mem uut (
		.sck(sck), 
		.read(read), 
		.addr(addr), 
		.data_out(data_out)
	        );

   initial begin
      // Initialize Inputs
      sck = 0;
      read = 0;
      addr = 0;

      // Wait 100 ns for global reset to finish
      #100;
      
      // Add stimulus here
   end
   always
     #15 sck = !sck;            // simple clock generator

   /*
    * the address is set first and then the read signal is given
    * a series of addr are given to check if the output matches the
    * text file used to initialize the RAM
    */
   
   initial
     begin
	#25 addr = 9;
	#45 read = 1;
	#40 addr = 19;
	#40 addr = 29;
	#40 addr = 39;
	#40 addr = 49;
	#40 addr = 59;
	#40 addr = 69;
	#40 addr = 7000;
     end
   
endmodule // scn_mem_TB
