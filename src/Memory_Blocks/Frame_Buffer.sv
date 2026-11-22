

//this will store frames as they are generated in bit registers
//each block will be able to hold 4 frames

module Frame_Buffer(
    input logic clk,
    input logic rst,
    input logic store,
    input logic recall,

    input logic store_frame,
    output logic recall_frame,

    output logic full,
    output logic empty
);

endmodule