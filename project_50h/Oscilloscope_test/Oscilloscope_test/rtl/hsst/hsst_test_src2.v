`timescale 1ns/100fs

module hsst_test_src2 (
    input          i_src_clk0                    ,
    input          i_src_clk1                    ,
    input          i_src_clk2                    ,
    input          i_src_clk3                    ,
    input          i_src_rstn                    ,
    output [39:0]  o_txd_0                       ,
    output [3:0]   o_txk_0                       ,
    output [6:0]   o_txq_0                       ,
    output [2:0]   o_txh_0                       ,
    output [39:0]  o_txd_1                       ,
    output [3:0]   o_txk_1                       ,
    output [6:0]   o_txq_1                       ,
    output [2:0]   o_txh_1                       ,
    output [39:0]  o_txd_2                       ,
    output [3:0]   o_txk_2                       ,
    output [6:0]   o_txq_2                       ,
    output [2:0]   o_txh_2                       ,
    output [39:0]  o_txd_3                       ,
    output [3:0]   o_txk_3                       ,
    output [6:0]   o_txq_3                       ,
    output [2:0]   o_txh_3                       ,
    output rd2_en ,
    input          almost_empty2 , 
    input  [31:0]  rd2_data,     
    output rd3_en ,
    input          almost_empty3 , 
    input  [31:0]  rd3_data, 
//ceshi
 output [15:0]  cnt           
);
assign cnt=pattern_cnt[2];

//信道整理
reg rd_en_ff[3:0];
assign rd2_en=rd_en_ff[2];
assign rd3_en=rd_en_ff[3];

wire [31:0] rd_data [3:0];
assign rd_data[2]=rd2_data;
assign rd_data[3]=rd3_data;
wire almost_empty[3:0];
assign almost_empty[2]=almost_empty2;
assign almost_empty[3]=almost_empty3;

genvar i;

wire [ 3:0] src_clk = {i_src_clk3,i_src_clk2,i_src_clk1,i_src_clk0};

reg  [39:0] payload [3:0];


// ********************* Pattern Generater *********************
reg [39:0] txd [3:0];
reg [ 3:0] txk [3:0];



// valid for pattern branches
reg  [15:0] pattern_cnt    [3:0] ;

generate
for (i=2; i<=3; i=i+1) begin : PATTERN_CNT
always @ (posedge src_clk[i] or negedge i_src_rstn) begin 
            if(i_src_rstn==1'b0)
                pattern_cnt[i] <= 16'd0;
            else if(pattern_cnt[i]<16'd1) begin
                pattern_cnt[i] <= pattern_cnt[i]+16'd1;
            end
            else begin
                pattern_cnt[i] <= 16'd0;
            end
        end
end
endgenerate


generate
for (i=2; i<=3; i=i+1) begin: PATTERN_LANE
always @ (posedge src_clk[i] or negedge i_src_rstn) begin 
            if(i_src_rstn==1'b0) begin
                txd[i] <= 40'h0050BC50BC;
                txk[i] <= 4'b0101;
                rd_en_ff[i] <= 1'b0;
            end
                else if(almost_empty[i]==1'b1) begin
                txd[i] <= 40'h0050BC50BC;
                txk[i] <= 4'b0101;
                rd_en_ff[i] <= 1'b0;
            end
                else if(pattern_cnt[i]==16'd0) begin
                txd[i] <= {8'h00,rd_data[i]};
                txk[i] <= 4'd0;
                rd_en_ff[i] <= 1'b1;
            end
                else if(pattern_cnt[i]==16'd1) begin
                txd[i] <= 40'h0050BC50BC;
                txk[i] <= 4'b0101;
                rd_en_ff[i] <= 1'b0;
            end
            else begin
                txd[i] <= 40'h0050BC50BC;//修改锁存器看是不是落入其中
                txk[i] <= 4'b0101;
                rd_en_ff[i] <= 1'b0;
            end
        end
end
endgenerate


assign o_txq_0 = 7'b0;
assign o_txh_0 = 3'b0;
assign o_txq_1 = 7'b0;
assign o_txh_1 = 3'b0;
assign o_txq_2 = 7'b0;
assign o_txh_2 = 3'b0;
assign o_txq_3 = 7'b0;
assign o_txh_3 = 3'b0;

assign o_txd_0 = txd[0];
assign o_txk_0 = txk[0];
assign o_txd_1 = txd[1];
assign o_txk_1 = txk[1];
assign o_txd_2 = txd[2];
assign o_txk_2 = txk[2];
assign o_txd_3 = txd[3];
assign o_txk_3 = txk[3];


endmodule    
