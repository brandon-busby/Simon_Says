`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2017 04:20:28 AM
// Design Name: 
// Module Name: Counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Counter #(parameter MAX_VAL = 1) (output reg [$clog2(MAX_VAL+1)-1:0] Val, input Clk, En, Rst);
    always@(negedge Clk, posedge Rst) begin
        if (Rst)
            Val <= 0;
        else if (En)
        begin
            if (Val >= MAX_VAL)
                Val <= 0;
            else
                Val <= Val + 1;
        end
    end
endmodule
