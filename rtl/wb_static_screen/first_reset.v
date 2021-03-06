`timescale 1ns / 100ps

/*
 * the screen needs the reset line to be down for some time
 * at startup before any config byte or actual screen data is sent
 * this module pulls the line down at startup and then up again 
 * with a simple counter so the lcd is properly reset, being then ready
 * to receive config bytes and then arbitrary screen data.
 */

module first_reset(clk, init, rst, done);

   input clk;
   input init;
   
   output rst;
   output done;
   
   reg    done = 0;
   reg    rst = 1;
   reg [2:0] counter = 3'b000;
   
   always @(posedge clk)
     if(init)
       begin
          // the rst line is pulled up at first
	  if(rst == 1 && (counter < 3))
	    begin
	       counter <= counter + 1;
	    end
	  // then is forced to go down for the start reset
	  if(rst == 1 && counter == 3)
	    begin
	       counter <= counter + 1;
	       rst <= 0;
	    end
	  // the line goes up again and the lcd is ready to be configured
	  else if(counter == 7)
	    begin
	       rst <= 1;
	       done <= 1;
	    end
	  
	  else
	    counter <= counter + 1;
       end
     else
       rst <= 1;

endmodule // first_reset

