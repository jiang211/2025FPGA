module voltage_quant# (
    parameter                            V1 = 'd0,
    parameter                            V2 = 'd0,
    parameter                            V3 = 'd0,
    parameter                            V4 = 'd0,
    parameter                            V5 = 'd0,
    parameter                            V6 = 'd0,
    parameter                            V7 = 'd0,
    parameter                            V8 = 'd0,
    parameter                            V9 = 'd0,
    parameter                            V10 = 'd0,
    parameter                            VMAX = 12'd3200,
    parameter                            VMIN = 12'd1024,
    parameter                            VMID = 12'd2055
)(
    input  wire     [ 0:0]      clk    ,       
    input  wire     [ 0:0]      rst       ,    
    input wire [11:0] data_in,
    output wire [11:0] volt_out
);

parameter   CNT_MAX_MIA    =   'd1000_000;
parameter   CNT_MAX_FRE    =   'd5_000_000;
parameter   CNT_MAX_RST    =   'd60_000_000;
reg     [30:0]      cnt,cnt_rst,cnt_f;

reg     [11:0]      rmin,rmax;
wire [11:0]  max,min;
reg     [7:0]      fre_cnt_reg;
wire [11:0] data_quant;
soft_clip_10 u_soft_clip_10(
    .clk                    (clk           ),
    .rst_n                  (rst        ),
    .din                    (data_in[11:0]),
    .dout                   (data_quant),
    .spike_replace_sum                  (spike_replace_sum),
    .spike_replace_x3                  (spike_replace_x3)
);

// ¼ÆÊýÆ÷£º
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
        rmin <= 16'd9999;
        rmax <= 16'd0;
    end
    else if(cnt_rst == CNT_MAX_RST - 1'b1)begin
        rmin <= 16'd9999;
        rmax <= 16'd0;
    end
    else if(data_quant < rmin)
        rmin <= data_quant;
    else if(data_quant > rmax && replace_rmax)
        rmax <= data_quant;
    else begin
        rmin <= rmin;
        rmax <= rmax;
    end
end

wire [10:0] diff_data = (data_quant > 'd2048)? data_quant - 'd2048 : 'd2048 - data_quant;
wire [10:0] diff_min = 'd2048 - rmin;
wire [10:0] diff_max = rmax - 'd2048;

wire replace_rmax = (diff_data < (diff_min + 'd4)) ? 1'b1 : 1'b0;
wire replace_rmin = (diff_data < (diff_max + 'd4)) ? 1'b1 : 1'b0;

wire [10:0] replace_data = (diff_max > (diff_min + 'd5)) ? 'd2048 + diff_min : rmax;

assign min = (cnt == CNT_MAX_MIA - 1'b1)? rmin : min;
assign max = (cnt == CNT_MAX_MIA - 1'b1)? rmax : max;
wire v_out_area = vout_100 == 4'd11;
wire [10:0] vout_100 = (             max < V1) ? 4'd0:  
                       (max >= V1 && max < V2) ? 4'd1:
                       (max >= V2 && max < V3) ? 4'd2:
                       (max >= V3 && max < V4) ? 4'd3:
                       (max >= V4 && max < V5) ? 4'd4:
                       (max >= V5 && max < V6) ? 4'd5:
                       (max >= V6 && max < V7) ? 4'd6:
                       (max >= V7 && max < V8) ? 4'd7:
                       (max >= V8 && max < V9) ? 4'd8:
                       (max >= V9 && max < V10) ? 4'd9: 
                       4'd11;
wire [11:0] data_reg = (vout_100 == 4'd0) ? max - VMID : 
                       (vout_100 == 4'd1) ? max - V1 : 
                       (vout_100 == 4'd2) ? max - V2 : 
                       (vout_100 == 4'd3) ? max - V3 : 
                       (vout_100 == 4'd4) ? max - V4 : 
                       (vout_100 == 4'd5) ? max - V5 : 
                       (vout_100 == 4'd6) ? max - V6 : 
                       (vout_100 == 4'd7) ? max - V7 : 
                       (vout_100 == 4'd8) ? max - V8 : 
                       (vout_100 == 4'd9) ? max - V9 : 
                       max - V10;
assign volt_out = vout_100 * 10'd100 + data_reg;
endmodule
