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
reg    rst = 1'b1;
reg [7:0] counter = 8'b0;

wire init_sgn;
reg aux1;
reg aux2 = 1'b1;

assign init_sgn = aux1 && aux2;

always @ ( posedge init ) begin
    aux1 <= 1'b1;
end

always @(posedge clk) begin

    if(init_sgn) begin

        // the rst line is pulled up at first
        if(rst == 1 && (counter < 128))
            counter <= counter + 1;

        // then is forced to go down for the start reset
        if(rst == 1 && counter == 128) begin
            counter <= counter + 1;
            rst <= 0;
        end
        // the line goes up again and the lcd is ready to be configured
        if(counter == 255) begin
            rst <= 1;
            done <= 1;
            aux2 <= 1'b0;
        end

        counter <= counter + 1;
    end
end

endmodule // first_reset
