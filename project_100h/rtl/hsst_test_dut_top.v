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

module optical_fiber_top (
    
    input          i_free_clk                    ,
    input          rst_n                         ,
//  input          i_pll_rst_0                   ,
//  input          i_wtchdg_clr_0                ,
    output [1:0]   o_wtchdg_st_0                 ,
    output         o_pll_done_0                  ,
    output         o_txlane_done_2               ,
    output         o_txlane_done_3               ,
    output         o_rxlane_done_2               ,
    output         o_rxlane_done_3               ,
    input          i_p_refckn_0                  ,
    input          i_p_refckp_0                  ,
    output         o_p_pll_lock_0                ,
    output         o_p_rx_sigdet_sta_2           ,
    output         o_p_rx_sigdet_sta_3           ,
    output         o_p_lx_cdr_align_2            ,
    output         o_p_lx_cdr_align_3            ,
    output         o_p_pcs_lsm_synced_2          ,
    output         o_p_pcs_lsm_synced_3          ,
    input          i_p_l2rxn                     ,
    input          i_p_l2rxp                     ,
    input          i_p_l3rxn                     ,
    input          i_p_l3rxp                     ,
    output         o_p_l2txn                     ,
    output         o_p_l2txp                     ,
    output         o_p_l3txn                     ,
    output         o_p_l3txp                     ,
    output [2:0]   o_rxstatus_2                  ,
    output [2:0]   o_rxstatus_3                  ,
    output [3:0]   o_rdisper_2                   ,
    output [3:0]   o_rdecer_2                    ,
    output [3:0]   o_rdisper_3                   ,
    output [3:0]   o_rdecer_3                    , 

//    output         SFP1_IIC_SCL                 ,   
//    inout          SFP1_IIC_SDA                 , 
//    output         SFP2_IIC_SCL                 ,   
//    inout          SFP2_IIC_SDA                 , 
  
//  input          src_rst                     ,
//  input          chk_rst                     ,
    output[1:0]    tx_disable,

//发送2
input inu2_clk,
input inu2_rstn,
input wfifo2_wr_en,
input [31:0] wfifo2_wr_data,
output wfifo2_wr_full,//将满信号，可以不用
output wfifo2_almost_full,
output almost_empty2,
//发送3
input inu3_clk,
input inu3_rstn,
input wfifo3_wr_en,
input [31:0] wfifo3_wr_data,
output wfifo3_wr_full,//将满信号，可以不用
output wfifo3_almost_full,
output almost_empty3,

//接受2
input inu2_clk_last,
input inu2_rstn_last,
input rd2_en_last,
output [31:0] rd2_data_last,
output almost_empty_last2,
//接受3
input inu3_clk_last,
input inu3_rstn_last,
input rd3_en_last,
output [31:0] rd3_data_last,
output almost_empty_last3,
//ceshi
output [15:0] cnt,
output [3:0] k2,
output [3:0] k3
);

//       

//assign      SFP1_IIC_SCL         = 1'b1 ; 
//assign      SFP2_IIC_SCL         = 1'b1 ;  
assign        tx_disable           = 2'b0 ; 

wire          i_wtchdg_clr_0 ;
wire          src_rst             /* synthesis PAP_MARK_DEBUG="true" */ ; //no use          
wire          chk_rst             /* synthesis PAP_MARK_DEBUG="true" */ ; //no used
wire          pll_rst_d;
wire          i_pll_rst_0;
wire          i_p_cfg_rst;
wire          rst_n_dly_d0;
assign        i_p_cfg_rst=~rst_n;
assign        i_pll_rst_0= pll_rst_d;
assign        pll_rst_d=i_p_cfg_rst;
assign        i_wtchdg_clr_0=pll_rst_d;
assign        src_rst=pll_rst_d;
assign        chk_rst=pll_rst_d;


