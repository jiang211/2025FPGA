module data_quant(
    input  wire     [ 0:0]      clk    ,       
    input  wire     [ 0:0]      rst       ,    
    input wire [9:0] data_in,
    output wire [8:0] max,
    output wire [8:0] min,
    output wire [31:0] fre,
    output wire [10:0] v
);

parameter   CNT_MAX_MIA    =   'd1000_000;
parameter   CNT_MAX_FRE    =   'd5_000_000;
parameter   CNT_MAX_RST    =   'd60_000_000;
reg     [30:0]      cnt,cnt_rst,cnt_f;

reg     [10:0]      rmin,rmax;

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
        cnt_f <= 1'b0;
    end
    else if(cnt_f == CNT_MAX_FRE - 1'b1)begin
        cnt_f <= 1'b0;
    end
    else begin
        cnt_f <= cnt_f + 1'b1;
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
assign v = (max <= 'd150) ? 11'd50: 
           (max <= 'd162) ? 11'd100:
           (max <= 'd168) ? 11'd125: 
           (max <= 'd174) ? 11'd150: 
           (max <= 'd180) ? 11'd175:
           (max <= 'd188) ? 11'd200: 
           (max <= 'd194) ? 11'd225:
           (max <= 'd200) ? 11'd250:
           (max <= 'd206) ? 11'd275: 
           (max <= 'd212) ? 11'd300:
           (max <= 'd218) ? 11'd325:
           (max <= 'd224) ? 11'd350:
           (max <= 'd230) ? 11'd375: 
           (max <= 'd238) ? 11'd400: 
           (max <= 'd244) ? 11'd425:
           (max <= 'd248) ? 11'd450: 11'd500;
endmodule
