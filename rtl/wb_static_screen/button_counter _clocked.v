`timescale 1ns / 100ps

/*
 * This module is intended to receive inputs from the fpga buttons
 * to change the value of a counter, the value of the input is sampled
 * at the posedge of a sck signal generated with the frequency divider
 * sck_gen.v, the frequency is set to be slow enough so the counter does
 * not goes up too quickly when any of the up or down inputs are 1 (pressed
 * buttons), the value of the counter is shown using the onboard leds.
 * 
 */

module button_counter_clocked(reset, clk, up, down, leds);
   
   parameter SIZE = 7;
   
   input reset;                 // onboard button or similar
   input clk;                   // fpga clk
   input up;                    // onboard button or similar
   input down;                  // onboard button or similar
   
   output reg [SIZE:0] leds;    // reg holding the values for the leds 
   
   reg [2:0]           counter;
   wire                w_sck;   // for the output the sck_gen freq divider
   
   sck_gen #(24) sck_slow(
	                  .clk_fpga(clk),
	                  .sck(w_sck)
	                  );    // frequency divider module

   // actual counter logic 
   always @(posedge w_sck)
     begin
	if(reset)
	  counter = 1'b0;
	else if(up && !down)
	  counter = counter + 1'b1;
	else if (down && !up)
	  counter = counter - 1'b1;
	else
	  counter = counter;
     end
   
   // combinational logic to assign led values
   always @(counter)
     begin
	case(counter)
	  3'b000: leds <= 8'b0000_0000;
	  3'b001: leds <= 8'b0000_0001;
	  3'b010: leds <= 8'b0000_0011;
	  3'b011: leds <= 8'b0000_0111;
	  3'b100: leds <= 8'b0000_1111;
	  3'b101: leds <= 8'b0001_1111;
	  3'b110: leds <= 8'b0011_1111;
	  3'b111: leds <= 8'b0111_1111;
	  default: leds <= 8'b1111_1111;
	endcase
     end
   
   
endmodule // button_counter_clocked

