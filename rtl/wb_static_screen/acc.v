`timescale 1ns / 1ps

/*
 * This accumulator module counts in steps of one when the signal add1
 * is given, the rst signal puts the count in zero, if no signal is given
 * it holds the old value of count
 */

module acc (sck, rst, add1, count);
   
   parameter SIZE = 8;
   
   input sck;
   input rst;
   input add1;

   output reg [SIZE-1:0] count = 0;

   always @(posedge sck)
     if(rst)
       count = 1'b0;
     else
       begin
	  if(add1)
	    count = count + 1'b1;
	  else
	    count = count;
       end
   
endmodule // acc