// ********************* UI parameters *********************
localparam CH0_PROTOCOL = "CUSTOMERIZEDx1";
localparam CH1_PROTOCOL = "CUSTOMERIZEDx1";
localparam CH2_PROTOCOL = "CUSTOMERIZEDx2";
localparam CH3_PROTOCOL = "CUSTOMERIZEDx2";
localparam CH0_RXPCS_CTC = "Bypassed";
localparam CH1_RXPCS_CTC = "Bypassed";
localparam CH2_RXPCS_CTC = "GE";
localparam CH3_RXPCS_CTC = "GE";
localparam PLL0_REF_FRQ = 125.0;
localparam PLL1_REF_FRQ = 125.0;
 localparam TD_8BIT_ONLY_0 = "FALSE"; 
 localparam TD_10BIT_ONLY_0 = "FALSE"; 
 localparam TD_8B10B_8BIT_0 = "FALSE"; 
 localparam TD_16BIT_ONLY_0 = "FALSE"; 
 localparam TD_20BIT_ONLY_0 = "FALSE"; 
 localparam TD_8B10B_16BIT_0 = "FALSE"; 
 localparam TD_32BIT_ONLY_0 = "FALSE"; 
 localparam TD_40BIT_ONLY_0 = "FALSE"; 
 localparam TD_8B10B_32BIT_0 = "FALSE"; 
 localparam TD_64B66B_16BIT_0 = "FALSE"; 
 localparam TD_64B66B_32BIT_0 = "FALSE"; 
 localparam TD_64B67B_16BIT_0 = "FALSE"; 
 localparam TD_64B67B_32BIT_0 = "FALSE"; 
 localparam TD_8BIT_ONLY_1 = "FALSE"; 
 localparam TD_10BIT_ONLY_1 = "FALSE"; 
 localparam TD_8B10B_8BIT_1 = "FALSE"; 
 localparam TD_16BIT_ONLY_1 = "FALSE"; 
 localparam TD_20BIT_ONLY_1 = "FALSE"; 
 localparam TD_8B10B_16BIT_1 = "FALSE"; 
 localparam TD_32BIT_ONLY_1 = "FALSE"; 
 localparam TD_40BIT_ONLY_1 = "FALSE"; 
 localparam TD_8B10B_32BIT_1 = "FALSE"; 
 localparam TD_64B66B_16BIT_1 = "FALSE"; 
 localparam TD_64B66B_32BIT_1 = "FALSE"; 
 localparam TD_64B67B_16BIT_1 = "FALSE"; 
 localparam TD_64B67B_32BIT_1 = "FALSE"; 
 localparam TD_8BIT_ONLY_2 = "FALSE"; 
 localparam TD_10BIT_ONLY_2 = "FALSE"; 
 localparam TD_8B10B_8BIT_2 = "FALSE"; 
 localparam TD_16BIT_ONLY_2 = "FALSE"; 
 localparam TD_20BIT_ONLY_2 = "FALSE"; 
 localparam TD_8B10B_16BIT_2 = "FALSE"; 
 localparam TD_32BIT_ONLY_2 = "FALSE"; 
 localparam TD_40BIT_ONLY_2 = "FALSE"; 
 localparam TD_8B10B_32BIT_2 = "TRUE"; 
 localparam TD_64B66B_16BIT_2 = "FALSE"; 
 localparam TD_64B66B_32BIT_2 = "FALSE"; 
 localparam TD_64B67B_16BIT_2 = "FALSE"; 
 localparam TD_64B67B_32BIT_2 = "FALSE"; 
 localparam TD_8BIT_ONLY_3 = "FALSE"; 
 localparam TD_10BIT_ONLY_3 = "FALSE"; 
 localparam TD_8B10B_8BIT_3 = "FALSE"; 
 localparam TD_16BIT_ONLY_3 = "FALSE"; 
 localparam TD_20BIT_ONLY_3 = "FALSE"; 
 localparam TD_8B10B_16BIT_3 = "FALSE"; 
 localparam TD_32BIT_ONLY_3 = "FALSE"; 
 localparam TD_40BIT_ONLY_3 = "FALSE"; 
 localparam TD_8B10B_32BIT_3 = "TRUE"; 
 localparam TD_64B66B_16BIT_3 = "FALSE"; 
 localparam TD_64B66B_32BIT_3 = "FALSE"; 
 localparam TD_64B67B_16BIT_3 = "FALSE"; 
 localparam TD_64B67B_32BIT_3 = "FALSE"; 
 localparam RD_8BIT_ONLY_0 = "FALSE"; 
 localparam RD_10BIT_ONLY_0 = "FALSE"; 
 localparam RD_8B10B_8BIT_0 = "FALSE"; 
 localparam RD_16BIT_ONLY_0 = "FALSE"; 
 localparam RD_20BIT_ONLY_0 = "FALSE"; 
 localparam RD_8B10B_16BIT_0 = "FALSE"; 
 localparam RD_32BIT_ONLY_0 = "FALSE"; 
 localparam RD_40BIT_ONLY_0 = "FALSE"; 
 localparam RD_8B10B_32BIT_0 = "FALSE"; 
 localparam RD_64B66B_16BIT_0 = "FALSE"; 
 localparam RD_64B66B_32BIT_0 = "FALSE"; 
 localparam RD_64B67B_16BIT_0 = "FALSE"; 
 localparam RD_64B67B_32BIT_0 = "FALSE"; 
 localparam RD_8BIT_ONLY_1 = "FALSE"; 
 localparam RD_10BIT_ONLY_1 = "FALSE"; 
 localparam RD_8B10B_8BIT_1 = "FALSE"; 
 localparam RD_16BIT_ONLY_1 = "FALSE"; 
 localparam RD_20BIT_ONLY_1 = "FALSE"; 
 localparam RD_8B10B_16BIT_1 = "FALSE"; 
 localparam RD_32BIT_ONLY_1 = "FALSE"; 
 localparam RD_40BIT_ONLY_1 = "FALSE"; 
 localparam RD_8B10B_32BIT_1 = "FALSE"; 
 localparam RD_64B66B_16BIT_1 = "FALSE"; 
 localparam RD_64B66B_32BIT_1 = "FALSE"; 
 localparam RD_64B67B_16BIT_1 = "FALSE"; 
 localparam RD_64B67B_32BIT_1 = "FALSE"; 
 localparam RD_8BIT_ONLY_2 = "FALSE"; 
 localparam RD_10BIT_ONLY_2 = "FALSE"; 
 localparam RD_8B10B_8BIT_2 = "FALSE"; 
 localparam RD_16BIT_ONLY_2 = "FALSE"; 
 localparam RD_20BIT_ONLY_2 = "FALSE"; 
 localparam RD_8B10B_16BIT_2 = "FALSE"; 
 localparam RD_32BIT_ONLY_2 = "FALSE"; 
 localparam RD_40BIT_ONLY_2 = "FALSE"; 
 localparam RD_8B10B_32BIT_2 = "TRUE"; 
 localparam RD_64B66B_16BIT_2 = "FALSE"; 
 localparam RD_64B66B_32BIT_2 = "FALSE"; 
 localparam RD_64B67B_16BIT_2 = "FALSE"; 
 localparam RD_64B67B_32BIT_2 = "FALSE"; 
 localparam RD_8BIT_ONLY_3 = "FALSE"; 
 localparam RD_10BIT_ONLY_3 = "FALSE"; 
 localparam RD_8B10B_8BIT_3 = "FALSE"; 
 localparam RD_16BIT_ONLY_3 = "FALSE"; 
 localparam RD_20BIT_ONLY_3 = "FALSE"; 
 localparam RD_8B10B_16BIT_3 = "FALSE"; 
 localparam RD_32BIT_ONLY_3 = "FALSE"; 
 localparam RD_40BIT_ONLY_3 = "FALSE"; 
 localparam RD_8B10B_32BIT_3 = "TRUE"; 
 localparam RD_64B66B_16BIT_3 = "FALSE"; 
 localparam RD_64B66B_32BIT_3 = "FALSE"; 
 localparam RD_64B67B_16BIT_3 = "FALSE"; 
 localparam RD_64B67B_32BIT_3 = "FALSE"; 

