module d_samp(
    input       wire        clk,
    input       wire        clk_180,
    input       wire [7:0]  data_1,
    input       wire [7:0]  data_2,
    output      wire [7:0]  d_out
);

reg [7:0] d_out_reg_1;
reg [7:0] d_out_reg_2;
always @(posedge clk) begin
    d_out_reg_1 <= data_1;
end

always @(posedge clk_180) begin
    d_out_reg_2 <= data_2;
end


assign d_out =  ( {8{clk}}      &   d_out_reg_1 ) |
                ( {8{clk_180}}  &   d_out_reg_2 ) ;

endmodule