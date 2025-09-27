// Created by IP Generator (Version 2022.1 build 99559)


///////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2019 PANGO MICROSYSTEMS, INC
// ALL RIGHTS REVERVED.
//
// THE SOURCE CODE CONTAINED HEREIN IS PROPRIETARY TO PANGO MICROSYSTEMS, INC.
// IT SHALL NOT BE REPRODUCED OR DISCLOSED IN WHOLE OR IN PART OR USED BY
// PARTIES WITHOUT WRITTEN AUTHORIZATION FROM THE OWNER.
//
///////////////////////////////////////////////////////////////////////////////
//
// Library:
// Filename:
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/100fs

module hsst_test_chk2 (
    input          i_chk_clk0                    ,
    input          i_chk_clk1                    ,
    input          i_chk_clk2                    ,
    input          i_chk_clk3                    ,
    input  [3:0]   i_chk_rstn                    ,
    input  [2:0]   i_rxstatus_0                  ,
    input  [39:0]  i_rxd_0                       ,
    input  [3:0]   i_rdisper_0                   ,
    input  [3:0]   i_rdecer_0                    ,
    input  [3:0]   i_rxk_0                       ,
    input  [2:0]   i_rxh_0                       ,
    input          i_rxq_start_0                 ,
    input          i_rxh_vld_0                    ,
    input          i_rxd_vld_0                    ,
    input  [2:0]   i_rxstatus_1                  ,
    input  [39:0]  i_rxd_1                       ,
    input  [3:0]   i_rdisper_1                   ,
    input  [3:0]   i_rdecer_1                    ,
    input  [3:0]   i_rxk_1                       ,
    input  [2:0]   i_rxh_1                       ,
    input          i_rxq_start_1                 ,
    input          i_rxh_vld_1                    ,
    input          i_rxd_vld_1                    ,
    input  [2:0]   i_rxstatus_2                  ,
    input  [39:0]  i_rxd_2                       ,
    input  [3:0]   i_rdisper_2                   ,
    input  [3:0]   i_rdecer_2                    ,
    input  [3:0]   i_rxk_2                       ,
    input  [2:0]   i_rxh_2                       ,
    input          i_rxq_start_2                 ,
    input          i_rxh_vld_2                    ,
    input          i_rxd_vld_2                    ,
    input  [2:0]   i_rxstatus_3                  ,
    input  [39:0]  i_rxd_3                       ,
    input  [3:0]   i_rdisper_3                   ,
    input  [3:0]   i_rdecer_3                    ,
    input  [3:0]   i_rxk_3                       ,
    input  [2:0]   i_rxh_3                       ,
    input          i_rxq_start_3                 ,
    input          i_rxh_vld_3                    ,
    input          i_rxd_vld_3                    ,
    output         o_p_rxgear_slip_0               ,
    output         o_p_rxgear_slip_1               ,
    output         o_p_rxgear_slip_2               ,
    output         o_p_rxgear_slip_3               ,

//
input rfifo2_almost_full,
output [31:0] o_fifo2_wr_data,
output o_fifo2_wr_en,

input rfifo3_almost_full,
output [31:0] o_fifo3_wr_data,
output o_fifo3_wr_en,
//ceshi
output [3:0]k2,
output [3:0]k3              
);
//ceshi
assign k2=rxk_algn_ff1[2];
assign k3=rxk_algn_ff1[3];
//


genvar i;

wire [ 3:0] chk_clk = {i_chk_clk3,i_chk_clk2,i_chk_clk1,i_chk_clk0};

