`timescale 1ns / 1ps

/*
 * this module is a modification of acc.v
 * the input init_val allows to set an initial value
 * to start the count, as in the acc.v module add1 signal
 * adds 1 to count, if rst is given the value of count is that
 * of init_val
 * 
 */

module acc_input (sck, rst, add1, init_val, count);
   
   parameter SIZE = 13;
      
   input sck;
   input rst;
   input add1;
   input [SIZE-1:0] init_val;   // initial value set by an external module
   
   output reg [SIZE-1:0] count = 0;

   always @(posedge sck)
     if(rst)
       count = init_val;
     else
       begin
	  if(add1)
	    count = count + 1'b1;
	  else
	    count = count;
       end

endmodule // acc_input

