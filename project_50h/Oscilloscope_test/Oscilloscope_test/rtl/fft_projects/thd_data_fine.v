module thd_data_fine(
    input wire clk,
    input wire rst,
    input wire [10:0] fre,
    input wire sqrt_busy,
    input wire [63:0] data_in,
    input wire [10:0] index,
    output reg [63:0] h1,
    output reg [63:0] h2,
    output reg [63:0] h3,
    output reg [63:0] h4,
    output reg [63:0] h5,
    output     [10:0] index1
);

///// fs = 29.7MHZ N=1024 f = nKHZ  K1 = n * N / fs = n * 34
///////索引对于频率差 = fs / N = 29.7MHZ /1024 = 29khz
//// 500khz 10 400khz 8
wire [10:0] index1;
wire [10:0] index2;
wire [10:0] index3;
wire [10:0] index4;
wire [10:0] index5;

//assign index1 = fre / 29;
assign index1 = 8;
assign index2 = index1 << 1;
assign index3 = index1 + (index1 << 1);  // 3×
assign index4 = index1 << 2;   // 4×
assign index5 = index1 + (index1 << 2); 

always @(posedge clk) begin
    if(!rst) begin
        h1 <= 0;
    end
    else if(cnt_rst == CNT_MAX_RST - 1'b1 && index <= 'd510 && index >= 'd470)begin
        h1 <= 16'd0;
    end
    else if(index >= index1 - 'd1 && index < index1 + 'd1 && index > 'd0 && sqrt_busy == 1'b0) begin
        if(data_in > h1) h1 <= data_in;
        else             h1 <= h1;
    end
end

always @(posedge clk) begin
    if(!rst) begin
        h2 <= 0;
    end
    else if(cnt_rst == CNT_MAX_RST - 1'b1 && index <= 'd510 && index >= 'd470)begin
        h2 <= 16'd0;
    end
    else if(index >= index2 - 'd1 && index < index2 + 'd1 && index > 'd0 && sqrt_busy == 1'b0) begin
        if(data_in > h2) h2 <= data_in;
        else             h2 <= h2;
    end
end

always @(posedge clk) begin
    if(!rst) begin
        h3 <= 0;
    end
    else if(cnt_rst == CNT_MAX_RST - 1'b1 && index <= 'd510 && index >= 'd470)begin
        h3 <= 16'd0;
    end
    else if(index >= index3 - 'd2 && index < index3 + 'd2 && index > 'd0 && sqrt_busy == 1'b0) begin
        if(data_in > h3) h3 <= data_in;
        else             h3 <= h3;
    end
end

always @(posedge clk) begin
    if(!rst) begin
        h4 <= 0;
    end
    else if(cnt_rst == CNT_MAX_RST - 1'b1 && index <= 'd510 && index >= 'd470)begin
        h4 <= 16'd0;
    end
    else if(index >= index4 - 'd2 && index < index4 + 'd2 && index > 'd0 && sqrt_busy == 1'b0) begin
        if(data_in > h4) h4 <= data_in;
        else             h4 <= h4;
    end
end

always @(posedge clk) begin
    if(!rst) begin
        h5 <= 0;
    end
    else if(cnt_rst == CNT_MAX_RST - 1'b1 && index <= 'd510 && index >= 'd470)begin
        h5 <= 16'd0;
    end
    else if(index >= index5 - 'd2 && index < index5 + 'd2 && index > 'd0 && sqrt_busy == 1'b0) begin
        if(data_in > h5) h5 <= data_in;
        else             h5 <= h5;
    end
end

parameter   CNT_MAX_MIA    =   'd1000_000;
parameter   CNT_MAX_FRE    =   'd5_000_000;
parameter   CNT_MAX_RST    =   'd60_000_000;
reg     [30:0]      cnt,cnt_rst,cnt_f;

reg     [10:0]      rmin,rmax;



// 计数器：
always @ (posedge clk or negedge rst)begin
    if(rst == 1'b0)begin
        cnt <= 1'b0;
    end
    else if(cnt == CNT_MAX_MIA - 1'b1)begin
        cnt <= 1'b0;
    end
    else begin
        cnt <= cnt + 1'b1;
    end
end



always @ (posedge clk or negedge rst)begin
    if(rst == 1'b0)begin
        cnt_rst <= 1'b0;
    end
    else if(cnt_rst == CNT_MAX_RST - 1'b1)begin
        cnt_rst <= 1'b0;
    end
    else begin
        cnt_rst <= cnt_rst + 1'b1;
    end
end

endmodule
