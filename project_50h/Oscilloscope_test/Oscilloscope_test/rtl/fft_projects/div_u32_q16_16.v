module div_u32_q16_16 #(
    parameter WIDTH = 32,
    parameter FRAC  = 16
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid_i,   // 启动脉冲
    input  wire [WIDTH-1:0] a_i,  // 被除数
    input  wire [WIDTH-1:0] b_i,  // 除数
    output reg         valid_o,   // 结果有效
    output reg [WIDTH-1:0] q_o    // Q16.16 商
);

localparam ITER = WIDTH + FRAC;

reg [WIDTH-1:0]       dividend;
reg [WIDTH-1:0]       divisor;
reg [ITER:0]          quot;
reg [5:0]             cnt;

wire [ITER:0] sub     = {quot[ITER-1:0], dividend[WIDTH-1]} - {divisor, {FRAC{1'b0}}};
wire        sub_ok    = !sub[ITER];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_o  <= 0;
        q_o      <= 0;
        dividend <= 0;
        divisor  <= 0;
        quot     <= 0;
        cnt      <= 0;
    end else begin
        valid_o <= 0;
        if (valid_i && cnt == 0) begin
            dividend <= a_i;
            divisor  <= b_i;
            quot     <= 0;
            cnt      <= ITER;
        end else if (cnt != 0) begin
            if (sub_ok) begin
                quot <= {sub[ITER-1:0], 1'b1};
                dividend <= {dividend[WIDTH-2:0], 1'b0};
            end else begin
                quot <= {quot[ITER-1:0], 1'b0};
                dividend <= {dividend[WIDTH-2:0], 1'b0};
            end
            cnt <= cnt - 1;
        end else if (cnt == 0) begin
            q_o     <= quot[ITER-1:0];
            valid_o <= 1;
        end
    end
end
endmodule