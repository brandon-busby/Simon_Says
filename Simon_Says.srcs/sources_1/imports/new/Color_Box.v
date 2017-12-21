`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2017 05:03:05 AM
// Design Name: 
// Module Name: Color_Box
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


module Color_Box(output reg [11:0] Color, input [9:0] HCount, VCount, [3:0] Quadrant);
    parameter BRIGHT_RED = 12'hF22;
    parameter DIM_RED = 12'h711;
    parameter BRIGHT_GREEN = 12'h2F2;
    parameter DIM_GREEN = 12'h171;
    parameter BRIGHT_YELLOW = 12'hFF0;
    parameter DIM_YELLOW = 12'h770;
    parameter BRIGHT_BLUE = 12'h22F;
    parameter DIM_BLUE = 12'h117;
    
    wire InQuadrant0, InQuadrant1, InQuadrant2, InQuadrant3;
    
    
    assign InQuadrant0 = HCount >= 464 && VCount <= 275;
    assign InQuadrant1 = HCount < 464 && VCount <= 275;
    assign InQuadrant2 = HCount < 464 && VCount > 275;
    assign InQuadrant3 = HCount >= 464 && VCount > 275;

    always @ (*) begin
        if (InQuadrant0)
            Color <= Quadrant[0] ? BRIGHT_RED : DIM_RED;
        else if (InQuadrant1)
            Color <= Quadrant[1] ? BRIGHT_GREEN : DIM_GREEN;
        else if (InQuadrant2)
            Color <= Quadrant[2] ? BRIGHT_YELLOW : DIM_YELLOW;
        else if (InQuadrant3)
            Color <= Quadrant[3] ? BRIGHT_BLUE : DIM_BLUE;
        else
            Color <= 0;
    end

endmodule
