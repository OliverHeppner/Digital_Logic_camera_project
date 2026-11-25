`timescale 1ns / 1ps

// TO DO: count 9.4 microseconds from the falling edge of hsync (it's active low)

module Camera_Input(
    input logic vSync,
    input logic compSync, //contains hSync
    input logic isEven,
    input logic CLK, //internal boolean board 100 MHz clock
    input logic [7:0] data;
    );
    
endmodule
