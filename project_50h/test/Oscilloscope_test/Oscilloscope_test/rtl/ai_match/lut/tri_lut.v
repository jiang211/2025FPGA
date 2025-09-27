module tri_lut #(
    parameter DATA_WIDTH = 8
) (
    input  [DATA_WIDTH:0] addr,
    output reg[DATA_WIDTH-1:0] data
);

always @(*) begin
    if(addr <= 255) data = addr;
    else data = 511 - addr;
end

endmodule
