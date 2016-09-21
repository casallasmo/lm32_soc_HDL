`timescale 1ns / 100ps

/*
 * simple frequency divider implemented with a counter
 * the generated sck is the last bit of the counter
 */

module sck_gen(clk_fpga, sck);
   
   parameter n = 12;
   
   input clk_fpga;
   output sck;
   
   reg [n-1:0] counter;
   
   assign sck = counter[n-1];
   
   initial
     begin
	counter = 1'b0;         // for simulation purposes
     end
   
   always @(posedge clk_fpga)
     begin
	counter = counter + 1'b1; 
     end

endmodule // sck_gen

