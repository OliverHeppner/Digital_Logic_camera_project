`timescale 1us / 1ns

// TO DO: count 9.4 microseconds from the falling edge of hsync (it's active low)

/*
Process (so I don't lose my mind):

- When VSYNC is high and compSync goes low, wait 9.4 us for the back porch plus 2.3 us
- begin sampling (48 microseconds for 48 pixels)
- wait 2.3 microseconds
- Wait for another falling edge of compSync

*/

// The purpose of this module is to keep track of what position the "CRT cursor" is at, and then send that data
// along with the output of the ADC, to the memory block to be stored in the relevant location
// i.e. takes in LM1881 stuff and ADC data, outputs ADC data along with the grid coordinate 
// that the data corresponds to

module Camera_Input(
    input logic vSync,
    input logic compSync, //contains hSync
    input logic isEven,
    input logic CLK, //internal boolean board 100 MHz clock
    input logic [11:0] data; // the output of the ADC is 12 bits
    output logic [11:0] writtenData;
    output logic [6:0] dataRow;
    output logic [6:0] dataCol;
    );

logic [15:0] timing_counter; // time elapsed since last HSYNC
logic [5:0] row_counter; // what row are we on? (vertical position, indexed from 0 at the top)
logic [5:0] column_counter; // what column are we on? (horizontal position, indexed from 0 at the left)



    
endmodule

