module voltage_quant(
    input wire clk,
    input wire rst,
    input wire [13:0] data_in,
    output wire [13:0] volt_out
);

parameter   CNT_MAX_MIA    =   'd1000_000;
parameter   CNT_MAX_FRE    =   'd5_000_000;
parameter   CNT_MAX_RST    =   'd60_000_000;
reg     [30:0]      cnt,cnt_rst,cnt_f;

reg     [13:0]      rmin,rmax;

reg     [7:0]      fre_cnt_reg;
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



always @ (posedge clk or negedge rst)begin
    if(rst == 1'b0)begin
        rmin <= 16'd999;
        rmax <= 16'd0;
    end
    else if(cnt_rst == CNT_MAX_RST - 1'b1)begin
        rmin <= 16'd999;
        rmax <= 16'd0;
    end
    else if(data_in < rmin)
        rmin <= data_in;
    else if(data_in > rmax)
        rmax <= data_in;
    else begin
        rmin <= rmin;
        rmax <= rmax;
    end
end



assign min = (cnt == CNT_MAX_MIA - 1'b1)? rmin : min;
assign max = (cnt == CNT_MAX_MIA - 1'b1)? rmax : max;

assign volt_out = (max - 14'd4150) / 16;


endmodule


