module d_samp(
    input       wire        clk,
    input       wire        clk_180,
    input       wire [7:0]  data_1,
    input       wire [7:0]  data_2,
    output      wire [8:0]  d_out,
    input       wire [13:0]  vo_in1,
    input       wire [13:0]  vo_in2,
    output      wire [14:0]  vo_out
);

reg [7:0] d_out_reg_1;
reg [7:0] d_out_reg_2;
always @(posedge clk) begin
    d_out_reg_1 <= data_1;
end

always @(posedge clk_180) begin
    d_out_reg_2 <= data_2;
end


assign d_out =  ( {9{clk}}      &   {1'b0,d_out_reg_1} ) |
                ( {9{clk_180}}  &   {1'b1,d_out_reg_2} ) ;

reg [13:0] vo_out_reg_1;
reg [13:0] vo_out_reg_2;
always @(posedge clk) begin
    vo_out_reg_1 <= vo_in1;
end

always @(posedge clk_180) begin
    vo_out_reg_2 <= vo_in2;
end


assign vo_out =  ( {15{clk}}      &   {1'b0,vo_out_reg_1} ) |
                ( {15{clk_180}}  &   {1'b1,vo_out_reg_2} ) ;
endmodule