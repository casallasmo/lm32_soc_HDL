`timescale 1ns / 100ps

/*
 * simple testbench for the frequency divider sck_gen.v
 * testing with two generated clocks
 */

module sck_gen_TB;
   
   reg clk;
   wire sck_1;                  // two slave clocks for testing
   wire sck_2;
   
   sck_gen #(4) clock1(
 	               .clk_fpga(clk),
 	               .sck(sck_1)
 	               );

   sck_gen #(2) clock2(
 	               .clk_fpga(clk),
 	               .sck(sck_2)
 	               );
   
   initial
     clk = 0;
   always
     #5 clk = !clk;             // this would be the fpga internal clock
   
endmodule // sck_gen_TB