// ********************* RXD BUFFER *********************
wire  [39:0] rxd     [3:0];
reg   [39:0] rxd_ff1 [3:0];
reg   [39:0] rxd_ff2 [3:0];
reg   [39:0] rxd_ff3 [3:0];
reg   [39:0] rxd_ff4 [3:0];
reg   [39:0] rxd_ff5 [3:0];
wire  [ 3:0] rxk     [3:0];
reg   [ 3:0] rxk_ff1 [3:0];
reg   [ 3:0] rxk_ff2 [3:0];
reg   [ 3:0] rxk_ff3 [3:0];
reg   [39:0] rxd_algn [3:0];
reg   [ 3:0] rxk_algn [3:0];
reg   [39:0] rxd_algn_ff1 [3:0];
reg   [39:0] rxd_algn_ff2 [3:0];
reg   [ 3:0] rxk_algn_ff1 [3:0];
reg   [ 3:0] rxk_algn_ff2 [3:0];
reg   [1:0] rxbyte_shft [3:0];

assign rxd[0] = i_rxd_0;
assign rxd[1] = i_rxd_1;
assign rxd[2] = i_rxd_2;
assign rxd[3] = i_rxd_3;
assign rxk[0] = i_rxk_0;
assign rxk[1] = i_rxk_1;
assign rxk[2] = i_rxk_2;
assign rxk[3] = i_rxk_3;

reg  [39:0] payload     [3:0];
reg  [39:0] payload_buf [3:0];
reg  [ 5:0] shift_bits  [3:0];
reg  [ 5:0] shift_bits_ff1  [3:0];
reg  [15:0] pattern_cnt [3:0] ;
wire [40:0] payload_shift [3:0];

