`timescale 1ns / 100ps

/*
 * finite state machine for the draw_scn.v module
 */

module draw_control (sck, rst_in, spi_done, init_in, x, add, done, start_spi, read_mem, rst_out );

   // input control signals for the machine
   input sck;
   input rst_in;
   input spi_done;
   input init_in;
   input x;

   // output control signals for lower hierarchy modules
   output reg rst_out;
   output reg done;
   output reg add;
   output reg start_spi;
   output reg read_mem;
   
   // definition of the states for the machine
   parameter SEND = 3'b001;
   parameter ADD = 3'b010;
   parameter DONE = 3'b100;
   
   reg [2:0]  state;
   
   // state transition logic
   always @(negedge sck) begin

      case(state)

	DONE:begin
	   if(init_in && spi_done)
	     state = SEND;
           else
	     state = DONE;
	end
	
	SEND:begin
	   if(!spi_done)
	     state = SEND;
	   else	
	     state= ADD;
	end
	
	ADD:begin
	   if(x)
	     state = DONE;
	   else
	     state = SEND;
	end

	default:
	  state = DONE;
	
      endcase

   end

   // output control signals definition for the states
   always @(state) begin
      
      case(state)
	
 	SEND:begin
	   rst_out = 0;
	   read_mem = 1;
	   start_spi = 1;
	   add = 0;
	   done = 0;
 	end
	
	ADD:begin
	   rst_out = 0;
	   read_mem = 1;
	   start_spi = 0;
	   add = 1;
	   done = 0;
	end
	
	DONE:begin
	   rst_out = 1;
	   read_mem = 1;
	   start_spi = 0;
	   add = 0;
	   done = 1;
	end
	
      endcase
   end
   
endmodule // draw_control

