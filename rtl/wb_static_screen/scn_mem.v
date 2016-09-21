`timescale 1ns / 100ps

/*
 * RAM memory that stores all the data for the lcd screen
 * it includes the config bytes and the rest of the menu screens
 * the memory is initialized with a external text file
 */

module scn_mem(sck, read, addr, data_out);

   parameter ADDR_SIZE = 13;
   parameter RAM_DEPTH = 8069;
   parameter RAM_WIDTH = 8;
   
   input sck;
   input read;                  // read signal that 
   input [ADDR_SIZE-1:0] addr;  // the address set by external modules

   output reg [RAM_WIDTH-1:0] data_out;

   // creation of the array variable so the XST infeers a RAM 
   reg [RAM_WIDTH-1:0]        scrn_data [0:RAM_DEPTH];

   // loading the data from a properly formated text file
   initial $readmemh("ram_data.c", scrn_data);
   
   always @(negedge sck)
     begin
        if (read)
          data_out <= scrn_data[addr]; // puts the data requested in the output bus
        else
          data_out <= data_out;
     end
   
endmodule // scn_mem