// ********************* DUT *********************

assign         o_txlane_done_0               =0; // 
assign         o_txlane_done_1               =0; // 
assign         o_tx_ckdiv_done_0             =0; // 
assign         o_tx_ckdiv_done_1             =0; // 
assign         o_tx_ckdiv_done_2             =0; // 
assign         o_tx_ckdiv_done_3             =0; // 
assign         o_rxlane_done_0               =0; // 
assign         o_rxlane_done_1               =0; // 
assign         o_rx_ckdiv_done_0              =0; // 
assign         o_rx_ckdiv_done_1              =0; // 
assign         o_rx_ckdiv_done_2              =0; // 
assign         o_rx_ckdiv_done_3              =0; // 
assign         o_p_rx_sigdet_sta_0           =0; // 
assign         o_p_rx_sigdet_sta_1           =0; // 
assign         o_p_lx_cdr_align_0            =0; // 
assign         o_p_lx_cdr_align_1            =0; // 
assign         o_p_pcs_lsm_synced_0          =0; // 
assign         o_p_pcs_lsm_synced_1          =0; // 
assign         o_p_pcs_rx_mcb_status_0       =0; // 
assign         o_p_pcs_rx_mcb_status_1       =0; // 
assign         o_p_pcs_rx_mcb_status_2       =0; // 
assign         o_p_pcs_rx_mcb_status_3       =0; //  
wire           i_pll_lock_tx_0               = 1'b1;
wire           i_pll_lock_tx_1               = 1'b1;
wire           i_pll_lock_tx_2               = 1'b1;
wire           i_pll_lock_tx_3               = 1'b1;
wire           i_pll_lock_rx_0               = 1'b1;
wire           i_pll_lock_rx_1               = 1'b1;
wire           i_pll_lock_rx_2               = 1'b1;
wire           i_pll_lock_rx_3               = 1'b1;

wire           o_p_clk2core_tx_0             =1'b0;
wire           o_p_clk2core_tx_1             =1'b0;
wire           o_p_clk2core_tx_2             ;
wire           o_p_clk2core_tx_3             =1'b0;
wire           i_p_tx0_clk_fr_core           ;
wire           i_p_tx1_clk_fr_core           ;
wire           i_p_tx2_clk_fr_core           /*synthesis PAP_MARK_DEBUG="1"*/;
wire           i_p_tx3_clk_fr_core           ;
wire           i_p_tx0_clk2_fr_core          ;
wire           i_p_tx1_clk2_fr_core          ;
wire           i_p_tx2_clk2_fr_core          ;
wire           i_p_tx3_clk2_fr_core          ;

wire           o_p_clk2core_rx_0             =1'b0;
wire           o_p_clk2core_rx_1             =1'b0;
wire           o_p_clk2core_rx_2             =1'b0;
wire           o_p_clk2core_rx_3             =1'b0;
wire           i_p_clk2core_rx_0             ;
wire           i_p_clk2core_rx_1             ;
wire           i_p_clk2core_rx_2             ;
wire           i_p_clk2core_rx_3             ;
wire           i_p_rx0_clk_fr_core           ;
wire           i_p_rx1_clk_fr_core           ;
wire           i_p_rx2_clk_fr_core           ;
wire           i_p_rx3_clk_fr_core           ;
wire           i_p_rx0_clk2_fr_core          ;
wire           i_p_rx1_clk2_fr_core          ;
wire           i_p_rx2_clk2_fr_core          ;
wire           i_p_rx3_clk2_fr_core          ;

