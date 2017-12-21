`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2017 04:32:59 AM
// Design Name: 
// Module Name: Wrapper
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


module Wrapper(output AUD_PWM, AUD_SD, VGA_HS, VGA_VS, [3:0] VGA_R, VGA_G, VGA_B, LED, input Rst, CLK100MHZ, BTNU, BTNL, BTNR, BTND);
    wire Clk;
    wire [9:0] HCount, VCount;
    wire [11:0] Color;
    wire [3:0] BtnInput, Btn;
    wire [3:0] Quadrant;
    
    assign BtnInput = {BTNR, BTND, BTNL, BTNU};
    
    // module Debouncer #(parameter FREQ = 1, WIDTH = 1) (output reg [WIDTH-1:0] Btn_Out, input Clk, [WIDTH-1:0] Btn_In);
    Debouncer #(.FREQ(100000000/4), .WIDTH(4)) DeBoun(.Btn_Out(Btn), .Clk(Clk), .Btn_In(BtnInput));
    
    assign LED = Btn;
    
    // module ClockDivider #(parameter DIV = 2) (output reg Clk_Out, input Clk_In, Rst);
    ClockDivider #(.DIV(4)) CD(.Clk_Out(Clk), .Clk_In(CLK100MHZ), .Rst(0));
    // module Counter #(parameter MAX_VAL = 1) (output reg [$clog2(MAX_VAL+1)-1:0] Val, input Clk, En, Rst);
    Counter #(.MAX_VAL(799)) HCounter(.Val(HCount), .Clk(Clk), .En(1), .Rst(0));
    Counter #(.MAX_VAL(524)) VCounter(.Val(VCount), .Clk(HCount[$clog2(800)-1]), .En(1), .Rst(0));
    // module VGA_Controller(output HS, VS, [11:0] Color_Out, input [9:0] HCount, VCount, [11:0] Color_In);
    VGA_Controller Display(.HS(VGA_HS), .VS(VGA_VS), .Color_Out({VGA_R, VGA_G, VGA_B}), .HCount(HCount), .VCount(VCount), .Color_In(Color));
    // module Game_Controller(output reg [3:0] Quadrant, input Clk, Rst, [3:0] Btn);
    Game_Controller GC(.Quadrant(Quadrant), .Clk(Clk), .Rst(Rst), .Btn(Btn));
    // module Audio_Box(output AUD_PWM, AUD_SD, input Clk, [3:0] Quadrant);
    Audio_Box AB(.AUD_PWM(AUD_PWM), .Clk(CLK100MHZ), .Quadrant(Quadrant));
    // module Color_Box(output reg [11:0] Color, input [9:0] HCount, VCount, [1:0] Quadrant);
    Color_Box CB(.Color(Color), .HCount(HCount), .VCount(VCount), .Quadrant(Quadrant));
endmodule
