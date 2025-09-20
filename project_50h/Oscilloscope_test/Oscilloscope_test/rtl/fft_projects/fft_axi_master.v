module fft_axi_master #(
    parameter integer DATAIN_WIDTH    = 16   ,                           
    parameter integer DATAOUT_WIDTH   = 32   ,                           
    parameter integer USER_WIDTH      = 16                           
)
(
    input                          clk                ,
    input                          rst_n              , 
    // �ⲿ���ݽӿ�                                        
    input                          wd_en              ,   //дʹ��
    output                         rd_en              ,   //��ʹ��
    input   [DATAIN_WIDTH-1:0]     wd_data            ,   //д�ź�����
    output  [DATAOUT_WIDTH-1:0]    out_fft_data_re    ,   //���fft���ݣ�ʵ����
    output  [DATAOUT_WIDTH-1:0]    out_fft_data_im    ,   //���fft���ݣ��鲿��
    output                         fft_sop            ,   //SOP����ʼ�ź�
    output                         fft_eop            ,   //SOP�������ź�                                            

    output                         i_axi4s_data_tvalid,
    output  [DATAIN_WIDTH*2-1:0]   i_axi4s_data_tdata ,
    output                         i_axi4s_data_tlast ,
    input                          o_axi4s_data_tready,
    output                         i_axi4s_cfg_tvalid ,
    output                         i_axi4s_cfg_tdata  ,

    input                          o_axi4s_data_tvalid,
    input   [DATAOUT_WIDTH*2-1:0]  o_axi4s_data_tdata ,
    input                          o_axi4s_data_tlast ,
    input   [USER_WIDTH-1:0]       o_axi4s_data_tuser ,
    input   [2:0]                  o_alm              ,
    input                          o_stat             

   );

/******************************����*****************************************/


/*****************************������***************************************/
wire [10:0]               wr_water_level         ;
wire                      fifo_wr_req            ;
wire [DATAIN_WIDTH-1:0]   fifo_wr_data           ;
wire                      fifo_rd_req            ;
wire [DATAIN_WIDTH-1:0]   fifo_rd_data           ;
wire                      fifo_rd_empty          ;

/****************************�Ĵ���****************************************/
reg                       r_wd_en                ;
reg  [DATAIN_WIDTH-1:0]   r_wd_data              ;
reg                       r_fifo_wd_flag         ;
reg                       r_fifo_rd_flag         ;
reg  [7:0]                r_fifo_rd_cnt          ;
reg                       fifo_pre_rd_req        ;
reg                       fifo_pre_rd_flag       ; 

reg                       r_i_axi4s_data_tvalid  ; 
reg  [DATAIN_WIDTH*2-1:0] r_i_axi4s_data_tdata   ;   
reg  [7:0]                r_tdata_count          ; 
reg                       r_i_axi4s_data_tlast   ;

reg  [DATAOUT_WIDTH:0]    r_o_axi4s_data_tdata_re;
reg  [DATAOUT_WIDTH:0]    r_o_axi4s_data_tdata_im;
reg                       r_rd_en;

reg                       r_o_axi4s_data_tvalid_d0;
reg                       r_o_axi4s_data_tvalid_d1;
reg                       r_o_axi4s_data_tlast_d0 ;
reg                       r_o_axi4s_data_tlast_d1 ;

/***************************����߼�***************************************/
assign fifo_wr_req  = r_wd_en && r_fifo_wd_flag;
assign fifo_wr_data = r_wd_data;   
assign fifo_rd_req  = r_fifo_rd_flag;

assign i_axi4s_data_tdata  = r_i_axi4s_data_tdata;   
assign i_axi4s_data_tvalid = r_i_axi4s_data_tvalid;             
assign i_axi4s_data_tlast  = r_i_axi4s_data_tlast;

assign i_axi4s_cfg_tvalid = 1'b1;
assign i_axi4s_cfg_tdata  = 1'b1;