generate
for (i=0; i<=3; i=i+1) begin: PL_LANE
    always @ (posedge chk_clk[i] or negedge i_chk_rstn[i]) begin 
        if(i_chk_rstn[i]==1'b0) 
            rxd_ff1[i] <= 40'd0;
        else 
            rxd_ff1[i] <= rxd[i];
    end
    always @ (posedge chk_clk[i] or negedge i_chk_rstn[i]) begin 
        if(i_chk_rstn[i]==1'b0) 
            rxd_ff2[i] <= 40'd0;
        else 
            rxd_ff2[i] <= rxd_ff1[i];
    end
    always @ (posedge chk_clk[i] or negedge i_chk_rstn[i]) begin 
        if(i_chk_rstn[i]==1'b0) 
            rxd_ff3[i] <= 40'd0;
        else 
            rxd_ff3[i] <= rxd_ff2[i];
    end
    always @ (posedge chk_clk[i] or negedge i_chk_rstn[i]) begin 
        if(i_chk_rstn[i]==1'b0) 
            rxd_ff4[i] <= 40'd0;
        else 
            rxd_ff4[i] <= rxd_ff3[i];
    end
    always @ (posedge chk_clk[i] or negedge i_chk_rstn[i]) begin 
        if(i_chk_rstn[i]==1'b0) 
            rxd_ff5[i] <= 40'd0;
        else 
            rxd_ff5[i] <= rxd_ff4[i];
    end
    always @ (posedge chk_clk[i] or negedge i_chk_rstn[i]) begin 
        if(i_chk_rstn[i]==1'b0) 
            rxk_ff1[i] <=  4'd0;
        else 
            rxk_ff1[i] <= rxk[i];
    end
    always @ (posedge chk_clk[i] or negedge i_chk_rstn[i]) begin 
        if(i_chk_rstn[i]==1'b0) 
            rxk_ff2[i] <=  4'd0;
        else 
            rxk_ff2[i] <= rxk_ff1[i];
    end
    always @ (posedge chk_clk[i] or negedge i_chk_rstn[i]) begin 
        if(i_chk_rstn[i]==1'b0) 
            rxk_ff3[i] <=  4'd0;
        else 
            rxk_ff3[i] <= rxk_ff2[i];
    end

        always @ (posedge chk_clk[i] or negedge i_chk_rstn[i]) begin 
            if(i_chk_rstn[i]==1'b0)
                rxbyte_shft[i] <= 2'd0;
            else if((rxk[i]==4'b1000)&&(rxk_ff1[i][3]==1'b0))
                rxbyte_shft[i] <= 2'd1;
            else if((rxk[i][2:0]==3'b100)&&(rxk_ff1[i][3:2]==2'b00))
                rxbyte_shft[i] <= 2'd2;
            else if((rxk[i][1:0]==2'b10)&&(rxk_ff1[i][3:1]==3'b000))
                rxbyte_shft[i] <= 2'd3;
            else if((rxk[i][0]==1'b1)&&(rxk_ff1[i]==4'b0000))
                rxbyte_shft[i] <= 2'd0;
            else ;
        end
        always @ (posedge chk_clk[i] or negedge i_chk_rstn[i]) begin 
            if(i_chk_rstn[i]==1'b0) begin
                rxd_algn[i] <= 40'd0;
                rxk_algn[i] <= 4'd0;
            end
            else if(rxbyte_shft[i]==2'd1) begin
                rxd_algn[i] <= {8'b0,rxd_ff1[i][23:0],rxd_ff2[i][31:24]};
                rxk_algn[i] <= {rxk_ff1[i][2:0],rxk_ff2[i][3]};
            end
            else if(rxbyte_shft[i]==2'd2) begin
                rxd_algn[i] <= {8'b0,rxd_ff1[i][15:0],rxd_ff2[i][31:16]};
                rxk_algn[i] <= {rxk_ff1[i][1:0],rxk_ff2[i][3:2]};
            end
            else if(rxbyte_shft[i]==2'd3) begin
                rxd_algn[i] <= {8'b0,rxd_ff1[i][7:0],rxd_ff2[i][31:8]};
                rxk_algn[i] <= {rxk_ff1[i][0],rxk_ff2[i][3:1]};
            end
            else begin
                rxd_algn[i] <= {8'b0,rxd_ff2[i][31:0]};
                rxk_algn[i] <= rxk_ff2[i][3:0];
            end
        end
        always @ (posedge chk_clk[i] or negedge i_chk_rstn[i]) begin 
            if(i_chk_rstn[i]==1'b0) begin
                rxd_algn_ff1[i] <= 40'd0;
                rxk_algn_ff1[i] <= 4'd0;
            end
            else begin
                rxd_algn_ff1[i] <= rxd_algn[i];
                rxk_algn_ff1[i] <= rxk_algn[i];
            end
        end
        always @ (posedge chk_clk[i] or negedge i_chk_rstn[i]) begin 
            if(i_chk_rstn[i]==1'b0)
                pattern_cnt[i] <= 16'd1;
            else if(rxk_algn[i]==4'b0000) 
                pattern_cnt[i] <= 16'd0;
            else if(pattern_cnt[i]<16'd1) 
                pattern_cnt[i] <= pattern_cnt[i]+16'd1;
            else;
        end
        always @ (posedge chk_clk[i] or negedge i_chk_rstn[i]) begin 
            if(i_chk_rstn[i]==1'b0) begin
                payload[i][31:0] <= 32'b0;
                payload_buf[i][31:0] <= 32'b0;
            end
            else if(pattern_cnt[i]==16'd0) begin
                payload[i][31:0] <= rxd_algn_ff1[i][31:0];
                payload_buf[i][31:0] <= payload[i][31:0];
            end
            else ;
        end
        assign payload_shift[i][31:0] = {payload_buf[i][30:0],payload_buf[i][31]}; 
    /*end*/
end
endgenerate


reg  o_fifo_wr_en_ff[3:0];

generate  
for (i=2; i<=3; i=i+1) begin: RFIFO2or3
        always @ (posedge chk_clk[i] or negedge i_chk_rstn[i]) begin 
            if(i_chk_rstn[i]==1'b0) begin
                o_fifo_wr_en_ff[i]<= 1'b0;
            end
            else if(rxk_algn[i]==4'b0) begin
                o_fifo_wr_en_ff[i]<= 1'b1;
            end
            else begin
                o_fifo_wr_en_ff[i]<= 1'b0;
            end
        end
end
endgenerate

assign o_fifo2_wr_data=rxd_algn_ff1[2];
assign o_fifo2_wr_en=o_fifo_wr_en_ff[2];

assign o_fifo3_wr_data=rxd_algn_ff1[3];
assign o_fifo3_wr_en=o_fifo_wr_en_ff[3];
   

endmodule    
