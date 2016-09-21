`timescale 1ns / 100ps
`define SIMULATION

module spi_sender_TB;
   
   // inputs
   reg clk;
   reg [7:0] data_1 = 8'b1010_1010; 
   reg [7:0] data_2 = 8'b1100_1100; 
   reg       spi_start;
   reg       dc_in;
   
   reg [7:0] data;

   

   // outputs
   wire      mosi;
   wire      dc_out;
   wire      sce;
   wire      sck;
   wire      rst_scn_neg;
   wire      spi_done;

   spi_sender uut(
	          .clk(clk), 
	          .data(data), 
	          .spi_start(spi_start), 
	          .dc_in(dc_in), 
	          .mosi(mosi), 
	          .dc_out(dc_out), 
	          .sce(sce), 
	          .sck(sck), 
	          .rst_scn_neg(rst_scn_neg), 
	          .spi_done(spi_done)
	          );
   
   always
     #5 clk = !clk;
   
   initial 
     begin // assign values to inputs
	clk = 1'b1;
	#0 data <= data_1;
	#348150
	  #0 spi_start = 0;
	#0 dc_in = 1;
	#40960 spi_start = 1;
	#81920 spi_start = 0;
     end

   initial
     begin
	#778230 data <= data_2;
	#40960 spi_start = 1;
	#81920 spi_start = 0;
     end
   

endmodule