wire   [31:0]  i_txd_2                       ;
wire   [3:0]   i_tdispsel_2                  ;
wire   [3:0]   i_tdispctrl_2                 ;
wire   [3:0]   i_txk_2                       ;
wire   [31:0]  i_txd_3                       ;
wire   [3:0]   i_tdispsel_3                  ;
wire   [3:0]   i_tdispctrl_3                 ;
wire   [3:0]   i_txk_3                       ;
//fabric clock
generate
    if((CH0_PROTOCOL=="XAUI")||(CH0_PROTOCOL=="PCIEx4")||(CH0_PROTOCOL=="CUSTOMERIZEDx4")) begin : BONDING_LANE0123
        assign          i_p_tx0_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx1_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx2_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx3_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_rx0_clk_fr_core           = (CH0_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx1_clk_fr_core           = (CH1_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx2_clk_fr_core           = (CH2_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx3_clk_fr_core           = (CH3_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
    end
    else if((CH0_PROTOCOL=="CUSTOMERIZEDx2" || CH0_PROTOCOL=="PCIEx2") && (CH2_PROTOCOL!="CUSTOMERIZEDx2" && CH2_PROTOCOL!="PCIEx2"))begin : BONDING_LANE01
        assign          i_p_tx0_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx1_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx2_clk_fr_core           = o_p_clk2core_tx_2; 
        assign          i_p_tx3_clk_fr_core           = o_p_clk2core_tx_3; 
        assign          i_p_rx0_clk_fr_core           = (CH0_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx1_clk_fr_core           = (CH1_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx2_clk_fr_core           = (CH2_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_2 : o_p_clk2core_tx_2;
        assign          i_p_rx3_clk_fr_core           = (CH3_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_3 : o_p_clk2core_tx_3;
    end
    else if((CH0_PROTOCOL!="CUSTOMERIZEDx2" && CH0_PROTOCOL!="PCIEx2") && (CH2_PROTOCOL=="CUSTOMERIZEDx2" || CH2_PROTOCOL=="PCIEx2")) begin : BONDING_LANE23
        assign          i_p_tx0_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx1_clk_fr_core           = o_p_clk2core_tx_1; 
        assign          i_p_tx2_clk_fr_core           = o_p_clk2core_tx_2; 
        assign          i_p_tx3_clk_fr_core           = o_p_clk2core_tx_2; 
        assign          i_p_rx0_clk_fr_core           = (CH0_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx1_clk_fr_core           = (CH1_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_1 : o_p_clk2core_tx_1;
        assign          i_p_rx2_clk_fr_core           = (CH2_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_2 : o_p_clk2core_tx_2;
        assign          i_p_rx3_clk_fr_core           = (CH3_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_2 : o_p_clk2core_tx_2;
    end
    else if((CH0_PROTOCOL=="CUSTOMERIZEDx2" || CH0_PROTOCOL=="PCIEx2") && (CH2_PROTOCOL=="CUSTOMERIZEDx2" || CH2_PROTOCOL=="PCIEx2")) begin : BONDING_LANE01_23
        assign          i_p_tx0_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx1_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx2_clk_fr_core           = o_p_clk2core_tx_2; 
        assign          i_p_tx3_clk_fr_core           = o_p_clk2core_tx_2; 
        assign          i_p_rx0_clk_fr_core           = (CH0_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx1_clk_fr_core           = (CH1_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx2_clk_fr_core           = (CH2_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_2 : o_p_clk2core_tx_2;
        assign          i_p_rx3_clk_fr_core           = (CH3_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_2 : o_p_clk2core_tx_2;
    end
    else begin : NO_BONDING
        assign          i_p_tx0_clk_fr_core           = o_p_clk2core_tx_0; 
        assign          i_p_tx1_clk_fr_core           = o_p_clk2core_tx_1; 
        assign          i_p_tx2_clk_fr_core           = o_p_clk2core_tx_2; 
        assign          i_p_tx3_clk_fr_core           = o_p_clk2core_tx_3; 
        assign          i_p_rx0_clk_fr_core           = (CH0_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_0 : o_p_clk2core_tx_0;
        assign          i_p_rx1_clk_fr_core           = (CH1_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_1 : o_p_clk2core_tx_1;
        assign          i_p_rx2_clk_fr_core           = (CH2_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_2 : o_p_clk2core_tx_2;
        assign          i_p_rx3_clk_fr_core           = (CH3_RXPCS_CTC=="Bypassed") ? o_p_clk2core_rx_3 : o_p_clk2core_tx_3;
    end
endgenerate

generate
    if(CH0_PROTOCOL=="PCIEx4") begin : PCIEx4
        assign          i_p_rx0_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_rx1_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_rx2_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_rx3_clk2_fr_core           = o_p_clk2core_rx_0;
    end
    else if(CH0_PROTOCOL=="PCIEx2" && CH2_PROTOCOL!="PCIEx2")begin : PCIEx2_01
        assign          i_p_rx0_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_rx1_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_rx2_clk2_fr_core           = 1'b0;
        assign          i_p_rx3_clk2_fr_core           = 1'b0;
    end
    else if(CH0_PROTOCOL!="PCIEx2" && CH2_PROTOCOL=="PCIEx2") begin : PCIEx2_23
        assign          i_p_rx0_clk2_fr_core           = 1'b0;
        assign          i_p_rx1_clk2_fr_core           = 1'b0;
        assign          i_p_rx2_clk2_fr_core           = o_p_clk2core_rx_2;
        assign          i_p_rx3_clk2_fr_core           = o_p_clk2core_rx_2;
    end
    else if(CH0_PROTOCOL=="PCIEx2" && CH2_PROTOCOL=="PCIEx2") begin : PCIEx2_01_23
        assign          i_p_rx0_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_rx1_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_rx2_clk2_fr_core           = o_p_clk2core_rx_2;
        assign          i_p_rx3_clk2_fr_core           = o_p_clk2core_rx_2;
    end
    else begin : NO_PCIEx2x4 
        assign          i_p_rx0_clk2_fr_core           = o_p_clk2core_rx_0;
        assign          i_p_rx1_clk2_fr_core           = o_p_clk2core_rx_1;
        assign          i_p_rx2_clk2_fr_core           = o_p_clk2core_rx_2;
        assign          i_p_rx3_clk2_fr_core           = o_p_clk2core_rx_3;
    end
endgenerate

assign i_p_tx0_clk2_fr_core = i_p_rx0_clk2_fr_core;
assign i_p_tx1_clk2_fr_core = i_p_rx1_clk2_fr_core;
assign i_p_tx2_clk2_fr_core = i_p_rx2_clk2_fr_core;
assign i_p_tx3_clk2_fr_core = i_p_rx3_clk2_fr_core;



//Checker
wire  [39:0] o_rxd_0                       ; // output [39:0]
wire  [3:0]  o_rxk_0                       ; // output [3:0]
wire         o_rxd_vld_0                   ; // output         
wire  [2:0]  o_rxh_0                       ; // output [2:0]   
wire         o_rxh_vld_0                   ; // output         
wire         o_rxq_start_0                 ; // output         
wire  [39:0] o_rxd_1                       ; // output [39:0]
wire  [3:0]  o_rxk_1                       ; // output [3:0]
wire         o_rxd_vld_1                   ; // output         
wire  [2:0]  o_rxh_1                       ; // output [2:0]   
wire         o_rxh_vld_1                   ; // output         
wire         o_rxq_start_1                 ; // output         
wire  [39:0] o_rxd_2                       ; // output [39:0]
wire  [3:0]  o_rxk_2                       ; // output [3:0]
wire         o_rxd_vld_2                   ; // output         
wire  [2:0]  o_rxh_2                       ; // output [2:0]   
wire         o_rxh_vld_2                   ; // output         
wire         o_rxq_start_2                 ; // output         
wire  [39:0] o_rxd_3                       ; // output [39:0]
wire  [3:0]  o_rxk_3                       ; // output [3:0]
wire         o_rxd_vld_3                   ; // output         
wire  [2:0]  o_rxh_3                       ; // output [2:0]   
wire         o_rxh_vld_3                   ; // output         
wire         o_rxq_start_3                 ; // output         
wire         o_p_rxgear_slip_0             ; 
wire         o_p_rxgear_slip_1             ; 
wire         o_p_rxgear_slip_2             ; 
wire         o_p_rxgear_slip_3             ; 

hsst_test U_INST (
    
    .i_free_clk                    (i_free_clk                    ), // input          
    .i_wtchdg_clr_0                (i_wtchdg_clr_0                ), // input          
    .o_wtchdg_st_0                 (o_wtchdg_st_0                 ), // output [1:0]   
    .o_pll_done_0                  (o_pll_done_0                  ), // output         
    .o_txlane_done_2               (o_txlane_done_2               ), // output         
    .o_txlane_done_3               (o_txlane_done_3               ), // output         
    .o_rxlane_done_2               (o_rxlane_done_2               ), // output         
    .o_rxlane_done_3               (o_rxlane_done_3               ), // output         
    .i_p_refckn_0                  (i_p_refckn_0                  ), // input          
    .i_p_refckp_0                  (i_p_refckp_0                  ), // input          
    .o_p_clk2core_tx_2             (o_p_clk2core_tx_2             ), // output         
    .i_p_tx2_clk_fr_core           (i_p_tx2_clk_fr_core           ), // input          
    .i_p_tx3_clk_fr_core           (i_p_tx3_clk_fr_core           ), // input          
    .i_p_rx2_clk_fr_core           (i_p_rx2_clk_fr_core           ), // input          
    .i_p_rx3_clk_fr_core           (i_p_rx3_clk_fr_core           ), // input          
    .o_p_pll_lock_0                (o_p_pll_lock_0                ), // output         
    .o_p_rx_sigdet_sta_2           (o_p_rx_sigdet_sta_2           ), // output         
    .o_p_rx_sigdet_sta_3           (o_p_rx_sigdet_sta_3           ), // output         
    .o_p_lx_cdr_align_2            (o_p_lx_cdr_align_2            ), // output         
    .o_p_lx_cdr_align_3            (o_p_lx_cdr_align_3            ), // output         
    .o_p_pcs_lsm_synced_2          (o_p_pcs_lsm_synced_2          ), // output         
    .o_p_pcs_lsm_synced_3          (o_p_pcs_lsm_synced_3          ), // output         
    .i_p_l2rxn                     (i_p_l2rxn                     ), // input          
    .i_p_l2rxp                     (i_p_l2rxp                     ), // input          
    .i_p_l3rxn                     (i_p_l3rxn                     ), // input          
    .i_p_l3rxp                     (i_p_l3rxp                     ), // input          
    .o_p_l2txn                     (o_p_l2txn                     ), // output         
    .o_p_l2txp                     (o_p_l2txp                     ), // output         
    .o_p_l3txn                     (o_p_l3txn                     ), // output         
    .o_p_l3txp                     (o_p_l3txp                     ), // output         
    .i_txd_2                       (i_txd_2                       ), // input  [31:0]  
    .i_tdispsel_2                  (i_tdispsel_2                  ), // input  [3:0]   
    .i_tdispctrl_2                 (i_tdispctrl_2                 ), // input  [3:0]   
    .i_txk_2                       (i_txk_2                       ), // input  [3:0]   
    .i_txd_3                       (i_txd_3                       ), // input  [31:0]  
    .i_tdispsel_3                  (i_tdispsel_3                  ), // input  [3:0]   
    .i_tdispctrl_3                 (i_tdispctrl_3                 ), // input  [3:0]   
    .i_txk_3                       (i_txk_3                       ), // input  [3:0]   
    .o_rxstatus_2                  (o_rxstatus_2[2:0]             ), // output [2:0]   
    .o_rxd_2                       (o_rxd_2[31:0]                 ), // output [31:0]  
    .o_rdisper_2                   (o_rdisper_2[3:0]              ), // output [3:0]   
    .o_rdecer_2                    (o_rdecer_2[3:0]               ), // output [3:0]   
    .o_rxk_2                       (o_rxk_2[3:0]                  ), // output [3:0]   
    .o_rxstatus_3                  (o_rxstatus_3[2:0]             ), // output [2:0]   
    .o_rxd_3                       (o_rxd_3[31:0]                 ), // output [31:0]  
    .o_rdisper_3                   (o_rdisper_3[3:0]              ), // output [3:0]   
    .o_rdecer_3                    (o_rdecer_3[3:0]               ), // output [3:0]   
    .o_rxk_3                       (o_rxk_3[3:0]                  ), // output [3:0]   
    .i_pll_rst_0                   (i_pll_rst_0                   )  // input  
);


// ********************* Source of DUT *********************

wire           i_src_clk0                    ;
wire           i_src_clk1                    ;
wire           i_src_clk2                    ;
wire           i_src_clk3                    ;
wire           i_src_rstn          = ~src_rst;
wire   [39:0]  o_txd_0                       ;
wire   [3:0]   o_txk_0                       ;
wire   [6:0]   o_txq_0                       ;
wire   [2:0]   o_txh_0                       ;
wire   [39:0]  o_txd_1                       ;
wire   [3:0]   o_txk_1                       ;
wire   [6:0]   o_txq_1                       ;
wire   [2:0]   o_txh_1                       ;
wire   [39:0]  o_txd_2                       ;
wire   [3:0]   o_txk_2                       ;
wire   [6:0]   o_txq_2                       ;
wire   [2:0]   o_txh_2                       ;
wire   [39:0]  o_txd_3                       ;
wire   [3:0]   o_txk_3                       ;
wire   [6:0]   o_txq_3                       ;
wire   [2:0]   o_txh_3                       ;

assign i_src_clk2 = i_p_tx2_clk_fr_core        ; 
assign i_src_clk3 = i_p_tx3_clk_fr_core        ; 
hsst_test_src2 U_INST_SRC (
    .i_src_clk0                    (i_src_clk0                    ), // input          
    .i_src_clk1                    (i_src_clk1                    ), // input          
    .i_src_clk2                    (i_src_clk2                    ), // input          
    .i_src_clk3                    (i_src_clk3                    ), // input          
    .i_src_rstn                    (i_src_rstn                    ), // input          
    .o_txd_0                       (o_txd_0                       ), // output [39:0]  
    .o_txk_0                       (o_txk_0                       ), // output [3:0]   
    .o_txq_0                       (o_txq_0                       ), // output [6:0]   
    .o_txh_0                       (o_txh_0                       ), // output [2:0]   
    .o_txd_1                       (o_txd_1                       ), // output [39:0]  
    .o_txk_1                       (o_txk_1                       ), // output [3:0]   
    .o_txq_1                       (o_txq_1                       ), // output [6:0]   
    .o_txh_1                       (o_txh_1                       ), // output [2:0]   
    .o_txd_2                       (o_txd_2                       ), // output [39:0]  
    .o_txk_2                       (o_txk_2                       ), // output [3:0]   
    .o_txq_2                       (o_txq_2                       ), // output [6:0]   
    .o_txh_2                       (o_txh_2                       ), // output [2:0]   
    .o_txd_3                       (o_txd_3                       ), // output [39:0]  
    .o_txk_3                       (o_txk_3                       ), // output [3:0]   
    .o_txq_3                       (o_txq_3                       ), // output [6:0]   
    .o_txh_3                       (o_txh_3                       ),// output [2:0]
//
    .rd2_en          (rd2_en  ),
    .almost_empty2   (almost_empty2),
    .rd2_data        (rd2_data),
    .rd3_en          (rd3_en  ),
    .almost_empty3   (almost_empty3),
    .rd3_data        (rd3_data),
    .cnt (cnt)
   
);
//测试输入通道二
/*wire inu2_clk;
assign inu2_clk=i_src_clk2;
wire inu2_rstn;
assign inu2_rstn=1'b0;
wire wfifo2_wr_en;
reg wfifo2_wr_en_ff;
assign wfifo2_wr_en=wfifo2_wr_en_ff;
wire [31:0] wfifo2_wr_data;

initial begin wfifo2_wr_data_ff=32'b0;wfifo2_wr_en_ff=1'b1;o_rd2_en_ff=1'b0; end

reg [31:0] wfifo2_wr_data_ff;
assign wfifo2_wr_data=wfifo2_wr_data_ff;
always @(posedge i_src_clk2) begin
    wfifo2_wr_en_ff <= wfifo2_wr_en_ff + 1'b1;
    wfifo2_wr_data_ff <= wfifo2_wr_data_ff + 32'b1;
end

wire inu2_clk_last;
assign inu2_clk_last=i_chk_clk2;
wire inu2_rstn_last;
assign inu2_rstn_last=1'b0;
wire rd2_en_last;
assign rd2_en_last=o_rd2_en_ff;
reg o_rd2_en_ff;
always @(posedge i_chk_clk2) begin
    o_rd2_en_ff<=o_rd2_en_ff+1'b1;
end*/
//测试输入通道三
/*wire inu3_clk;
assign inu3_clk=i_src_clk3;
wire inu3_rstn;
assign inu3_rstn=1'b0;
wire wfifo3_wr_en;
reg wfifo3_wr_en_ff;
assign wfifo3_wr_en=wfifo3_wr_en_ff;
wire [31:0] wfifo3_wr_data;

initial begin wfifo3_wr_data_ff=32'b0;wfifo3_wr_en_ff=1'b1;o_rd3_en_ff=1'b0; end

reg [31:0] wfifo3_wr_data_ff;
assign wfifo3_wr_data=wfifo3_wr_data_ff;
always @(posedge i_src_clk3) begin
    wfifo3_wr_en_ff <= wfifo3_wr_en_ff + 1'b1;
    wfifo3_wr_data_ff <= wfifo3_wr_data_ff + 32'b10;
end

wire inu3_clk_last;
assign inu3_clk_last=i_chk_clk3;
wire inu3_rstn_last;
assign inu3_rstn_last=1'b0;
wire rd3_en_last;
assign rd3_en_last=o_rd3_en_ff;
reg o_rd3_en_ff;
always @(posedge i_chk_clk3) begin
    o_rd3_en_ff<=o_rd3_en_ff+1'b1;
end*/
//测试输入end



wire [15:0] cnt;
wire rd2_en;
wire [31:0] rd2_data;
wire almost_empty2;
wire wfifo2_rd_empty;
wfifo u2_wfifo (
    .wr_clk         ( inu2_clk                 ),      // input
    .wr_rst         ( inu2_rstn                 ),      // input
    .wr_en          ( wfifo2_wr_en ),      // input
    .wr_data        ( wfifo2_wr_data               ),      // input 
    .wr_full        ( wfifo2_wr_full       ),      // output
    .almost_full    ( wfifo2_almost_full           ),      // output
    .rd_clk         ( i_src_clk2                 ),      // input
    .rd_rst         ( !i_src_rstn                 ),      // input
    .rd_en          ( rd2_en                      ),      // input
    .rd_data        ( rd2_data                    ),      
    .rd_empty       ( wfifo2_rd_empty                   ),      // output
    .almost_empty   ( almost_empty2               )       // output
);

wire rd3_en;
wire [31:0] rd3_data;
wire almost_empty3;
wire wfifo3_rd_empty;
wfifo u3_wfifo (
    .wr_clk         ( inu3_clk                 ),      // input
    .wr_rst         ( inu3_rstn                 ),      // input
    .wr_en          ( wfifo3_wr_en ),      // input
    .wr_data        ( wfifo3_wr_data               ),      // input 
    .wr_full        ( wfifo3_wr_full       ),      // output
    .almost_full    ( wfifo3_almost_full           ),      // output
    .rd_clk         ( i_src_clk3                 ),      // input
    .rd_rst         ( !i_src_rstn                 ),      // input
    .rd_en          ( rd3_en                      ),      // input
    .rd_data        ( rd3_data                    ),      
    .rd_empty       ( wfifo3_rd_empty                   ),      // output
    .almost_empty   ( almost_empty3               )       // output
);


assign i_txd_2                       = o_txd_2[31:0];
assign i_tdispsel_2                  = 4'b0;
assign i_tdispctrl_2                 = 4'b0;
assign i_txk_2                       = o_txk_2[3:0] ;
assign i_txd_3                       = o_txd_3[31:0];
assign i_tdispsel_3                  = 4'b0;
assign i_tdispctrl_3                 = 4'b0;
assign i_txk_3                       = o_txk_3[3:0] ;
// ********************* Checker of DUT *********************

wire            i_chk_clk0                    ;
wire            i_chk_clk1                    ;
wire            i_chk_clk2                    ;
wire            i_chk_clk3                    ;
wire    [3:0]   i_chk_rstn                    ;
wire    [2:0]   i_rxstatus_0                  ;
wire    [39:0]  i_rxd_0                       ;
wire    [3:0]   i_rdisper_0                   ;
wire    [3:0]   i_rdecer_0                    ;
wire    [3:0]   i_rxk_0                       ; 
wire            i_rxd_vld_0                   ;
wire    [2:0]   i_rxh_0                       ;
wire            i_rxh_vld_0                   ;
wire            i_rxq_start_0                 ;
wire    [2:0]   i_rxstatus_1                  ;
wire    [39:0]  i_rxd_1                       ;
wire    [3:0]   i_rdisper_1                   ;
wire    [3:0]   i_rdecer_1                    ;
wire    [3:0]   i_rxk_1                       ; 
wire            i_rxd_vld_1                   ;
wire    [2:0]   i_rxh_1                       ;
wire            i_rxh_vld_1                   ;
wire            i_rxq_start_1                 ;
wire    [2:0]   i_rxstatus_2                  ;
wire    [39:0]  i_rxd_2                       ;
wire    [3:0]   i_rdisper_2                   ;
wire    [3:0]   i_rdecer_2                    ;
wire    [3:0]   i_rxk_2                       ; 
wire            i_rxd_vld_2                   ;
wire    [2:0]   i_rxh_2                       ;
wire            i_rxh_vld_2                   ;
wire            i_rxq_start_2                 ;
wire    [2:0]   i_rxstatus_3                  ;
wire    [39:0]  i_rxd_3                       ;
wire    [3:0]   i_rdisper_3                   ;
wire    [3:0]   i_rdecer_3                    ;
wire    [3:0]   i_rxk_3                       ; 
wire            i_rxd_vld_3                   ;
wire    [2:0]   i_rxh_3                       ;
wire            i_rxh_vld_3                   ;
wire            i_rxq_start_3                 ;


assign i_chk_clk2 = i_p_rx2_clk_fr_core         ;  
assign i_chk_clk3 = i_p_rx3_clk_fr_core         ;   

//Sync Check Module Reset Signal
ipml_hsst_rst_sync_v1_0 chk_rstn_sync0 (.clk(i_chk_clk0), .rst_n(~chk_rst), .sig_async(1'b1), .sig_synced(i_chk_rstn[0]));
ipml_hsst_rst_sync_v1_0 chk_rstn_sync1 (.clk(i_chk_clk1), .rst_n(~chk_rst), .sig_async(1'b1), .sig_synced(i_chk_rstn[1]));
ipml_hsst_rst_sync_v1_0 chk_rstn_sync2 (.clk(i_chk_clk2), .rst_n(~chk_rst), .sig_async(1'b1), .sig_synced(i_chk_rstn[2]));
ipml_hsst_rst_sync_v1_0 chk_rstn_sync3 (.clk(i_chk_clk3), .rst_n(~chk_rst), .sig_async(1'b1), .sig_synced(i_chk_rstn[3]));


hsst_test_chk2 U_INST_CHK (
    .i_chk_clk0                    (i_chk_clk0                    ), // input           
    .i_chk_clk1                    (i_chk_clk1                    ), // input           
    .i_chk_clk2                    (i_chk_clk2                    ), // input           
    .i_chk_clk3                    (i_chk_clk3                    ), // input           
    .i_chk_rstn                    (i_chk_rstn                    ), // input  [3:0]          
    .i_rxstatus_0                  (i_rxstatus_0                  ), // input  [2:0]    
    .i_rxd_0                       (i_rxd_0                       ), // input  [39:0]   
    .i_rdisper_0                   (i_rdisper_0                   ), // input  [3:0]    
    .i_rdecer_0                    (i_rdecer_0                    ), // input  [3:0]    
    .i_rxk_0                       (i_rxk_0                       ), // input  [3:0]     
    .i_rxd_vld_0                   (i_rxd_vld_0                   ), // input 
    .i_rxh_0                       (i_rxh_0                       ), // input  [2:0] 
    .i_rxh_vld_0                   (i_rxh_vld_0                   ), // input 
    .i_rxq_start_0                 (i_rxq_start_0                 ), // input 
    .o_p_rxgear_slip_0             (o_p_rxgear_slip_0             ), // output
    .i_rxstatus_1                  (i_rxstatus_1                  ), // input  [2:0]    
    .i_rxd_1                       (i_rxd_1                       ), // input  [39:0]   
    .i_rdisper_1                   (i_rdisper_1                   ), // input  [3:0]    
    .i_rdecer_1                    (i_rdecer_1                    ), // input  [3:0]    
    .i_rxk_1                       (i_rxk_1                       ), // input  [3:0]     
    .i_rxd_vld_1                   (i_rxd_vld_1                   ), // input 
    .i_rxh_1                       (i_rxh_1                       ), // input  [2:0] 
    .i_rxh_vld_1                   (i_rxh_vld_1                   ), // input 
    .i_rxq_start_1                 (i_rxq_start_1                 ), // input 
    .o_p_rxgear_slip_1             (o_p_rxgear_slip_1             ), // output
    .i_rxstatus_2                  (i_rxstatus_2                  ), // input  [2:0]    
    .i_rxd_2                       (i_rxd_2                       ), // input  [39:0]   
    .i_rdisper_2                   (i_rdisper_2                   ), // input  [3:0]    
    .i_rdecer_2                    (i_rdecer_2                    ), // input  [3:0]    
    .i_rxk_2                       (i_rxk_2                       ), // input  [3:0]     
    .i_rxd_vld_2                   (i_rxd_vld_2                   ), // input 
    .i_rxh_2                       (i_rxh_2                       ), // input  [2:0] 
    .i_rxh_vld_2                   (i_rxh_vld_2                   ), // input 
    .i_rxq_start_2                 (i_rxq_start_2                 ), // input 
    .o_p_rxgear_slip_2             (o_p_rxgear_slip_2             ), // output
    .i_rxstatus_3                  (i_rxstatus_3                  ), // input  [2:0]    
    .i_rxd_3                       (i_rxd_3                       ), // input  [39:0]   
    .i_rdisper_3                   (i_rdisper_3                   ), // input  [3:0]    
    .i_rdecer_3                    (i_rdecer_3                    ), // input  [3:0]    
    .i_rxk_3                       (i_rxk_3                       ), // input  [3:0]   
    .i_rxd_vld_3                   (i_rxd_vld_3                   ), // input 
    .i_rxh_3                       (i_rxh_3                       ), // input  [2:0] 
    .i_rxh_vld_3                   (i_rxh_vld_3                   ), // input 
    .i_rxq_start_3                 (i_rxq_start_3                 ), // input 
    .o_p_rxgear_slip_3             (o_p_rxgear_slip_3             ), // output
    

.rfifo2_almost_full(rfifo2_almost_full),
.o_fifo2_wr_data(o_fifo2_wr_data),
.o_fifo2_wr_en(o_fifo2_wr_en),

.rfifo3_almost_full(rfifo3almost_full),
.o_fifo3_wr_data(o_fifo3_wr_data),
.o_fifo3_wr_en(o_fifo3_wr_en),
//ceshi
.k2(k2),
.k3(k3)
);
wire [3:0]k2;
wire o_fifo2_wr_en;
wire [31:0] o_fifo2_wr_data;
wire rfifo2_wr_full;
wire rfifo2_almost_full;

rfifo u2_rfifo (
    .wr_clk         ( i_chk_clk2                 ),      // input
    .wr_rst         ( i_chk_rstn                 ),      // input
    .wr_en          ( o_fifo2_wr_en ),      // input
    .wr_data        ( o_fifo2_wr_data        ),      // input [128:0]
    .wr_full        ( rfifo2_wr_full               ),      // output
    .almost_full    ( rfifo2_almost_full           ),      // output
    .rd_clk         ( inu2_clk_last               ),      // input
    .rd_rst         ( inu2_rstn_last             ),      // input
    .rd_en          ( rd2_en_last                     ),      // input
    .rd_data        ( rd2_data_last                   ),      
    .rd_empty       (                            ),      // output
    .almost_empty   ( almost_empty_last2          )       // output
);


wire [3:0]k3;
wire o_fifo3_wr_en;
wire [31:0] o_fifo3_wr_data;
wire rfifo3_wr_full;
wire rfifo3_almost_full;

rfifo u3_rfifo (
    .wr_clk         ( i_chk_clk3                 ),      // input
    .wr_rst         ( i_chk_rstn                 ),      // input
    .wr_en          ( o_fifo3_wr_en ),      // input
    .wr_data        ( o_fifo3_wr_data        ),      // input [128:0]
    .wr_full        ( rfifo3_wr_full               ),      // output
    .almost_full    ( rfifo3_almost_full           ),      // output
    .rd_clk         ( inu3_clk_last               ),      // input
    .rd_rst         ( inu3_rstn_last             ),      // input
    .rd_en          ( rd3_en_last                     ),      // input
    .rd_data        ( rd3_data_last                   ),      
    .rd_empty       (                            ),      // output
    .almost_empty   ( almost_empty_last3          )       // output
);



assign i_rxstatus_2[2:0]             = o_rxstatus_2[2:0]       ;
assign i_rxd_2[31:0]                 = o_rxd_2[31:0]           ;
assign i_rdisper_2[3:0]              = o_rdisper_2[3:0]        ;
assign i_rdecer_2[3:0]               = o_rdecer_2[3:0]         ;
assign i_rxk_2[3:0]                  = o_rxk_2[3:0]            ;
assign i_rxd_vld_2                   = 1'b0                    ;
assign i_rxh_2                       = 3'b0                    ;
assign i_rxh_vld_2                   = 1'b0                    ;
assign i_rxq_start_2                 = 1'b0                    ;
assign i_rxstatus_3[2:0]             = o_rxstatus_3[2:0]       ;
assign i_rxd_3[31:0]                 = o_rxd_3[31:0]           ;
assign i_rdisper_3[3:0]              = o_rdisper_3[3:0]        ;
assign i_rdecer_3[3:0]               = o_rdecer_3[3:0]         ;
assign i_rxk_3[3:0]                  = o_rxk_3[3:0]            ;
assign i_rxd_vld_3                   = 1'b0                    ;
assign i_rxh_3                       = 3'b0                    ;
assign i_rxh_vld_3                   = 1'b0                    ;
assign i_rxq_start_3                 = 1'b0                    ;



endmodule    
