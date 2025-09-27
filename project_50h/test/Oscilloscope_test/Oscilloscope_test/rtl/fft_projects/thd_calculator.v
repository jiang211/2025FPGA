module thd_calculator #(
    parameter FFT_N = 1024,
    parameter DW    = 32,
    parameter KW    = 10
)(
    input  wire             clk,
    input  wire             rst_n,
    input  wire             mag_valid,
    input  wire [KW-1:0]    mag_index,
    input  wire [DW-1:0]    h1,
    input  wire [DW-1:0]    h2,
    input  wire [DW-1:0]    h3,
    input  wire [DW-1:0]    h4,
    input  wire [DW-1:0]    h5,

    output reg  [DW-1:0]    thd_q16_16,
    output reg              thd_valid,
    output [15:0]           div_out,
    output [63:0]           sum_sq
);
///// fs = 29.7MHZ N=1024 f = nKHZ  K1 = n * N / fs = n * 34
///////索引对于频率差 = fs / N = 29.7MHZ /1024 = 29khz
/* 1. 谐波锁存 */
// reg [DW-1:0] h1, h2, h3, h4, h5;
// always @(posedge clk) begin
//     if (!rst_n) begin
//         h1 <= 0; h2 <= 0; h3 <= 0; h4 <= 0; h5 <= 0;
//     end else if (mag_valid) begin
//         case (mag_index)
//             k1   : h1 <= mag_data;
//             2*k1 : h2 <= mag_data;
//             3*k1 : h3 <= mag_data;
//             4*k1 : h4 <= mag_data;
//             5*k1 : h5 <= mag_data;
//         endcase
//     end
// end

/* 2. 帧结束 */
//reg frame_done;
//always @(posedge clk) begin
//    if (!rst_n) frame_done <= 0;
//    else if (mag_index == FFT_N-1 && mag_valid)
//        frame_done <= 1;
//    else 
//        frame_done <= 0;
//end

/* 3. 平方和 */
reg [63:0] sum_sq;
always @(posedge clk) begin
    if (mag_valid)
        sum_sq <= ({32'd0,h2}*{32'd0,h2}) + ({32'd0,h3}*{32'd0,h3}) +
                  ({32'd0,h4}*{32'd0,h4}) + ({32'd0,h5}*{32'd0,h5});
end

wire        sqrt_busy;
wire [31:0] sqrt_out;        // 开方结果
wire [31:0] sqrt_rem;        // 余数，如不需要可悬空
// 35792355 

sqrt #(
    .DW (64)
) u_sqrt_thd (
    .clk         (clk),
    .rst_n       (rst_n),
    .din_i       (sum_sq),          // 64 位被开方数
    .din_valid_i (mag_valid),
    .busy_o      (sqrt_busy),
    .sqrt_o      (sqrt_out),        // 32 位结果
    .rem_o       (sqrt_rem)         // 如不用可悬空
);

assign div_out = sqrt_out * 100 / h1;
/* 5. 除法 */
wire        div_valid;
wire [31:0] div_out;
//div_u32_q16_16 u_div (
//    .clk     (clk),
//    .rst_n   (rst_n),
//    .valid_i (~sqrt_busy),   // busy 下降沿启动
//    .a_i     (sqrt_out),
//    .b_i     (h1),
//    .valid_o (div_valid),
//    .q_o     (div_out)
//);
always @(posedge clk) begin
    if (!rst_n) begin
        thd_valid <= 0;
        thd_q16_16 <= 0;
    end else begin
        thd_valid <= ~sqrt_busy;
        thd_q16_16 <= div_out;
    end
end
endmodule