module fft_data_modulus(
    input             clk,
    input             rst_n,
    //FFT ST接口
    input   [31:0]    source_real,
    input   [31:0]    source_imag,
    input             source_sop,
    input             source_eop,
    input             source_valid,
    //取模运算后的数据接口
    output  [31:0]    data_modulus, 
    output            data_modulus_valid,
    output  [9:0]     data_index,
    output            sqrt_busy,
    //用户接口
    input             data_input_start_flag
   );

/********************************参数*************************************/
//parameter define
parameter TRANSFORM_LEN = 1024;        //FFT采样点数:1024

/*******************************寄存器************************************/
reg  [63:0] source_data;
reg  [63:0] wr_fifo_data;
reg  [31:0] data_real;
reg  [31:0] data_imag;

reg         data_valid;
reg         data_valid1;
reg         data_sop1;
reg         data_eop1;
reg         data_sop;
reg         data_eop;

reg         r_sqrt_busy_d0;
reg         r_sqrt_busy_d1;

reg  [1:0]  wr_state;
reg  [11:0]  wr_cnt;
reg         wr_en;

reg         fifo_rd_req;
reg         fifo_wr_req;
reg         fifo_pre_rd_req;
reg         fifo_pre_rd_flag;

/*******************************网表型************************************/
wire [62:0] data_modulus_rem;
wire        sqrt_busy;

wire [63:0] rd_fifo_data;
wire [9:0]  wr_water_level;
wire [9:0]  fifo_wr_cnt;
wire        fifo_rd_empty;
        
wire [9:0]  data_cnt;
/******************************组合逻辑***********************************/
assign data_modulus_valid = (!r_sqrt_busy_d0 && r_sqrt_busy_d1) ? 1'b1 : 1'b0;

/********************************进程************************************/
//取实部和虚部的平方和
always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        source_data <= 64'd0;
        data_real   <= 32'd0;
        data_imag   <= 32'd0;
    end
    else begin
        if(source_real[31]==1'b0)               //由补码计算原码
            data_real <= source_real[31:0];
        else
            data_real <= ~source_real[31:0] + 1'b1;
            
        if(source_imag[31]==1'b0)               //由补码计算原码
            data_imag <= source_imag[31:0];
        else
            data_imag <= ~source_imag[31:0] + 1'b1;            
                                                //计算原码平方和
        source_data <= (data_real * data_real) + (data_imag * data_imag);
    end
end

//数据取模运算共花费了二个时钟周期，此处延时二个时钟周期
always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_valid  <= 1'b0;
        data_valid1 <= 1'b0;
        data_sop    <= 1'b0;
        data_sop1   <= 1'b0;
        data_eop    <= 1'b0;
        data_eop1   <= 1'b0;
    end
    else begin
        data_valid1 <= source_valid;
        data_valid  <= data_valid1;
        data_sop1   <= source_sop;
        data_sop    <= data_sop1;
        data_eop1   <= source_eop;
        data_eop    <= data_eop1;
    end
end

//对source_data打一拍
always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wr_fifo_data  <= 64'd0;
    end
    else begin
        wr_fifo_data  <= source_data;
    end
end

//检测sqrt_busy下降沿
always @(posedge clk or negedge rst_n) begin
    if(!rst_n ) begin
        r_sqrt_busy_d0 <= 1'b0;
        r_sqrt_busy_d1 <= 1'b0;
    end
    else begin
        r_sqrt_busy_d0 <= sqrt_busy;
        r_sqrt_busy_d1 <= r_sqrt_busy_d0;
    end
end

//产生FIFO写请求信号
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        fifo_wr_req <= 1'b0;
    end
    else if(wr_en && data_sop) begin  
        fifo_wr_req <= 1'b1;   
    end
    else if(fifo_wr_req && data_valid && wr_en) begin
        fifo_wr_req <= 1'b1;   
    end    
    else begin
        fifo_wr_req <= 1'b0;
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

//产生FIFO读请求信号
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        fifo_rd_req <= 1'b0;
    end
    else if((!fifo_rd_empty) && (!sqrt_busy) && (fifo_rd_req == 1'b0) &&(fifo_pre_rd_flag == 1'b1)) begin   //FIFO非空
        fifo_rd_req <= 1'b1;           
    end
    else begin
        fifo_rd_req <= 1'b0;           
    end    
end

/*******************************状态机************************************/
//控制FIFO写端口，每次向FIFO中写入前半帧（128个）数据
always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wr_state <= 2'd0;
        wr_en    <= 1'b0;
        wr_cnt   <= 8'd0;
    end
    else begin
        case(wr_state)
            2'd0: begin             //等待一帧数据的开始信号
                if(data_input_start_flag) begin   //进入写数据过程，拉高写使能wr_en
                    wr_state <= 2'd1; 
                    wr_en    <= 1'b1;
                end
                else begin          
                    wr_state <= 2'd0;
                    wr_en    <= 1'b0;
                end
            end
            2'd1: begin             
                if(fifo_wr_req)     //对写入FIFO中的数据计数
                    wr_cnt   <= wr_cnt + 1'b1;
                else
                    wr_cnt   <= wr_cnt;
                                    //由于FFT得到的数据具有对称性，因此只取一帧数据的一半
                if(wr_cnt < TRANSFORM_LEN/2 - 2'd2) begin
                    wr_en    <= 1'b1;
                    wr_state <= 2'd1;
                end
                else begin
                    wr_en    <= 1'b0;
                    wr_state <= 2'd2;
                end
            end
            2'd2: begin
                    wr_cnt   <= 8'd0;
                    wr_state <= 2'd0;
            end
            default: 
                    wr_state <= 2'd0;
        endcase
    end     
end


/********************************例化************************************/

sqrt #(
    .DW             (64              ) 		//输入数据位宽
)
u_sqrt
(
    .clk            (clk             ),		//时钟
    .rst_n          (rst_n           ),		//低电平复位，异步复位同步释放        
    .din_cnt        (data_cnt        ),   
    .din_i          (rd_fifo_data    ),		//开方数据输入
    .din_valid_i    (fifo_rd_req     ),		//数据输入有效                   
    .busy_o         (sqrt_busy       ),		//sqrt单元繁忙     
    .dout_cnt       (data_index      ),            
    .sqrt_o         (data_modulus    ),	    //开方结果输出
    .rem_o	        (data_modulus_rem)      //开方余数输出
);                  

fft_modulus_fifo u_fft_modulus_fifo (
  .clk                (clk            ),    // input
  .rst                (~rst_n         ),    // input
  .wr_en              (fifo_wr_req    ),    // input
  .wr_data            ({wr_cnt,wr_fifo_data}   ),    // input [63:0]
  .wr_full            (               ),    // output
  .wr_water_level     (wr_water_level ),    // output [8:0]
  .almost_full        (               ),    // output
  .rd_en              (fifo_rd_req || fifo_pre_rd_req ),    // input
  .rd_data            ({data_cnt,rd_fifo_data}   ),    // output [63:0]
  .rd_empty           (fifo_rd_empty  ),    // output
  .rd_water_level     (fifo_wr_cnt    ),    // output [8:0]
  .almost_empty       (               )     // output
);         
                   
 endmodule                   
                               