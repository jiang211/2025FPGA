module sqr_lut #(
    parameter DATA_WIDTH = 8
) (
    input  [DATA_WIDTH:0] addr,
    input  [DATA_WIDTH-1:0] amplitude,
    input  sel_signal,
    output reg[DATA_WIDTH-1:0] data
);

always @(*) begin
    if(!sel_signal)begin
        if(addr <= 255) data = amplitude;
        else data = 256 - amplitude;
    end
    else begin
        if(addr <= 255) data = 256 - amplitude;
        else data = amplitude;  
    end

end

endmodule
