module soft_clip_8 (
    input        clk,
    input        rst_n,
    input  [7:0] din,
    output reg [7:0] dout,
    output wire spike
);

reg [7:0] x0, x1, x2;   // 左、中、右
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) {x2, x1, x0} <= 24'd0;
    else begin
        x0 <= din;
        x1 <= x0;
        x2 <= x1;
    end
end

wire [7:0] diff_l = (x1 > x0) ? (x1 - x0) : (x0 - x1);
wire [7:0] diff_r = (x1 > x2) ? (x1 - x2) : (x2 - x1);


wire spike = ((diff_l >= 8'd5) && (diff_r >= 8'd5));


wire [8:0] sum = {1'b0, x0} + {1'b0, x2} + 1'b1;
wire [7:0] avg = sum[8:1];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        dout     <= 0;
    end else begin
        dout     <= spike ? avg : x1;
    end
end

endmodule