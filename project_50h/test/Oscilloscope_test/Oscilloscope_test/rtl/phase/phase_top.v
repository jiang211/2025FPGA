module phase_top(
    input clk,
    input rst_n,

    input [7 : 0] wave_a,
    input [7 : 0] wave_b,
    input [7 : 0] amplitude,
    output reg [7 : 0] phase
);

localparam THRESHOLD = 4;
wire [7 : 0] low = 256 - amplitude;



    
endmodule