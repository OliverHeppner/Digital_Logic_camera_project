`timescale 1ns / 1ps

// The purpose of this module is to keep track of what position the "CRT cursor" is at, and then send that data
// along with the output of the ADC, to the memory block to be stored in the relevant location
// i.e. takes in LM1881 stuff and ADC data, outputs ADC data along with the grid coordinate 
// that the data corresponds to

module Camera_Input(
    input logic vSync,
    input logic compSync, //contains hSync
    input logic isOdd, //from LM1881 datasheet --> 0 is even, 1 is odd
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

logic [1:0] state = 0;
logic [10:0] counter = 0;
logic [5:0] pixelCounter = 0;

// need to detect the instant hSync goes low, so we make variables to track its current and previous states
logic hsync1 = 1;
logic hsync2 = 1;
logic hsync3 = 1;
logic hsync4 = 1;

always_ff @ (posedge CLK) begin //we shuffle the value of hsync through 4 variables - a falling edge occurs where hsync4 is high and hsync3 is low
    hsync1 <= compSync;
    hsync2 <= hsync1;
    hsync3 <= hsync2;
    hsync4 <= hsync3;
end

//we'll do the same with vSync too
logic vsync1 = 1;
logic vsync2 = 1;
logic vsync3 = 1;
logic vsync4 = 1;

always_ff @ (posedge CLK) begin
    vsync1 <= vSync;
    vsync2 <= vsync1;
    vsync3 <= vsync2;
    vsync4 <= vsync3;
end

// and the same as well for isOdd
logic odd1;
logic odd2;
logic odd3;

always_ff @ (posedge CLK) begin
    odd1 <= isOdd;
    odd2 <= odd1;
    odd3 <= odd2;
end

logic synced = 0;

always_ff @ (posedge CLK) begin

    valid <= 0;
    
    if (vsync4 && !vsync3) begin
        synced <= 1;
        state <= 2'b00;
        counter <= 0;
        pixelCounter <= 0;
        dataRow <= 0;
        dataCol <= 0;
    end
    
    else if (synced) begin

    case (state)
    
        default: state <= 2'b00;
    
        2'b00: begin //wait for hSync state
            if (vsync3 && hsync4 && !hsync3) begin
                state <= state + 1;
            end
        end
    
        2'b01: begin // wait 11.7 us
            counter <= counter + 1;
            if (counter >= 1169) begin
                state <= state + 1;
                counter <= 0;
            end
        end
    
        2'b10: begin //sample pixels
            counter <= counter + 1;
        
            if (counter == 0) begin
                writtenData <= data;
                dataCol <= pixelCounter;
                valid <= 1;
            end
        
            if (counter >= 99) begin
                counter <= 0;
            
                if (pixelCounter >= 47) begin
                    pixelCounter <= 0;
                    state <= state + 1;
                end else begin
                    pixelCounter <= pixelCounter + 1;
                end
            end
        end
    
        2'b11: begin // row complete
            counter <= 0;
            
            if (dataRow < 47) begin
                dataRow <= dataRow + 1;
                state <= 2'b00;
            end
        end
    
    endcase
    
    end
end

    
endmodule

