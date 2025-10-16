`define UD #1
module top(
    input wire        sys_clk       ,// input system clock 50MHz    
    output            rstn_out      ,
    output            iic_tx_scl    ,
    inout             iic_tx_sda    ,
    inout            touch_sda  ,  //TOUCH IIC数据
    output           touch_scl  ,  //TOUCH IIC时钟
    inout            touch_int  ,  //TOUCH INT信号
    output           touch_rst_n,  //TOUCH 复位信号
    input     [7:0]   key           ,
    output            led_int       ,
    output[7:0]     led,
    output   lcd_bl,
//hsst
    input    wire  rst_n             ,
    output wire [1:0] tx_disable,
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
//hdmi_out 
    output            pix_clk       ,//pixclk                           
    output            vs_out        , 
    output            hs_out        , 
    output            de_out        ,
    output     [15:0] rgb_data,
    output         beef     ,

output [7:0] test,
output [7:0] test1,
output spike_replace_sum,
output spike_replace_x3,
output spike_replace_sum1,
output spike_replace_x31,
output spike1,
output [10:0] v1,
output [10:0] v2
 );

assign lcd_bl = 1'b1;
parameter   X_WIDTH = 4'd12;
parameter   Y_WIDTH = 4'd12;    
wire [7:0] ad_data_hsst;
wire [15:0] rgb_data_pa;
wire [31:0] xh_control;
wire [31:0]inu3_data;
wire [31:0]inu2_data;
optical_fiber_top u0(
    .i_free_clk                                 (   sys_clk             ),
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
    .inu2_clk                                   ( sys_clk     ),    
    .inu2_rstn                                  ( !rst_n              ),
    .wfifo2_wr_en                               (  1'b1          ),
    .wfifo2_wr_data                             (  xh_control       ),
    .wfifo2_wr_full                             (                   ),//�����źţ����Բ���
    .wfifo2_almost_full                         (                   ),
    .almost_empty2                              (                   ), 
    .inu3_clk                                   (    sys_clk       ),
    .inu3_rstn                                  (    !rst_n     ),
    .wfifo3_wr_en                               (    1'b1          ),   
    .wfifo3_wr_data                             (    {zon,chaf}               ),   
    .wfifo3_wr_full                             (                   ),//�����źţ����Բ���
    .wfifo3_almost_full                         (                   ),
    .almost_empty3                              (                   ),     
    .inu2_clk_last                              (  ad_clk    ),
    .inu2_rstn_last                             (  !rst_n       ),   
    .rd2_en_last                                (  1'b1           ),
    .rd2_data_last                              (  inu2_data   ),
    .almost_empty_last2                         (                   ),
    .inu3_clk_last                              (   ad_clk         ),
    .inu3_rstn_last                             (  !rst_n         ),   
    .rd3_en_last                                (   1'b1           ),
    .rd3_data_last                              (   inu3_data          ),   
    .almost_empty_last3                         (                   ),    
    .cnt                                        (                   ),
    .k2                                         (                   ),
    .k3                                         (                   )   
);
assign test = inu3_data[11:4];
assign test1 = inu3_data[23:16];
wire clk_a;
wire clk_b;
assign clk_a = inu3_clk;
assign clk_b = ~clk_a;

wire [11:0] ad_data;
wire [11:0] ad_data2;
assign ad_data = inu3_data[11:0];
assign ad_data2 = inu3_data[23:12];

wire cha_clk;
wire inu3_clk;
//assign led = ad_data2;
assign inu3_clk = (chaf) ? cha_clk : ad_clk;

wire [31:0] data;
touch_top  u_touch_top(
    .clk            (sys_clk    ),
    .rst_n          (rst_n  ),

    .touch_rst_n    (touch_rst_n),
    .touch_int      (touch_int  ),
    .touch_scl      (touch_scl  ),
    .touch_sda      (touch_sda  ),
    
    .lcd_id         ('h7016     ),
    .data           (data       )
);


//MODE_1080p
    parameter V_TOTAL = 12'd635;           
    parameter V_FP = 12'd12;               
    parameter V_BP = 12'd20;               
    parameter V_SYNC = 12'd3;              
    parameter V_ACT = 12'd600;             
    parameter H_TOTAL = 12'd1344;          
    parameter H_FP = 12'd160;              
    parameter H_BP = 12'd140;              
    parameter H_SYNC = 12'd20;             
    parameter H_ACT = 12'd1024;            
    parameter HV_OFFSET = 12'd0;     
    parameter integer DATAIN_WIDTH    = 16   ;
    parameter integer DATAOUT_WIDTH   = 32   ;
    parameter integer USER_WIDTH      = 16   ;
    //wire                        pix_clk    ;
    wire                        cfg_clk    ;
    wire                        locked     ;
    wire                        rstn       ;
    wire                        init_over  ;
    reg  [15:0]                 rstn_1ms   ;
    wire [X_WIDTH - 1'b1:0]     act_x      ;
    wire [Y_WIDTH - 1'b1:0]     act_y      ;    
    wire                        hs         ;
    wire                        vs         ;
    wire                        de         ;
    reg  [3:0]                  reset_delay_cnt;

    wire [7:0]da_data;
    wire signed [7:0] filter_out1,filter_out2;
    wire signed [7:0] filt_in1,filt_in2;
    wire [7:0] wave_data_dis1,wave_data_dis2;
    wire [10:0]max1,min1,v1,
               max2,min2,v2;
    wire [31:0] fre1,fre2;
    wire da_clk;
    wire vs_out_bg,hs_out_bg,de_out_bg;
    wire vs_out_w,hs_out_w,de_out_w,
         vs_out_c,hs_out_c,de_out_c,
         vs_out_d1,hs_out_d1,de_out_d1,
         vs_out_d2,hs_out_d2,de_out_d2,
         vs_out_w_1,hs_out_w_1,de_out_w_1,
         vs_out_fft,hs_out_fft,de_out_fft,
         vs_out_f,hs_out_f,de_out_f;
    wire [15:0] rgb_out_w,
                rgb_out_c,
                rgb_out_d1,
                rgb_out_w_1,
                rgb_fft,
                rgb_out_f,
                rgb_out;
    wire ad_clk1;
    pll u_pll (
        .clkin1   (  sys_clk    ),//50MHz
        .clkout0  (  pix_clk    ),//148.5MHz
        .clkout1  (  cfg_clk    ),//10MHz
        .clkout2  (  ad_clk     ),
        .clkout3  (  cha_clk     ),//10MHz
        .clkout4  (ad_clk1),
        .pll_lock (  locked     )
    );
/*
    ms72xx_ctl ms72xx_ctl(
        .clk         (  cfg_clk    ), //input       clk,
        .rst_n       (  rstn_out   ), //input       rstn,
                                
        .init_over   (  init_over  ), //output      init_over,
        .iic_tx_scl  (  iic_tx_scl ), //output      iic_scl,
        .iic_tx_sda  (  iic_tx_sda ), //inout       iic_sda
        .iic_scl     (  iic_scl    ), //output      iic_scl,
        .iic_sda     (  iic_sda    )  //inout       iic_sda
    );
*/
   assign    led_int    =     (fre1 > 0) ? 1'b1 : 1'b0;
    
    always @(posedge cfg_clk)
    begin
    	if(!locked)
    	    rstn_1ms <= 16'd0;
    	else
    	begin
    		if(rstn_1ms == 16'h2710)
    		    rstn_1ms <= rstn_1ms;
    		else
    		    rstn_1ms <= rstn_1ms + 1'b1;
    	end
    end
    
    assign rstn_out = (rstn_1ms == 16'h2710);
    
    
  

    /*******************************网表型************************************/
wire  [DATAOUT_WIDTH-1:0]     fft_amplitude_frequency_data1;
wire  [DATAOUT_WIDTH-1:0]     fifo_wr_data1                ;
wire  [DATAOUT_WIDTH-1:0]     fifo_rd_data1                ;
wire  [15:0]                  pixel_data                   ;
wire                          rd_en1                       ;
wire                          data_req1                    ;
wire                          fft_point_done1              ;
wire                          data_input_start_flag1       ;
wire  [11:0]                   fft_point_cnt1               ;
wire                          fifo_rd_empty1               ;
wire  [11:0]                  fifo_wr_cnt1                 ;
wire                          fifo_rd_req1                 ;
wire                          fifo_pre_rd_req1             ;
wire                          fifo_wr_req1                 ;
wire                          rdata_req1                   ;
wire                          video_vs                     ;  //场同步信号
wire                          video_hs                     ;  //行同步信号
wire                          video_de                     ;  //数据使能
wire  [15:0]                  video_rgb_565                ;  //rgb565颜色数据
wire  [10:0]                  pixel_xpos                   ;
wire  [10:0]                  pixel_ypos                   ;
wire  [10:0]                  h_disp                       ;
wire  [10:0]                  v_disp                       ;

wire  [15:0]                  fft_data_in                  ;
wire [2:0]Interface_control,rest;
wire [12:0] x,y;
wire fft;
wire stop;
wire td1;
wire td2;
wire chaf;
wire [2:0] p_x1;
wire [2:0] p_x2;
wire [4:0] p_y;
wire zon;
wire cz;

wire [10:0] targe_fre,targe_vpp,targe_wr_vpp;
//assign led = data[7:0];
touch_data_hd  u_touch_hd(
    .clk                (sys_clk),
    .reset              (rst_n),
    .data_in            (data),
    .Interface_control  (Interface_control),
    .rest               (rest),
    .x                  (x),
    .y                  (y)          ,
    .xh_control         (xh_control),
    .targe_fre          (targe_fre),
    .targe_vpp          (targe_vpp),
    .targe_wr_vpp       (targe_wr_vpp),
    .fft_                (fft),
    .stop_               (stop),
    .td1_                (td1),
    .td2_                (td2),
    .chaf_               (chaf),
    .p_x1_               (p_x1),
    .p_x2_               (p_x2),
    .p_y_                (p_y),
    .zon                 (zon),
    .cz_                 (cz)
);
    led_test u_led_test(
       .clk(sys_clk),
       .rstn(rst_n),
       .en(zon),
       .beef(beef)  
    );
wire stop1,stop2;
wire [7:0] amp_h1,amp_h2;
wire [7:0] p_x11,p_x21;
assign stop1 = (td1 == 1'b1) ? stop : 1'b0;
assign stop2 = (td2 == 1'b1) ? stop : 1'b0;
assign amp_h1 = p_y ;
assign amp_h2 = p_y ;
assign p_x11 = p_x2 ;
assign p_x21 = p_x2 ;
wire [15:0] wav2_color = (td1 == 1'b1) ? 16'h0 : 24'hffd700;
wire [15:0] wav1_color = (td2 == 1'b1) ? 16'h0 : 16'h5ff;

wire clk_20M,clk_40M,clk_60M,clk_80M,clk_100M;
    dis_clk pl(
        .clkin1(clk_50M),     
        .pll_lock(        ),  
        .clkout0(clk_20M),  
        .clkout1(clk_40M),   
        .clkout2(clk_60M),
        .clkout3(clk_80M),
        .clkout4(clk_100M)
    );
     
    wire d_clk;
    assign d_clk =  (p_x1 == 3'd0)? clk_100M :
                    (p_x1 == 3'd1)? clk_80M :
                    (p_x1 == 3'd2)? clk_60M :
                    (p_x1 == 3'd3)? clk_40M :
                    (p_x1 == 3'd4)? clk_20M :
                    clk_60M;
    
    data_quant u_data_quant1(
        .clk(sys_clk),
        .rst(locked),
        .data_in(ad_data2[11:4]),
        .max(max1),
        .min(min1),
        //.v(v1),
        .spike_replace_sum (spike_replace_sum1),
        .spike_replace_x3   (spike_replace_x31)
    );

    data_quant u_data_quant2(
        .clk(sys_clk),
        .rst(locked),
        .data_in(ad_data[11:4]),
        .max(max2),
        .min(min2),
        //.v(v2),
        .spike_replace_sum (spike_replace_sum),
        .spike_replace_x3   (spike_replace_x3)
    );
/////////// 1 有点问题，需要调试
    voltage_quant#(
        .V1 ('d2215),
        .V2 ('d2292),
        .V3 ('d2370),
        .V4 ('d2477),
        .V5 ('d2580),
        .V6 ('d2680),
        .V7 ('d2792),
        .V8 ('d2909),
        .V9 ('d3008),
        .V10('d3108),
        .VMAX    (12'd3060     ),                           
        .VMIN    (12'd1024    ),
        .VMID    (12'd2083    )                     
    ) u_voltage_quant_1 (
        .clk            (sys_clk),       
        .rst            (locked),    
        .data_in        (ad_data2),   
        .volt_out       (v1)
    );

    voltage_quant#(
        .V1 ('d2160),
        .V2 ('d2291),
        .V3 ('d2377),
        .V4 ('d2477),
        .V5 ('d2574),
        .V6 ('d2670),
        .V7 ('d2789),
        .V8 ('d2890),
        .V9 ('d2990),
        .V10('d3092),
        .VMAX    (12'd3060     ),                           
        .VMIN    (12'd1024    ),
        .VMID    (12'd2055    )                    
    ) u_voltage_quant_2 (
        .clk            (sys_clk),       
        .rst            (locked),    
        .data_in        (ad_data),   
        .volt_out       (v2)
    );


    wire gate_n1,gate_n2;
    fre_quant u_fre_quant1(
        .clk(sys_clk),
        .rst(locked),
        .data_in(ad_data2[11:4]),
        .gate_n (gate_n1),
        .fre(fre1)
    );

    fre_quant u_fre_quant2(
        .clk(sys_clk),
        .rst(locked),
        .data_in(ad_data[11:4]),
        .gate_n (gate_n2),
        .fre(fre2)
    );
    wire [7:0] data_match;
    soft_clip_8 u_soft_clip_8_1(
    .clk                    (sys_clk           ),
    .rst_n                  (locked        ),
    .din                    (ad_data[11:4]),
    .dout                   (data_match)
   // .spike                  (spike1)
);
    soft_clip_8 u_soft_clip_8_2(
    .clk                    (sys_clk           ),
    .rst_n                  (locked        ),
    .din                    (ad_data2[11:4]),
    .dout                   (data_match2)
   // .spike                  (spike1)
);
    wire [10:0] phase1;
    phase_top u_phase_top(
    .clk                 (sys_clk),
    .rst_n               (gate_n2),

    .wave_a              (data_match2),
    .wave_b              (data_match),  
    .amplitude           (max2),
    .phase               (phase1)   
);

    wire [1:0] choose1,choose2;
    assign led = choose1;
    ai_match_top u_ai_match_top(
        .clk            (sys_clk  ),
        .rst_n          (locked   ),
        .gate           (gate_n2  ),
        .freq_word      (fre2 * 1000),
        .amplitude      (max2),  // 峰值（正数）
  

        .wave_in        (data_match),
        .wave_type      (choose1)
    );

    ai_match_top u_ai_match_top2(
        .clk            (sys_clk  ),
        .rst_n          (locked   ),
        .gate           (gate_n1  ),
        .freq_word      (fre1 * 1000),
        .amplitude      (max1),  // 峰值（正数）
  

        .wave_in        (data_match2),
        .wave_type      (choose2)
    );
    wire [10:0] duty;
    duty_top u_duty_top(
        .clk                (sys_clk),
        .rst_n              (gate_n2),

        .wave_in            (data_match),
        .amplitude          (max2),
        .duty               (duty)
    );

    wire [7:0] cz_data;
    
    assign filt_in1 = sin_addata2 - 'd128;//ad_data - 'd128;
    assign filt_in2 = ad_data - 'd128;
    filter u_filter(
        .clk                (ad_clk),
        .clk_enable         (1'b1),
        .reset              (!locked),
        .filter_in          (filt_in1),
        .filter_out         (filter_out1)
    );
    fi ufi(
        .clk            (ad_clk),
        .clk_enable     (1'b1),
        .reset          (!locked),
        .filter_in      (filt_in2),
        .filter_out     (filter_out2)
    );
    /*
    filter u_filter2(
        .clk                (ad_clk1),
        .clk_enable         (1'b1),
        .reset              (!locked),
        .filter_in          (filt_in2),
        .filter_out         (filter_out2)
    );
/********************************例化************************************/
//fft
wire [7:0] f_dt;
assign f_dt = (td2 == 1) ? ad_data2[11:4] : ad_data[11:4]; 
    assign fft_data_in = {7'b0,f_dt};
wire [15:0] div_out;
    fft_top #(
        .DATAIN_WIDTH    (DATAIN_WIDTH     ),                           
        .DATAOUT_WIDTH   (DATAOUT_WIDTH    ),                           
        .USER_WIDTH      (USER_WIDTH       )                        
        )
        u_fft_top1
        (
        .clk                            (sys_clk                      ),   
        .rst_n                          (locked                        ),    
        .wd_en                          (1'b1                         ),   //fft ip写使能
        .wd_data                        (fft_data_in                     ),   //写信号数据
        .rd_en                          (rd_en1                       ),   //读使能
        .data_input_start_flag          (data_input_start_flag1       ),   //fft_modulus_fifo存储数据需求标志
        .fft_amplitude_frequency_data   (fft_amplitude_frequency_data1) ,   //输出幅频数据
        .index                         (index),
        .sqrt_busy                       (sqrt_busy),
        .thd_q16_16                      (thd_q16_16),
        .thd_valid                       (thd_valid),
        .fre                            (fre2),
        .h1                              (h1    ),
        .h2                              (h2    ),
        .h3                              (h3    ),
        .h4                              (h4    ),
        .h5                              (h5    ),
        .index1                           (index1),
        .div_out        (div_out),
        .sqrt_out       (sqrt_out)
   );

    

    fft_hdmi_rw_fifo_ctrl u_fft_hdmi_rw_fifo_ctrl1(
        .wd_clk                (sys_clk                      ),
        .hdmi_clk              (pix_clk                      ),
        .rst_n                 (locked                        ),                         
        .fft_data              (fft_amplitude_frequency_data1),        //FFT频谱数据
        .fft_valid             (rd_en1                       ),        //FFT频谱数据有效信号
        .data_input_start_flag (data_input_start_flag1       ),        //FFT取模fifo使能信号
                            
        .data_req              (data_req1      ),   //数据请求信号
        .fft_point_done        (fft_point_done1),   //FFT当前频谱绘制完成
        .fft_point_cnt         (fft_point_cnt1 ),   //FFT频谱位置
                            
        .fifo_rd_empty         (fifo_rd_empty1  ),   //FIFO读空信号
        .fifo_wr_cnt           (fifo_wr_cnt1    ),   //FIFO当前缓存的数据量
        .fifo_rd_req           (fifo_rd_req1    ),   //FIFO读请求信号
        .fifo_pre_rd_req       (fifo_pre_rd_req1),   //FIFO预读请求信号
        .fifo_wr_data          (fifo_wr_data1   ),   //FIFO写数据
        .fifo_wr_req           (fifo_wr_req1    )    //FIFO写请求信号
   );


    fft_hdmi_fifo u_fft_hdmi_fifo1 (
        .wr_clk        (sys_clk       ),                        // input
        .wr_rst        (~locked        ),                        // input
        .wr_en         (fifo_wr_req1  ),                        // input
        .wr_data       (fifo_wr_data1 ),                        // input [15:0]
        
        .wr_water_level(fifo_wr_cnt1  ),                        // output [10:0]
        .almost_full   (              ),                        // output
        .rd_clk        (pix_clk       ),                        // input
        .rd_rst        (~locked        ),                        // input
        .rd_en         (fifo_rd_req1  || fifo_pre_rd_req1 ),    // input
        .rd_data       (fifo_rd_data1 ),                        // output [15:0]
        .empty      (fifo_rd_empty1),                        // output
        .rd_water_level(              ),                        // output [10:0]
        .almost_empty  (              )                         // output
    );


    sync_vg #(
        .X_BITS               (  X_WIDTH              ), 
        .Y_BITS               (  Y_WIDTH              ),
        .V_TOTAL              (  V_TOTAL              ),//                        
        .V_FP                 (  V_FP                 ),//                        
        .V_BP                 (  V_BP                 ),//                        
        .V_SYNC               (  V_SYNC               ),//                        
        .V_ACT                (  V_ACT                ),//                        
        .H_TOTAL              (  H_TOTAL              ),//                        
        .H_FP                 (  H_FP                 ),//                        
        .H_BP                 (  H_BP                 ),//                        
        .H_SYNC               (  H_SYNC               ),//                        
        .H_ACT                (  H_ACT                ) //                        
 
    ) sync_vg                                         
    (                                                 
        .clk                  (  pix_clk               ),//input                   clk,                                 
        .rstn                 (  rstn_out                 ),//input                   rstn,                            
        .vs_out               (  vs                   ),//output reg              vs_out,                                                                                                                                      
        .hs_out               (  hs                   ),//output reg              hs_out,            
        .de_out               (  de                   ),//output reg              de_out,       
        .x_act                (  act_x                ),//output reg [X_BITS-1:0] x_out,             
        .y_act                (  act_y                ) //output reg [Y_BITS:0]   y_out,             
    );
    
    pattern_vg #(
        .COCLOR_DEPP          (  8                    ), // Bits per channel
        .X_BITS               (  X_WIDTH              ),
        .Y_BITS               (  Y_WIDTH              ),
        .H_ACT                (  H_ACT                ),
        .V_ACT                (  V_ACT                )
    ) // Number of fractional bits for ramp pattern
    pattern_vg (
        .rstn                 (  rstn_out                 ),//input                         rstn,                                                     
        .pix_clk              (  pix_clk               ),//input                         clk_in,  
        .act_x                (  act_x                ),//input      [X_BITS-1:0]       x,   
        .act_y                (  act_y                ),
        // input video timing
        .vs_in                (  vs                   ),//input                         vn_in                        
        .hs_in                (  hs                   ),//input                         hn_in,                           
        .de_in                (  de                   ),//input                         dn_in,
        // test pattern image output                                                    
        .vs_out               (  vs_out_bg               ),//output reg                    vn_out,                       
        .hs_out               (  hs_out_bg               ),//output reg                    hn_out,                       
        .de_out               (  de_out_bg              ),//output reg                    den_out,                      
        .rgb_data             (rgb_data_pa                )
    );

    char_display  #(
        .H_ACT                (  H_ACT                ),
        .V_ACT                (  V_ACT                )
    )
    char_display_1(
        .rst_n         (locked        ) ,                                      
        .pclk          (pix_clk      ) ,                         
        .wave_color    (16'h0000) ,// wave color FFD700                                                         
        .i_hs          (hs_out_bg  ) ,                        
        .i_vs          (vs_out_bg  ) ,                        
        .i_de          (de_out_bg  ) ,    
        .fre1          (fre1          ) ,                                                     
        .fre2          (fre2          ) ,   
        .choose1        (choose1        ),  
        .choose2        (choose2        ),  
        .phase        (phase1        ),                                                  
        .i_data        (rgb_data_pa ) ,                          
        .o_hs          (hs_out_c        ) ,                        
        .o_vs          (vs_out_c        ) ,                        
        .o_de          (de_out_c        ) ,                        
        .o_data        (rgb_data_c       )                          
    );
wire [15:0] rgb_data_c;
    data_display  #(
        .H_ACT                (  H_ACT                ),
        .V_ACT                (  V_ACT                ),
        .place_x              (  0                    )
    )
    data_display_1(
        .rst_n         (locked        ) ,                                      
        .pclk          (pix_clk      ) ,
        .sys_clk       (sys_clk      ) ,
        .wave_color    (15'h0000) ,// wave color                              ) ,// wave color FFD700    
        .max          (   max1       ),      
        .min          (   phase1  - 'd18       ),
        .fre          (   fre1         ),     
        .v            (   v1          ),                                                     
        .i_hs          (hs_out_c  ) ,                        
        .i_vs          (vs_out_c  ) ,                        
        .i_de          (de_out_c  ) ,                        
        .i_data        (rgb_data_c ) ,                          
        .o_hs          (hs_out_d1        ) ,                        
        .o_vs          (vs_out_d1        ) ,                        
        .o_de          (de_out_d1        ) ,                        
        .o_data        (rgb_out_d1       )                          
    );
wire [15:0] rgb_test;
wire [15:0] rgb_data_d2;
    data_display  #(
        .H_ACT                (  H_ACT                ),
        .V_ACT                (  V_ACT                ),
        .place_x              (  12'd820              )
    )
    data_display_2(
        .rst_n         (locked        ) ,                                      
        .pclk          (pix_clk      ) ,
        .sys_clk       (sys_clk      ) ,
        .wave_color    (24'hffd700) ,// wave color FFD700    
        .max          (   duty       ),      
        .min          (   div_out         ),
        .fre          (   fre2         ),
        .v            (   v2          ),                                                     
        .i_hs          (hs_out_d1  ) ,                        
        .i_vs          (vs_out_d1  ) ,                        
        .i_de          (de_out_d1  ) ,                        
        .i_data        (rgb_out_d1 ) ,                          
        .o_hs          (hs_out_d2        ) ,                        
        .o_vs          (vs_out_d2        ) ,                        
        .o_de          (de_out_d2        ) ,                        
        .o_data        (rgb_data_d2       )                          
    );
    wire [7:0] sin_addata2;
    sincer_top u(
    .clk                    (sys_clk),
    .rst_n                  (locked),
    .wr_en                  (inu3_clk),   
    .rd_en                  (1'b1),
    .ori_data               (ad_data2),
    .sin_data               (sin_addata2),
    .p_wr_full              (),
    .p_almost_full          (),
    .n_rd_empty             (),
    .n_almost_empty         ()
);

    assign cz_data = (cz == 1'b1) ? wave_data_dis1 : ad_data2[11:4];
    wav_display1  #(
        .H_ACT                (  H_ACT                ),
        .V_ACT                (  V_ACT                )
    )
     u_wav_display_1(
        .rst_n         (locked        ) ,                                      
        .pclk          (pix_clk      ) ,                         
        .wave_color    (wav1_color) ,// wave color                              
        .clk           (ad_clk    ) ,                           
        .data          (ad_data[11:4]) ,     
        .amp_h         (amp_h1) ,   
        .d_clk         (d_clk), 
        .p_x           (p_x11), 
        .stop          (stop1) ,                                     
        .i_hs          (hs_out_d2   ),                        
        .i_vs          (vs_out_d2   ),                        
        .i_de          (de_out_d2   ),                        
        .i_data        (rgb_data_d2 ),                          
        .o_hs          (hs_out_w_1        ) ,                        
        .o_vs          (vs_out_w_1        ) ,                        
        .o_de          (de_out_w_1        ) ,                        
        .o_data        (rgb_out_w_1       )                          
    );

    assign wave_data_dis1 = filter_out1 + 'd128;
    assign wave_data_dis2 = filter_out2 + 'd128;
    wire [7:0] display_data;
    assign display_data = (fre2 > 'd400) ? ad_data : wave_data_dis1;
    wav_display1  #(
        .H_ACT                (  H_ACT                ),
        .V_ACT                (  V_ACT                )
    )
     u_wav_display_2(
        .rst_n         (locked        ) ,                                      
        .pclk          (pix_clk      ) ,                         
        .wave_color    (wav2_color) ,// wave color                              
        .clk           (inu3_clk     ) ,                           
        .data          (cz_data) ,
        .d_clk         (d_clk),       
        .amp_h         (amp_h2) ,          
        .p_x           (p_x21) ,      
        .stop          (stop2) ,                                     
        .i_hs          (hs_out_w_1   ) ,                        
        .i_vs          (vs_out_w_1   ) ,                        
        .i_de          (de_out_w_1   ) ,                        
        .i_data        (rgb_out_w_1 ) ,                          
        .o_hs          (hs_out_w        ) ,                        
        .o_vs          (vs_out_w        ) ,                        
        .o_de          (de_out_w        ) ,                        
        .o_data        (rgb_data_sbq       )                          
    );

    
wire [15:0] rgb_data_main;
wire vs_out_main, hs_out_main, de_out_main;
wire vs_out_xh, hs_out_xh, de_out_xh;
wire [15:0] rgb_data_xh;
wire [15:0] rgb_data_sbq;
wire vs_out_lj, hs_out_lj, de_out_lj;
wire [15:0] rgb_data_lj;

    main_backg # (
        .COCLOR_DEPP(  8                    ), // number of bits per channel
        .X_BITS    (  X_WIDTH              ),  
        .Y_BITS    (  Y_WIDTH              ),  
        .H_ACT     (  H_ACT                ),
        .V_ACT      (  V_ACT                )  
    )
    u_m(                                       
        .rstn                               (locked), 
        .pix_clk                            (pix_clk),
        .act_x                              (act_x),
        .act_y                              (act_y),
        .vs_in                              (vs), 
        .hs_in                              (hs), 
        .de_in                              (de),
        .vs_out                             (vs_out_main), 
        .hs_out                             (hs_out_main), 
        .de_out                             (de_out_main),
        .rgb_data                           (rgb_data_main)
    );

    xh_bg # (
        .COCLOR_DEPP(  8                    ), // number of bits per channel
        .X_BITS    (  X_WIDTH              ),  
        .Y_BITS    (  Y_WIDTH              ),  
        .H_ACT     (  H_ACT                ),
        .V_ACT      (  V_ACT                )  
    )
    u_bg(                                       
        .rstn                               (locked), 
        .pix_clk                            (pix_clk),
        .act_x                              (act_x),
        .act_y                              (act_y),
        .vs_in                              (vs), 
        .hs_in                              (hs), 
        .de_in                              (de),
        .targe_vpp                       (targe_wr_vpp),
        .vs_out                             (vs_out_xh), 
        .hs_out                             (hs_out_xh), 
        .de_out                             (de_out_xh),
        .rgb_data                           (rgb_data_xh)
    );

    lj_bg # (
        .COCLOR_DEPP(  8                    ), // number of bits per channel
        .X_BITS    (  X_WIDTH              ),  
        .Y_BITS    (  Y_WIDTH              ),  
        .H_ACT     (  H_ACT                ),
        .V_ACT      (  V_ACT                )  
    )
    u_lj(                                       
        .rstn                               (locked), 
        .pix_clk                            (pix_clk),
        .clk                                (sys_clk),
        .act_x                              (act_x),
        .act_y                              (act_y),
        .targe_fre                           (targe_fre),
        .targe_vpp                           (targe_vpp),
        .vs_in                              (vs), 
        .hs_in                              (hs), 
        .de_in                              (de),
        .vs_out                             (vs_out_lj), 
        .hs_out                             (hs_out_lj), 
        .de_out                             (de_out_lj),
        .rgb_data                           (rgb_data_lj)
    );
    assign rgb_data = (Interface_control == 3'b1)? rgb_data_xh   : 
                      (Interface_control == 3'd2)? rgb_data_sbq  :
                      (Interface_control == 3'd3)? rgb_data_lj :
                      (Interface_control == 3'd4)? rgb_out_f :
                      (Interface_control == 3'd0)? rgb_data_main :
                                                   rgb_data_main ;
    assign {vs_out, hs_out, de_out} = (Interface_control == 3'b1) ? {vs_out_xh, hs_out_xh, de_out_xh}       : 
                                      (Interface_control == 3'd2) ? {vs_out_w, hs_out_w, de_out_w}       :
                                      (Interface_control == 3'd3) ? {vs_out_lj, hs_out_lj, de_out_lj}       :
                                      (Interface_control == 3'd4)? {vs_out_fft, hs_out_fft, de_out_fft} :
                                                                {vs_out_main, hs_out_main, de_out_main}  ;

    

    
    fft_display  #(
        .COCLOR_DEPP          (  8                    ), // Bits per channel
        .X_BITS               (  X_WIDTH              ),
        .Y_BITS               (  Y_WIDTH              ),
        .H_ACT                (  H_ACT                ),
        .V_ACT                (  V_ACT                )
    ) // Number of fractional bits for ramp pattern
    fft_display (
        .rstn                 (  rstn_out             ),//input                         rstn,                                                     
        .pix_clk              (  pix_clk              ),//input                         clk_in,  
        .act_x                (  act_x                ),//input      [X_BITS-1:0]       x,   
        .act_y                (  act_y                ),
        // input video timing
        .vs_in                (  vs                   ),//input                         vn_in                        
        .hs_in                (  hs                   ),//input                         hn_in,                           
        .de_in                (  de                   ),//input                         dn_in,
        // test pattern image output                                                    
        .vs_out               (  vs_out_fft               ),//output reg                    vn_out,                       
        .hs_out               (  hs_out_fft               ),//output reg                    hn_out,                       
        .de_out               (  de_out_fft              ),//output reg                    den_out,                      
        .rgb_data             (rgb_out_f                ),
        .fifo_rd_empty1       (  fifo_rd_empty1             ), 
        .fft_point_cnt1       (  fft_point_cnt1             ),
        .fifo_rd_req1         (  fifo_rd_req1               ),
        .fft_data1            (  fifo_rd_data1              ),
        .fft_point_done1      (  fft_point_done1            ),
        .data_req1            (  data_req1                  )                   
    );


endmodule