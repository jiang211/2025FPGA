module soft_clip_10 (
    input        clk,
    input        rst_n,
    input  [11:0] din,
    output reg [11:0] dout,
    output wire spike_replace_sum,
    output wire spike_replace_x3
);

reg [11:0] x0, x1, x2,x3,x4;   // 左、中、右
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) {x4,x3,x2, x1, x0} <= 40'd0;
    else begin
        x0 <= din;
        x1 <= x0;
        x2 <= x1;
        x3 <= is_out ? x3 : spike_replace_x3 ? x3 : spike_replace_sum ? avg : x2;
        x4 <= x3;
    end
end

wire [11:0] diff_l2 = (x2 > x1) ? (x2 - x1) : (x1 - x2);
wire [11:0] diff_r2 = (x2 > x3) ? (x2 - x3) : (x3 - x2);

wire [11:0] diff_l1 = (x1 > x0) ? (x1 - x0) : (x0 - x1);
wire [11:0] diff_r1 = (x1 > x3) ? (x1 - x3) : (x3 - x1);

wire spike2 = (diff_l2 >= 11'd5) && (diff_r2 >= 11'd5);
wire spike1 = (diff_l1 >= 11'd10) && (diff_r1 >= 11'd10);

wire spike_replace_sum = spike2 & (~spike1);
wire spike_replace_x3 = spike2 & spike1;
wire is_out = x2 > 'd3300;
wire [12:0] sum = {1'b0, x1} + {1'b0, x3} + 1'b1;
wire [11:0] avg = sum[12:1];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        dout     <= 0;
    end else begin
        dout     <= is_out ? x3 : spike_replace_x3 ? x3 : spike_replace_sum ? avg : x2;
    end
end

endmodule