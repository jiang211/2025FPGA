module fft_axi_master #(
    parameter integer DATAIN_WIDTH    = 16   ,                           
    parameter integer DATAOUT_WIDTH   = 32   ,                           
    parameter integer USER_WIDTH      = 16                           
)
(
    input                          clk                ,
    input                          rst_n              , 
    // 外部数据接口                                        
    input                          wd_en              ,   //写使能
    output                         rd_en              ,   //读使能
    input   [DATAIN_WIDTH-1:0]     wd_data            ,   //写信号数据
    output  [DATAOUT_WIDTH-1:0]    out_fft_data_re    ,   //输出fft数据（实部）
    output  [DATAOUT_WIDTH-1:0]    out_fft_data_im    ,   //输出fft数据（虚部）
    output                         fft_sop            ,   //SOP包开始信号
    output                         fft_eop            ,   //SOP包结束信号                                            

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

/******************************参数*****************************************/


/*****************************网表型***************************************/
wire [10:0]               wr_water_level         ;
wire                      fifo_wr_req            ;
wire [DATAIN_WIDTH-1:0]   fifo_wr_data           ;
wire                      fifo_rd_req            ;
wire [DATAIN_WIDTH-1:0]   fifo_rd_data           ;
wire                      fifo_rd_empty          ;

/****************************寄存器****************************************/
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

/***************************组合逻辑***************************************/
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

/****************************进程*****************************************/
//对wd_en输入数据有效信号打拍
always @(posedge clk or negedge rst_n) begin
    if(!rst_n ) begin
        r_wd_en <= 1'b0; 
    end
    else begin   //写使能                
        r_wd_en <= wd_en;
    end
end

//对wd_data输入数据打拍
always @(posedge clk or negedge rst_n) begin
    if(!rst_n ) begin
        r_wd_data <= 16'd0; 
    end
    else begin                   
        r_wd_data <= wd_data;
    end
end

//控制fifo何时补充数据
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

//控制r_fifo_rd_flag信号，即控制fifo读使能（fifo存够一帧256个数据且写ready信号为高、写last信号为低（表示并非上一次读出一帧操作的结尾）时开启连续读出fifo一帧操作）
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

//控制r_fifo_rd_cnt计数器，即控制r_fifo_rd_flag有效时长
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

//控制写数据有效信号
always @(posedge clk or negedge rst_n) begin
    if(!rst_n ) begin
        r_i_axi4s_data_tvalid <= 1'b0; 
    end
    else begin     //写使能   
        r_i_axi4s_data_tvalid <= fifo_rd_req;
    end
end

//控制写数据（i_axi4s_data_tdata）
always @(posedge clk or negedge rst_n) begin
    if(!rst_n ) begin
        r_i_axi4s_data_tdata <= 32'd0; 
    end
    else begin                
        r_i_axi4s_data_tdata[DATAIN_WIDTH-1:0] <= fifo_rd_data;
        r_i_axi4s_data_tdata[DATAIN_WIDTH*2-1:DATAIN_WIDTH] <= 16'd0; 
    end
end

//控制i_axi4s_data_tlast信号
always @(posedge clk or negedge rst_n) begin
    if(!rst_n ) begin
        r_i_axi4s_data_tlast <= 1'b0; 
    end
    else if(r_tdata_count==8'd254) begin //计数到254置1
        r_i_axi4s_data_tlast <= 1'b1;
    end
    else if(r_tdata_count==8'd255) begin //计数到255复位
        r_i_axi4s_data_tlast <= 1'b0;
    end
    else begin
        r_i_axi4s_data_tlast <= r_i_axi4s_data_tlast;
    end
end

//控制写数据有效计数器
always @(posedge clk or negedge rst_n) begin
    if(!rst_n ) begin
        r_tdata_count <= 8'd0;
    end
    else if(o_axi4s_data_tready && i_axi4s_data_tvalid) begin
        r_tdata_count <= r_tdata_count + 1'b1;
    end
    else if(i_axi4s_data_tlast==1'b1) begin //tlast为高时复位
        r_tdata_count <= 8'd0;
    end
    else begin
        r_tdata_count <= 8'd0;
    end
end

//控制读数据信号（o_axi4s_data_tdata）
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

//控制数据帧帧头标志信号
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

//控制数据帧帧头结束信号
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

//预读取FIFO，清除fifo输出接口上一次数据
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin  //复位
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

/****************************例化****************************************/
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




/****************************状态机**************************************/





endmodule