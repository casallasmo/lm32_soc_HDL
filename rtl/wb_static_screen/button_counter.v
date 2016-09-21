`timescale 1ns / 100ps

////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////
//
//module button_counter_clocked(clk, left, right, led1, led2, led3);
//	
//	input left;
//	input right;
//	
//	output reg led1;
//	output reg led2;
//	output reg led3;
//	
//	reg [1:0] counter;
//	
//	wire w_clk
//
//always @(counter)
//begin
//case(counter)
//		2'b00:
//			begin
//			led1 <= 1'b0;
//			led2 <= 1'b0;
//			led3 <= 1'b0;
//			end
//		2'b01:
//			begin
//			led1 <= 1'b1;
//			led2 <= 1'b0;
//			led3 <= 1'b0;
//			end
//		2'b10:
//			begin
//			led1 <= 1'b1;
//			led2 <= 1'b1;
//			led3 <= 1'b0;
//			end
//		2'b11:
//			begin
//			led1 <= 1'b1;
//			led2 <= 1'b1;
//			led3 <= 1'b1;
//			end
//		default:
//			begin
//			led1 = 1'b1;
//			led2 = 1'b0;
//			led3 = 1'b1;
//			end
//	endcase
//end
//	
//	
//endmodule
