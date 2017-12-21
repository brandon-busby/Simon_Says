`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2017 01:09:34 PM
// Design Name: 
// Module Name: Game_Controller
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


module Game_Controller(output reg [3:0] Quadrant, input Clk, Rst, [3:0] Btn);
    parameter RED = 2'b00;
    parameter GREEN = 2'b01;
    parameter YELLOW = 2'b10;
    parameter BLUE = 2'b11;
    parameter SEQLEN_MAX = 8;
    parameter [2*SEQLEN_MAX-1:0] Seq = {RED, YELLOW, RED, BLUE, YELLOW, GREEN, BLUE, RED};
    // SeqLen is the greatest seq position the player has reached so far
    // SeqCount is the seq position currently under consideration
    reg [$clog2(SEQLEN_MAX+1)-1:0] SeqCnt, SeqLen, SeqCnt_next, SeqLen_next;
    wire [1:0] SeqColor;
    
    parameter TIMER_MAX = 12500000;
    reg [$clog2(TIMER_MAX+1)-1:0] Timer, Timer_next;
    
    parameter WAIT = 0;
    parameter SIMON_TURN = 1;
    parameter PLAYER_TURN = 2;
    parameter WAIT_BTN_UP = 3;
    
    reg [1:0] State, State_next;
    
    // this defines the state register
    // update state values (State_next, TimerVal_next, SeqCnt_next, SeqLen_next)
    always @ (posedge Clk, posedge Rst) begin
        if (Rst) begin
            State <= WAIT;
            Timer <= 0;
            SeqCnt <= 0;
            SeqLen <= 0;
        end
        else begin
            State <= State_next;
            Timer <= Timer_next;
            SeqCnt <= SeqCnt_next;
            SeqLen <= SeqLen_next;
        end
    end
    
    assign SeqColor = Seq >> (SeqCnt << 1);
    
    // combinational logic
    // defines values for (State_next, Timer_next, SeqCnt_next, SeqLen_next, Quadrant)
    always @ (*) begin
        Timer_next <= Timer;
        SeqCnt_next <= SeqCnt;
        SeqLen_next <= SeqLen;
        Quadrant <= 0;
        case (State)
            WAIT: begin
                Timer_next <= 0;
                SeqCnt_next <= 0;
                SeqLen_next <= 0;
                Quadrant <= Btn;
                // wait for a button to be pressed before starting the game
                if (Btn == 4'b1111) State_next <= SIMON_TURN;
                else State_next <= WAIT;
            end
            SIMON_TURN: begin
                if (SeqLen >= SEQLEN_MAX) begin
                    State_next <= WAIT;
                end
                // check if finished playing the sequence
                else begin
                    if (SeqCnt <= SeqLen) begin
                        State_next <= SIMON_TURN;
                        Quadrant <= 1 << SeqColor;
                        // check if ready to display next sequence element
                        if (Timer < TIMER_MAX) begin
                            Timer_next <= Timer + 1;
                        end
                        else begin
                            SeqCnt_next <= SeqCnt + 1;
                            Timer_next <= 0;
                        end
                    end
                    else begin
                        State_next <= PLAYER_TURN;
                        SeqCnt_next <= 0;
                    end
                end
            end
            PLAYER_TURN: begin
                if (SeqCnt <= SeqLen) begin
                    if (Btn == 0) State_next <= PLAYER_TURN;
                    else State_next <= WAIT_BTN_UP;
                end
                else begin
                    SeqCnt_next <= 0;
                    SeqLen_next <= SeqLen + 1;
                    State_next <= SIMON_TURN;
                    Timer_next <= 0;
                end
            end
            WAIT_BTN_UP: begin
                Quadrant <= Btn;
                if (Btn == 0) begin
                    State_next <= PLAYER_TURN;
                    SeqCnt_next <= SeqCnt + 1;
                end
                else begin
                    State_next <= ((Btn == 4'b0001 && SeqColor == RED) || (Btn == 4'b0010 && SeqColor == GREEN)
                    || (Btn == 4'b0100 && SeqColor == YELLOW) || (Btn == 4'b1000 && SeqColor == BLUE)) ? WAIT_BTN_UP : WAIT;
                end
            end
        endcase
    end
endmodule