assign out_fft_data_re = r_o_axi4s_data_tdata_re;
assign out_fft_data_im = r_o_axi4s_data_tdata_im;
assign rd_en = r_rd_en;

assign fft_sop = (r_o_axi4s_data_tvalid_d0 && !r_o_axi4s_data_tvalid_d1) ? 1'b1 : 1'b0;
assign fft_eop = (r_o_axi4s_data_tlast_d0 && !r_o_axi4s_data_tlast_d1) ? 1'b1 : 1'b0;

/****************************����*****************************************/
//��wd_en����������Ч�źŴ���
always @(posedge clk or negedge rst_n) begin
    if(!rst_n ) begin
        r_wd_en <= 1'b0; 
    end
    else begin   //дʹ��                
        r_wd_en <= wd_en;
    end
end

//��wd_data�������ݴ���
always @(posedge clk or negedge rst_n) begin
    if(!rst_n ) begin
        r_wd_data <= 16'd0; 
    end
    else begin                   
        r_wd_data <= wd_data;
    end
end

//����fifo��ʱ��������
always @(posedge clk or negedge rst_n) begin
    if(!rst_n ) begin
        r_fifo_wd_flag <= 1'b0; 
    end
    else if(wr_water_level >= 11'd512) begin                   
        r_fifo_wd_flag <= 1'b0;
    end
    else begin
        r_fifo_wd_flag <= 1'b1;
    end
end

//����r_fifo_rd_flag�źţ�������fifo��ʹ�ܣ�fifo�湻һ֡256��������дready�ź�Ϊ�ߡ�дlast�ź�Ϊ�ͣ���ʾ������һ�ζ���һ֡�����Ľ�β��ʱ������������fifoһ֡������
always @(posedge clk or negedge rst_n) begin
    if(!rst_n ) begin
        r_fifo_rd_flag <= 1'b0; 
    end
    else if((wr_water_level > 11'd256) && o_axi4s_data_tready && (r_fifo_rd_flag == 1'b0) && !i_axi4s_data_tlast) begin                   
        r_fifo_rd_flag <= 1'b1;
    end
    else if(r_fifo_rd_cnt == 8'd255)begin
        r_fifo_rd_flag <= 1'b0; 
    end
    else begin
        r_fifo_rd_flag <= r_fifo_rd_flag; 
    end
end

//����r_fifo_rd_cnt��������������r_fifo_rd_flag��Чʱ��
always @(posedge clk or negedge rst_n) begin
    if(!rst_n ) begin
        r_fifo_rd_cnt <= 8'd0; 
    end
    else if(r_fifo_rd_flag && r_fifo_rd_cnt < 8'd255) begin                   
        r_fifo_rd_cnt <= r_fifo_rd_cnt + 1'b1;
    end
    else if(r_fifo_rd_cnt == 8'd255)begin
        r_fifo_rd_cnt <= 8'd0; 
    end
end

//����д������Ч�ź�
always @(posedge clk or negedge rst_n) begin
    if(!rst_n ) begin
        r_i_axi4s_data_tvalid <= 1'b0; 
    end
    else begin     //дʹ��   
        r_i_axi4s_data_tvalid <= fifo_rd_req;
    end
end

//����д���ݣ�i_axi4s_data_tdata��
always @(posedge clk or negedge rst_n) begin
    if(!rst_n ) begin
        r_i_axi4s_data_tdata <= 32'd0; 
    end
    else begin                
        r_i_axi4s_data_tdata[DATAIN_WIDTH-1:0] <= fifo_rd_data;
        r_i_axi4s_data_tdata[DATAIN_WIDTH*2-1:DATAIN_WIDTH] <= 16'd0; 
    end
end

//����i_axi4s_data_tlast�ź�
always @(posedge clk or negedge rst_n) begin
    if(!rst_n ) begin
        r_i_axi4s_data_tlast <= 1'b0; 
    end
    else if(r_tdata_count==8'd254) begin //������254��1
        r_i_axi4s_data_tlast <= 1'b1;
    end
    else if(r_tdata_count==8'd255) begin //������255��λ
        r_i_axi4s_data_tlast <= 1'b0;
    end
    else begin
        r_i_axi4s_data_tlast <= r_i_axi4s_data_tlast;
    end
end

//����д������Ч������
always @(posedge clk or negedge rst_n) begin
    if(!rst_n ) begin
        r_tdata_count <= 8'd0;
    end
    else if(o_axi4s_data_tready && i_axi4s_data_tvalid) begin
        r_tdata_count <= r_tdata_count + 1'b1;
    end
    else if(i_axi4s_data_tlast==1'b1) begin //tlastΪ��ʱ��λ
        r_tdata_count <= 8'd0;
    end
    else begin
        r_tdata_count <= 8'd0;
    end
end

//���ƶ������źţ�o_axi4s_data_tdata��
always @(posedge clk or negedge rst_n) begin
    if(!rst_n ) begin
        r_o_axi4s_data_tdata_re <= 8'd0;
        r_o_axi4s_data_tdata_im <= 8'd0;
        r_rd_en <= 1'b0;
    end
    else if(o_axi4s_data_tvalid) begin
        r_o_axi4s_data_tdata_re <= o_axi4s_data_tdata[DATAOUT_WIDTH-1:0];
        r_o_axi4s_data_tdata_im <= o_axi4s_data_tdata[DATAOUT_WIDTH*2-1:DATAOUT_WIDTH];
        r_rd_en <= 1'b1;
    end
    else begin
        r_o_axi4s_data_tdata_re <= 8'd0;
        r_o_axi4s_data_tdata_im <= 8'd0;
        r_rd_en <= 1'b0;

    end
end

//��������֡֡ͷ��־�ź�
always @(posedge clk or negedge rst_n) begin
    if(!rst_n ) begin
        r_o_axi4s_data_tvalid_d0 <= 1'b0;
        r_o_axi4s_data_tvalid_d1 <= 1'b0;
    end
    else begin
        r_o_axi4s_data_tvalid_d0 <= o_axi4s_data_tvalid;
        r_o_axi4s_data_tvalid_d1 <= r_o_axi4s_data_tvalid_d0;
    end
end

//��������֡֡ͷ�����ź�
always @(posedge clk or negedge rst_n) begin
    if(!rst_n ) begin
        r_o_axi4s_data_tlast_d0 <= 1'b0;
        r_o_axi4s_data_tlast_d1 <= 1'b0;
    end
    else begin
        r_o_axi4s_data_tlast_d0 <= o_axi4s_data_tlast;
        r_o_axi4s_data_tlast_d1 <= r_o_axi4s_data_tlast_d0;
    end
end

//Ԥ��ȡFIFO�����fifo����ӿ���һ������
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin  //��λ
        fifo_pre_rd_req <= 'd0;
        fifo_pre_rd_flag <= 'd0;
    end
    else if((!fifo_rd_empty) && (fifo_pre_rd_flag == 'd0)) begin
        fifo_pre_rd_req <= 'd1;
        fifo_pre_rd_flag <= 'd1;
    end
    else begin
        fifo_pre_rd_req <= 'd0;
    end
end

/****************************����****************************************/
fft_axi_fifo u_fft_axi_fifo (
  .clk              (clk             ),    // input
  .rst              (~rst_n          ),    // input
  .wr_en            (fifo_wr_req     ),    // input
  .wr_data          (fifo_wr_data    ),    // input [15:0]
  .wr_full          (                ),    // output
  .wr_water_level   (wr_water_level  ),    // output [10:0]
  .almost_full      (                ),    // output
  .rd_en            (fifo_rd_req || fifo_pre_rd_req ),    // input
  .rd_data          (fifo_rd_data    ),    // output [15:0]
  .rd_empty         (fifo_rd_empty   ),    // output
  .rd_water_level   (                ),    // output [10:0]
  .almost_empty     (                )     // output
);




/****************************״̬��**************************************/





endmodule