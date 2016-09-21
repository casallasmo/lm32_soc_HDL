`timescale 1ns / 1ps

/*
 * this module receives an address as input, checks if the address if less than 5
 * (the config bytes are stored on the first five addresses of the ram)
 * and depending on this conditions sets the dc line at 1 or 0 indicating that
 * the byte in that address is a command for the lcd configuration or is actual 
 * data that should be shown on the screen.
 * it should go until 5 since this is the number of bytes needed for the initial 
 * configuration of the screen (pcd8544), for some reason the dc line goes up 
 * (indicating that the actual byte is data) on the fifth and last config byte
 * but it should be on 0, this was checked with a post-place & route model simulation
 * 
 * the problem was fixed using
 *      if(addr < 6)
 */

module dc_set(sck, addr, dc_val);

   parameter SIZE = 13;

   input sck;
   input [SIZE-1:0] addr;
   output reg       dc_val;

   always @(posedge sck)
     begin
        if(addr < 6)
          dc_val <= 0;          // if the address begin requested is that of a config byte then dc = 0
        else
          dc_val <= 1;          // the other addresses are screen data so dc = 1
     end
endmodule // dc_set

