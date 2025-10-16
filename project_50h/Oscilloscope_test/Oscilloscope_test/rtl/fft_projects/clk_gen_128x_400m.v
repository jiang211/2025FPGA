module clk_gen_128x_400m (
    input  wire        clk400m,    // 400 MHz 主时钟
    input  wire        rst_n,
    input  wire [31:0] f_sig_hz,   // 10 k – 1 M Hz
    output wire        clk_out     // 1.28 M – 128 M Hz
);

localparam FWORD_MULT = 32'd1374;  // 128/400e6 * 2^32
wire [31:0] fword = f_sig_hz * FWORD_MULT;

reg [31:0] acc;
always @(posedge clk400m or negedge rst_n) begin
    if (!rst_n) acc <= 32'd0;
    else        acc <= acc + fword;
end

reg        acc_msb_r;         
always @(posedge clk400m or negedge rst_n) begin
    if (!rst_n) acc_msb_r <= 1'b0;
    else        acc_msb_r <= acc[31];   // 打拍
end

GTP_CLKBUFGCE #(
    .DEFAULT_VALUE(1'b0),
    .SIM_DEVICE    ("LOGOS")  
) u_bufgce (
    .CLKIN (acc_msb_r),
    .CE    (1'b1),              // 常使能
    .CLKOUT(clk_out)
);

endmodule