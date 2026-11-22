

//this just sets the vout pins to 5v
//I don't know if there are designated power pins or how to actiate them
//this will probably need to be changed.

module V_Out(
    input logic set,
    output logic PowerPin
);

    always_comb begin
        if (set) PowerPin = 1;
        else PowerPin = 0;
    end

endmodule