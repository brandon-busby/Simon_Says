`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2017 11:54:32 PM
// Design Name: 
// Module Name: Audio_Box
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


module Audio_Box(output AUD_PWM, AUD_SD, input Clk, [3:0] Quadrant);
    wire Clk_Red, Clk_Green, Clk_Yellow, Clk_Blue;
    wire RedSignal, GreenSignal, YellowSignal, BlueSignal;
    
    // module ClockDivider #(parameter DIV = 2) (output reg Clk_Out, input Clk_In, Rst);
    ClockDivider #(.DIV(227273)) RedDivider(.Clk_Out(Clk_Red), .Clk_In(Clk), .Rst(0));
    ClockDivider #(.DIV(606745)) GreenDivider(.Clk_Out(Clk_Green), .Clk_In(Clk), .Rst(0));
    ClockDivider #(.DIV(360776)) YellowDivider(.Clk_Out(Clk_Yellow), .Clk_In(Clk), .Rst(0));
    ClockDivider #(.DIV(303372)) BlueDivider(.Clk_Out(Clk_Blue), .Clk_In(Clk), .Rst(0));
    
    assign RedSignal = Clk_Red & Quadrant[0];
    assign GreenSignal = Clk_Green & Quadrant[1];
    assign YellowSignal = Clk_Yellow & Quadrant[2];
    assign BlueSignal = Clk_Blue & Quadrant[3];
    
    assign AUD_SD = 1;
    assign AUD_PWM = RedSignal ^ GreenSignal ^ YellowSignal ^ BlueSignal;
endmodule
