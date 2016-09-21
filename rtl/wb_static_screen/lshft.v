`timescale 1ns / 100ps

/*
 * simple left shift module
 * the inputs are two signals, load and shft
 * and one data input that holds the actual data sent to the lcd
 * the internal register data_s holds the shifted data that is sent
 * to the msb_mosi.v module that extracts the msb that is sent to the
 * screen through the mosi/din pin, it is also used to check if the
 * transmission of a byte has ended checking if it's value is cero with
 * the comp.v module
 */

module lshft(sck, load, shft, data, data_s);
   
   parameter SIZE = 8;          // default size
   
   input sck;
   input load;                  // input control signal
   input shft;                  // input control signal
   input [SIZE-1:0] data;
   
   output reg [SIZE-1:0] data_s; // shifted data
   
   always @(posedge sck)
     if(load)
       data_s = data;           // loading the data to be shifted
     else
       begin
	  if(shft)
	    data_s = data_s << 1; // the data is shifted to send all the bytes
	  else
	    data_s = data_s;
       end
   
endmodule // lshft

