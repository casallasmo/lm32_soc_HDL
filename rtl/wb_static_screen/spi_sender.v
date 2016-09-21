`timescale 1ns / 100ps

/*
 * spi transmission module, it drives the five pins on the nexys pmod
 * connected to the lcd screen (nokia 5110 pcd8544)
 * features the startup reset needed to set the screen ready for configuration bytes
 * the configuration bytes are stored on an external RAM so they can be changed from 
 * outside this module
 * 
 * the higher hierarchy module draw_scn.v interfaces this module with the ram in question
 */

module spi_sender(clk, data, spi_start, dc_in, mosi, dc_out, sce, sck, rst_scn_neg, spi_done);

   parameter DATA_SIZE = 8;
   parameter COUNTER_SIZE = 4;

   input clk; // fpga internal clock
   input [DATA_SIZE-1:0] data;
   input                 spi_start;
   input                 dc_in;
   
   output                mosi; // pmod output to LCD screen
   output wire           dc_out;  // pmod output to LCD screen indicating data0 command
   output reg            sce; // pmod output to LCD select chip enable
   output reg            sck; // clock from the fpga to the sck screen input
   output reg            rst_scn_neg; // pmod output to rst signal on LCD screen
   output reg            spi_done; // onboard LED indicating end of data transfer
   
   reg [DATA_SIZE-1:0]   data_reg;
   wire                  w_reset; // reset signal for lower hierarchy modules
   wire                  w_add1;  // add signal for the bit counter
   wire [COUNTER_SIZE-1:0] w_count; // actual value of the counter module
   wire                    w_x; // done signal from the control machine
   wire                    w_shft; // shift signal from the control machine to the left shift module
   wire [DATA_SIZE-1:0]    w_data_s; // shifted data from the left shift module to the msb module
   wire                    w_sck; // general sck clock signal for the modules from the sck_gen frequency divider
   
   wire                    w_sce;
   wire                    w_rst_scn;
   wire                    w_spi_done;
   wire                    w_f_rst_done;
   wire                    w_f_rst_init;
   
   /*
    * all the always should be checked to 
    * see if they are redundant
    * fixme  
    */
   
   always @(data)
     begin
	data_reg <= data;
     end
   
   always @(w_sck)
     begin
	sck <= w_sck;
     end
   
   always @(w_sce)
     begin
	sce <= w_sce;
     end
   
   always @(negedge w_sck)
     begin
	rst_scn_neg <= w_rst_scn;
     end
   
   always @(w_spi_done)
     begin
	spi_done <= w_spi_done;
     end
   
   assign dc_out = dc_in;
   
   first_reset reset0 (
	               .init(w_f_rst_init),
	               .clk(sck), 
	               .rst(w_rst_scn),
	               .done(w_f_rst_done)
	               );
   
   sck_gen sck_common(
	              .clk_fpga(clk),
	              .sck(w_sck)
	              );
   
   msb_mosi #(DATA_SIZE) msb0(
	                      .sck(w_sck),
	                      .data_s(w_data_s),
	                      .mosi(mosi)
	                      );
   
   acc #(COUNTER_SIZE) acc0(
	                    .sck(w_sck),
	                    .rst(w_reset),
	                    .add1(w_add1),
	                    .count(w_count)
	                    );
   
   comp #(COUNTER_SIZE,DATA_SIZE) comp0(
	                                .count(w_count),
	                                .x(w_x)
	                                );
   
   lshft #(DATA_SIZE) lshft0(
	                     .sck(w_sck),
	                     .load(w_reset),
	                     .shft(w_shft),
	                     .data(data_reg),
	                     .data_s(w_data_s)
	                     );
   
   spi_control spi_control0(
	                    .sck(w_sck),
	                    .rst_in(!spi_start),// this signal is never used, fixme
	                    .init_in(spi_start),
	                    .x(w_x),
	                    .csel(w_sce),
	                    .shft(w_shft),
	                    .add1(w_add1),
	                    .done(w_spi_done),
	                    .rst_out(w_reset),
	                    .f_rst_init(w_f_rst_init),
	                    .f_rst_done(w_f_rst_done)
	                    );
   
endmodule // spi_sender

