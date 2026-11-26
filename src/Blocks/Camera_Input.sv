`timescale 1ns / 1ps

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
    input logic [11:0] data, // the output of the ADC is 12 bits
    output logic [11:0] writtenData,
    output logic [6:0] dataRow,
    output logic [6:0] dataCol,
    output logic valid
    );

initial begin
    dataCol = 0;
    writtenData = 0;
    dataRow = 0;
    valid = 0;
end

logic [5:0] row_counter = 0; // what row are we on? (vertical position, indexed from 0 at the top)
logic [5:0] column_counter = 0; // what column are we on? (horizontal position, indexed from 0 at the left)
logic [1:0] state = 0;
logic [10:0] counter = 0;
logic [5:0] pixelCounter = 0;

// need to detect the instant hSync goes low, so we make variables to track its current and previous states
logic hsync1;
logic hsync2;
logic hsync3;
logic hsync4;

always_ff @ (posedge CLK) begin //we shuffle the value of hsync through 4 variables - a falling edge occurs where hsync4 is low and hsync3 is high
    hsync1 <= compSync;
    hsync2 <= hsync1;
    hsync3 <= hsync2;
    hsync4 <= hsync3;
end

always_ff @ (posedge CLK) begin
    case (state)
    
    default: state <= 0;
    
    2'b00: begin //wait for hSync state
        if (!vSync && !hsync4 && hsync3 == 1) begin
            state <= state + 1;
        end
    end
    
    2'b01: begin // wait 11.7 us
        counter <= counter + 1;
        if (counter >= 11'd1169) begin
            state <= state + 1;
            counter <= 0;
        end
    end
    
    2'b10: begin //sample pixels
        counter <= counter + 1;
        valid <= 0;
        
        if (counter == 11'd0) begin
            writtenData <= data;
            dataCol <= pixelCounter;
            valid <= 1;
        end
        
        if (counter >= 11'd99) begin
            counter <= 11'd0;
            
            if (pixelCounter >= 47) begin
                pixelCounter <= 0;
                state <= state + 1;
            end else begin
                pixelCounter <= pixelCounter + 1;
            end
        end
    end
    
    2'b11: begin // row complete
        ;
    end
    
    endcase
end

    
endmodule

