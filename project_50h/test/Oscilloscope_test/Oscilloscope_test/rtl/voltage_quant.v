module voltage_quant# (
    parameter                            VMAX = 12'd3200,
    parameter                            VMIN = 12'd1024,
    parameter                            VMID = 12'd2055
) (
    input wire clk,
    input wire rst,
    input wire [11:0] data_in1,
    input wire [11:0] data_in2,

    output wire [11:0] volt_out1,
    output wire [11:0] volt_out2,
    output wire [11:0] min1,
    output wire [11:0] max1,
    output wire [11:0] min2,
    output wire [11:0] max2,
    output      data_in_area1,
    output      data_in_area2
);
wire [11:0] min1,max1,min2,max2;
parameter   CNT_MAX_MIA    =   'd1000_000;
parameter   CNT_MAX_FRE    =   'd5_000_000;
parameter   CNT_MAX_RST    =   'd60_0_000;
reg     [30:0]      cnt,cnt_rst,cnt_f;

reg     [11:0]      rmin1,rmax1,rmin2,rmax2;

wire [11:0] data_in_a = 'd4080 - data_in1;
wire [11:0] data_in_b = 'd4080 - data_in2;
  

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

wire data_in_area1 = (data_in1 >= VMIN) & (data_in1 <= VMAX);

always @ (posedge clk or negedge rst)begin
    if(rst == 1'b0)begin
        rmin1 <= 12'd9999;
        rmax1 <= 12'd0;
    end
    else if(cnt_rst == CNT_MAX_RST - 1'b1)begin
        rmin1 <= 12'd9999;
        rmax1 <= 12'd0;
    end
    else if((data_in1 < rmin1) & data_in_area1)
        rmin1 <= data_in1;
    else if((data_in1 > rmax1) & replace_rmax1)
        rmax1 <= (data_in1 <= VMAX) ?  data_in1 : rmax1;
    else begin
        rmin1 <= rmin1;
        rmax1 <= rmax1;
    end
end

wire data_in_area2 = (data_in2 >= VMIN) & (data_in2 <= VMAX);

always @ (posedge clk)begin
    if(rst == 1'b0)begin
        rmin2 <= 12'd9999;
        rmax2 <= 12'd0;
    end
    else if(cnt_rst == CNT_MAX_RST - 1'b1)begin
        rmin2 <= 12'd9999;
        rmax2 <= 12'd0;
    end
    else if((data_in2 < rmin2) & data_in_area2)
        rmin2 <= data_in2;
    else if((data_in2 > rmax2) & replace_rmax2)
        rmax2 <= (data_in2 <= VMAX) ?  data_in2 : rmax2;
    else begin
        rmin2 <= rmin2;
        rmax2 <= rmax2;
    end
end


wire [11:0] diff_data1 = (data_in1 > VMID)? data_in1 - VMID : VMID - data_in1;
wire [11:0] diff_min1 = VMID - rmin1;
wire [11:0] diff_max1 = rmax1 - VMID;

wire replace_rmax1 = (diff_data1 < (diff_min1 + 'd10)) ? 1'b1 : 1'b0;
wire replace_rmin1 = (diff_data1 < (diff_max1 + 'd10)) ? 1'b1 : 1'b0;

wire [10:0] replace_data = (diff_max1 > (diff_min1 + 'd15)) ? VMID + diff_min1 : rmax1;

wire [11:0] diff_data2 = (data_in2 > VMID)? data_in2 - VMID : VMID - data_in2;
wire [11:0] diff_min2 = VMID - rmin2;
wire [11:0] diff_max2 = rmax2 - VMID;

wire replace_rmax2 = (diff_data2 < (diff_min2 + 'd10)) ? 1'b1 : 1'b0;
wire replace_rmin2 = (diff_data2 < (diff_max2 + 'd10)) ? 1'b1 : 1'b0;

wire [10:0] replace_data2 = (diff_max2 > (diff_min2 + 'd15)) ? VMID + diff_min2 : rmax2;

assign min1 = (cnt == CNT_MAX_MIA - 1'b1) ? rmin1 : min1;
assign max1 = (cnt == CNT_MAX_MIA - 1'b1) ? rmax1 : max1;
assign min2 = (cnt == CNT_MAX_MIA - 1'b1) ? rmin2 : min2;
assign max2 = (cnt == CNT_MAX_MIA - 1'b1) ? rmax2 : max2;

assign volt_out1 = (max1 - VMID) >> 1;
assign volt_out2 = (max2 - VMID) >> 1;

endmodule   



