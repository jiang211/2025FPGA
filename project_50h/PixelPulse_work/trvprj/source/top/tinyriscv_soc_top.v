 /*                                                                      
 Copyright 2020 Blue Liang, liangkangnan@163.com
                                                                         
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
                                                                         
     http://www.apache.org/licenses/LICENSE-2.0                          
                                                                         
 Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
 */

`include "../core/defines.v"

// tinyriscv soc顶层模块
module tinyriscv_soc_top(

    input wire clk,
    input wire rst,

    output wire halted_ind,  // jtag是否已经halt住CPU信号

    output wire uart_tx_pin, // UART发送引脚
    input wire uart_rx_pin,  // UART接收引脚

    inout wire[15:0] gpio,    // GPIO引脚

    input wire jtag_TCK,     // JTAG TCK引脚
    input wire jtag_TMS,     // JTAG TMS引脚
    input wire jtag_TDI,     // JTAG TDI引脚
    output wire jtag_TDO,     // JTAG TDO引脚
    
    // HDMI
    output wire iic_tx_scl    ,
    inout  wire iic_tx_sda    ,
    output wire vs_out,
    output wire hs_out,
    output wire de_out,
    output wire[7:0]r_out,
    output wire[7:0]g_out,
    output wire[7:0]b_out,
    output wire rstn_out,
    output wire pix_clk,
input    wire  [11:0]ad_data_in   ,
input    wire  [11:0]ad_data_in_b   ,

      output			Adc_Clk_A,	// 通道A时钟
	  output			Adc_Clk_B,	// 通道B时钟
      output wire [1:0] tx_disable,
      input          i_free_clk                    ,
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
      output [3:0]   o_rdecer_3,
      //output [7:0]   led                          , 
//ceshi
output [3:0]k,
output rfifo_almost_full,
output renceshi,
output  almost_empty_last,
output  [7:0] ad_data_inceshi,
output wire ren         ,

output [11:0] test,
output [11:0] test1

    );

   
    // jtag
    wire jtag_halt_req_o;
    wire jtag_reset_req_o;
    wire[4:0] jtag_reg_addr_o;
    wire[31:0] jtag_reg_data_o;
    wire jtag_reg_we_o;
    wire[31:0] jtag_reg_data_i;

    // tinyriscv
    wire[`INT_WIDTH-1:0] int_flag;
    wire rst_n;
    wire jtag_rst_n;


    assign int_flag = {(`INT_WIDTH){1'b0}};

    wire    sys_clk;

    pll sys_pll (
      .clkin1(clk),        // input
      .pll_lock(),    // output
      .clkout0(sys_clk)       // output
    );
    
    pll2 hdmi_pll (
        .clkin1   (  clk    ),//50MHz
        .clkout0  (  pix_clk    ),//148.5MHz
        .clkout1  (  cfg_clk    ),//10MHz
        .pll_lock (  locked     )
    );

    // 复位控制模块例化
    rst_ctrl u_rst_ctrl(
        .clk(sys_clk),
        .rst_ext_i(rst),
        .rst_jtag_i(jtag_reset_req_o),
        .core_rst_n_o(rst_n),
        .jtag_rst_n_o(jtag_rst_n)
    );

    // 低电平点亮LED
    // 低电平表示已经halt住CPU
    assign halted_ind = ~jtag_halt_req_o;

   
    
    
    wire    clk_29_7_1M,clk_29_7_2M;;
    wire cha_clk;
    assign Adc_Clk_A = clk_29_7_1M;
    assign Adc_Clk_B = clk_29_7_2M;
    wire [31:0] c_en;
    optical_fiber_top u0(
        .i_free_clk                                 (   clk             ),
        .rst_n                                      (rst_n                  ),
        .o_wtchdg_st_0                              (o_wtchdg_st_0          ),
        .o_pll_done_0                               (o_pll_done_0           ),
        .o_txlane_done_2                            (o_txlane_done_2        ),
        .o_txlane_done_3                            (o_txlane_done_3        ),
        .o_rxlane_done_2                            (o_rxlane_done_2        ),
        .o_rxlane_done_3                            (o_rxlane_done_3        ),
        .i_p_refckn_0                               (i_p_refckn_0           ),
        .i_p_refckp_0                               (i_p_refckp_0           ),
        .o_p_pll_lock_0                             (o_p_pll_lock_0         ),
        .o_p_rx_sigdet_sta_2                        (o_p_rx_sigdet_sta_2    ),
        .o_p_rx_sigdet_sta_3                        (o_p_rx_sigdet_sta_3    ),
        .o_p_lx_cdr_align_2                         (o_p_lx_cdr_align_2     ),
        .o_p_lx_cdr_align_3                         (o_p_lx_cdr_align_3     ),
        .o_p_pcs_lsm_synced_2                       (o_p_pcs_lsm_synced_2   ),
        .o_p_pcs_lsm_synced_3                       (o_p_pcs_lsm_synced_3   ),
        .i_p_l2rxn                                  (i_p_l2rxn              ),
        .i_p_l2rxp                                  (i_p_l2rxp              ),
        .i_p_l3rxn                                  (i_p_l3rxn              ),
        .i_p_l3rxp                                  (i_p_l3rxp              ),
        .o_p_l2txn                                  (o_p_l2txn              ),
        .o_p_l2txp                                  (o_p_l2txp              ),
        .o_p_l3txn                                  (o_p_l3txn              ),
        .o_p_l3txp                                  (o_p_l3txp              ),
        .o_rxstatus_2                               (o_rxstatus_2           ),
        .o_rxstatus_3                               (o_rxstatus_3           ),
        .o_rdisper_2                                (o_rdisper_2            ),
        .o_rdecer_2                                 (o_rdecer_2             ),
        .o_rdisper_3                                (o_rdisper_3            ),
        .o_rdecer_3                                 (o_rdecer_3             ), 
        .tx_disable                                 (tx_disable             ),
        .inu2_clk                                   ( inus_clk ),    
        .inu2_rstn                                  ( !rst_n              ),
        .wfifo2_wr_en                               (  1'b1          ),
        .wfifo2_wr_data                             (  data_b ),
        .wfifo2_wr_full                             (                   ),//�����źţ����Բ���
        .wfifo2_almost_full                         (                   ),
        .almost_empty2                              (                   ), 
        .inu3_clk                                   (    inus_clk       ),
        .inu3_rstn                                  (    !rst_n     ),
        .wfifo3_wr_en                               (    1'b1          ),   
        .wfifo3_wr_data                             (    {data_b,data_a}         ),   
        .wfifo3_wr_full                             (                   ),//�����źţ����Բ���
        .wfifo3_almost_full                         (                   ),
        .almost_empty3                              (                   ),     
        .inu2_clk_last                              (            ),
        .inu2_rstn_last                             (  !rst_n       ),   
        .rd2_en_last                                (  1'b1           ),
        .rd2_data_last                              (              ),
        .almost_empty_last2                         (                   ),
        .inu3_clk_last                              (   clk       ),
        .inu3_rstn_last                             (  !rst_n         ),   
        .rd3_en_last                                (   1'b1           ),
        .rd3_data_last                              (   c_en        ),   
        .almost_empty_last3                         (                   ),    
        .cnt                                        (                   ),
        .k2                                         (                   ),
        .k3                                         (                   )   
    );
    wire en;
    assign en = c_en[0];
    wire inus_clk;
    wire [13:0] inu3_data;
    assign inus_clk = (en) ? cha_clk : Adc_Clk_A;
    assign inu3_data = data_a;
assign test1 = ad_data_in_b;
assign test = ad_data_in;
    reg [11:0] data_a;
    reg [11:0] data_b;
    always @(posedge clk_29_7_1M) begin
       data_a <= ad_data_in;
    end
    always @(posedge clk_29_7_1M) begin
       data_b <= ad_data_in_b;
    end
    //assign led = data_b;
    
    pll_adda u_pll_adda (
      .clkin1(clk),         // input
      .pll_lock( ),      // output     // output   //118.8Mhz
      .clkout0(clk_29_7_1M),        // output   //29.7Mhz
      .clkout1(clk_29_7_2M),
      .clkout2(cha_clk)        // output
    );
    
endmodule
