`timescale 1ns / 100ps

/*
 * simple module that extracts the msb of a 
 * register used to drive the mosi/din pin on the lcd
 * input data_s is the shifted data given by the lshift module
 * 
 */

module msb_mosi(sck, data_s, mosi);
   
   parameter SIZE = 8;          // default data size
   
   input sck;
   input [SIZE-1:0] data_s;

   // drives the din/mosi nexys pmod assigned pin
   output reg       mosi;       
   
   always @(negedge sck)
     mosi <= data_s[SIZE-1];

endmodule // msb_mosi

