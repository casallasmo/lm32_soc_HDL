`timescale 1ns / 100ps

/*
 * comparator module receives as input a count value and gives
 * as output a x signal indicating if count equals the parameter
 * MAX_VAL
 * 
 */

module comp(count, x);
   
   parameter SIZE = 3;
   parameter MAX_VAL = 8;
   
   input [SIZE-1:0] count;
   output           x;
   reg              tmp;
   
   initial tmp = 0;
   assign x = tmp;
   
   always @(*)
     tmp = (count == MAX_VAL) ? 1'b1 : 1'b0; 
   // fancy ternary operator that sets the value for tmp
   
endmodule // comp

