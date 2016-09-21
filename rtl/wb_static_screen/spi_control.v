`timescale 1ns / 100ps

/*
 * finite state machine for the spi_sender.v module
 * 
 * 
 */

module spi_control(sck, rst_in, init_in, x, csel, shft, add1, done, rst_out, f_rst_init, f_rst_done);

   // input control signals
   input sck;
   input f_rst_done;
   input rst_in;                // this signal is never used, fixme along with the instatiations
   input init_in;
   input x;

   // output control signals
   output reg rst_out;
   output reg csel;
   output reg shft;
   output reg add1;
   output reg done;
   output reg f_rst_init;
   
   // definition of the states for the machine
   parameter RESET = 3'b001;
   parameter START = 3'b000;
   parameter SHIFT = 3'b010;
   parameter DONE = 3'b100;
   
   reg [2:0]  state;            // to hold the actual state of the machine
   
   // state transition logic
   always @(negedge sck) begin
      case(state)

	RESET:begin
	   if(f_rst_done)
	     state = DONE;
	   else
	     state = RESET;
	end

	DONE:begin
	   if(init_in)
	     state = SHIFT;
	   else
	     state = DONE;
	end

	SHIFT:begin
	   if(x)
	     state = DONE;
	   else
	     state = SHIFT;
	end

	default:
	  state = RESET;

      endcase
   end



   // output control signal definitions for the states
   always @(state) begin
      case(state)
	
	RESET:begin
	   rst_out = 1;
	   csel = 0;
	   shft = 0;
	   add1 = 0;
	   done = 0;
	   f_rst_init = 1;
	end
	
	SHIFT:begin
	   rst_out = 0;
	   csel = 0;
	   shft = 1;
	   add1 = 1;
	   done = 0;
	   f_rst_init = 0;
	end
	
	DONE:begin
	   rst_out = 1;
	   csel = 1;
	   shft = 0;
	   add1 = 0;
	   done = 1;
	   f_rst_init = 0;
	end
	
      endcase
   end
   
endmodule // spi_control

