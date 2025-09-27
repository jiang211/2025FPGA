module fft_top #(
    parameter integer DATAIN_WIDTH    = 16   ,                           
    parameter integer DATAOUT_WIDTH   = 32   ,                           
    parameter integer USER_WIDTH      = 16                           
)
(
    input                      clk                            ,
    input                      rst_n                          ,
 
    // 外部数据接口      
    input                      data_input_start_flag          ,   //fft_modulus_fifo存储数据需求标志
    input                      wd_en                          ,   //fft ip写使能
    input  [DATAIN_WIDTH-1:0]  wd_data                        ,   //写信号数据
    output                     rd_en                          ,   //读使能
    output [DATAOUT_WIDTH-1:0] fft_amplitude_frequency_data   ,   //输出幅频数据
    output                     [10:0] index,
    output                        sqrt_busy,
    input              [10:0] fre,
    output    [31:0]         thd_q16_16,
    output                   thd_valid,
    output    [31:0]            h1,
    output    [31:0]            h2,
    output    [31:0]            h3,
    output    [31:0]            h4,
    output    [31:0]            h5,
    output    [10:0]            index1,
    output [15:0]           div_out,
    output [63:0]           sqrt_out

   );

wire                          xn_axi4s_data_tvalid         ;
wire   [DATAIN_WIDTH*2-1:0]   xn_axi4s_data_tdata          ;
wire                          xn_axi4s_data_tlast          ;
wire                          xn_axi4s_data_tready         ;
wire                          xn_axi4s_cfg_tvalid          ;
wire                          xn_axi4s_cfg_tdata           ;
wire                          xk_axi4s_data_tvalid         ;
wire   [DATAOUT_WIDTH*2-1:0]  xk_axi4s_data_tdata          ;
wire                          xk_axi4s_data_tlast          ;
wire   [USER_WIDTH-1:0]       xk_axi4s_data_tuser          ;
wire   [2:0]                  alm                          ;
wire                          stat                         ;
                                                           
wire  [DATAOUT_WIDTH-1:0]     out_fft_data_re              ;
wire  [DATAOUT_WIDTH-1:0]     out_fft_data_im              ;
wire                          source_valid                 ;

wire                          source_sop                   ;
wire                          source_eop                   ;


fft_axi_master #(
    .DATAIN_WIDTH        (DATAIN_WIDTH        ),                           
    .DATAOUT_WIDTH       (DATAOUT_WIDTH       ),                           
    .USER_WIDTH          (USER_WIDTH          )                        
)
u_fft_axi_master
(
    .clk                 (clk                 ),
    .rst_n               (rst_n               ),                      
    .wd_en               (wd_en               ),   //写使能
    .rd_en               (source_valid        ),   //读使能
    .wd_data             (wd_data             ),   //写信号数据   
    .out_fft_data_re     (out_fft_data_re     ),   //输出fft数据（实部）
    .out_fft_data_im     (out_fft_data_im     ),   //输出fft数据（虚部）
    .fft_sop             (source_sop          ),
    .fft_eop             (source_eop          ),

    .i_axi4s_data_tvalid (xn_axi4s_data_tvalid),
    .i_axi4s_data_tdata  (xn_axi4s_data_tdata ),
    .i_axi4s_data_tlast  (xn_axi4s_data_tlast ),
    .o_axi4s_data_tready (xn_axi4s_data_tready),
    .i_axi4s_cfg_tvalid  (xn_axi4s_cfg_tvalid ),
    .i_axi4s_cfg_tdata   (xn_axi4s_cfg_tdata  ),
                        
    .o_axi4s_data_tvalid (xk_axi4s_data_tvalid),
    .o_axi4s_data_tdata  (xk_axi4s_data_tdata ),
    .o_axi4s_data_tlast  (xk_axi4s_data_tlast ),
    .o_axi4s_data_tuser  (xk_axi4s_data_tuser ),
    .o_alm               (alm                 ),
    .o_stat              (stat                )

   );


fft_data_modulus u_fft_data_modulus(
    .clk                    (clk                          ),
    .rst_n                  (rst_n                        ),
    //FFT ST接口          
    .source_real            (out_fft_data_re              ),
    .source_imag            (out_fft_data_im              ),
    .source_sop             (source_sop                   ),
    .source_eop             (source_eop                   ),
    .source_valid           (source_valid                 ),
    //取模运算后的数据接口        
    .data_modulus           (fft_amplitude_frequency_data ),  
    .data_modulus_valid     (rd_en                        ),
    .data_index             (index                        ),
    .sqrt_busy              (sqrt_busy),
    //用户接口
    .data_input_start_flag  (data_input_start_flag        )
   );


fft_demo_00  u_fft_wrapper ( 
    .i_aclk                 (clk                 ),

    .i_axi4s_data_tvalid    (xn_axi4s_data_tvalid),
    .i_axi4s_data_tdata     (xn_axi4s_data_tdata ),
    .i_axi4s_data_tlast     (xn_axi4s_data_tlast ),
    .o_axi4s_data_tready    (xn_axi4s_data_tready),
    .i_axi4s_cfg_tvalid     (xn_axi4s_cfg_tvalid ),
    .i_axi4s_cfg_tdata      (xn_axi4s_cfg_tdata  ),
    .o_axi4s_data_tvalid    (xk_axi4s_data_tvalid),
    .o_axi4s_data_tdata     (xk_axi4s_data_tdata ),
    .o_axi4s_data_tlast     (xk_axi4s_data_tlast ),
    .o_axi4s_data_tuser     (xk_axi4s_data_tuser ),
    .o_alm                  (alm                 ),
    .o_stat                 (stat                )
);

 wire [63:0] h1,h2,h3,h4,h5;
   thd_data_fine u_thd_data_fine(
        .clk            (clk),
        .rst            (rst_n),
        .fre            (fre),
        .sqrt_busy      (sqrt_busy),
        .data_in        (fft_amplitude_frequency_data),
        .index          (index),
        .h1             (h1),
        .h2             (h2),
        .h3             (h3),
        .h4             (h4),
        .h5             (h5),
        .index1         (index1)
);
wire flag_start = (index == 'd500);
   thd_calculator u_thd_calculator(
        .clk            (clk),
        .rst_n          (rst_n),
        .mag_valid      (flag_start),
        .mag_index      (index),
        .h1             (h1),
        .h2             (h2),
        .h3             (h3),
        .h4             (h4),
        .h5             (h5),

        .thd_q16_16     (thd_q16_16),
        .thd_valid      (thd_valid),
        .div_out        (div_out),
        .sqrt_out       (sqrt_out)

    );

//////////////// index_count///////////////////
// reg [10:0] index;
// always @(posedge clk or negedge rst_n) begin
//     if (!rst_n)
//         index <= 0;
//     else if (xk_axi4s_data_tvalid)
//         index <= (index == {10{1'b1}}) ? 0 : index + 1'b1;
// end

// reg [31:0] max_val;
// reg [KW-1:0] max_idx;

// always @(posedge clk or negedge rst_n) begin
//     if (!rst_n) begin
//         max_val <= 0;
//         max_idx <= 0;
//         k1_o    <= 0;
//         k1_valid <= 0;
//     end else begin
//         k1_valid <= 0;
//         if (xk_axi4s_data_tvalid) begin
//             if (mag_data > max_val) begin
//                 max_val <= mag_data;
//                 max_idx <= mag_index;
//             end
//         end
//         if (frame_done) begin
//             k1_o     <= max_idx;
//             k1_valid <= 1;
//             max_val  <= 0;   // 清零，准备下一帧
//         end
//     end
// end

endmodule