module fft_data_modulus(
    input             clk,
    input             rst_n,
    //FFT ST�ӿ�
    input   [31:0]    source_real,
    input   [31:0]    source_imag,
    input             source_sop,
    input             source_eop,
    input             source_valid,
    //ȡģ���������ݽӿ�
    output  [31:0]    data_modulus, 
    output            data_modulus_valid,
    output  [9:0]     data_index,
    output            sqrt_busy,
    //�û��ӿ�
    input             data_input_start_flag
   );

/********************************����*************************************/
//parameter define
parameter TRANSFORM_LEN = 1024;        //FFT��������:1024

/*******************************�Ĵ���************************************/
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

/*******************************������************************************/
wire [62:0] data_modulus_rem;
wire        sqrt_busy;

wire [63:0] rd_fifo_data;
wire [9:0]  wr_water_level;
wire [9:0]  fifo_wr_cnt;
wire        fifo_rd_empty;
        
wire [9:0]  data_cnt;
/******************************����߼�***********************************/
assign data_modulus_valid = (!r_sqrt_busy_d0 && r_sqrt_busy_d1) ? 1'b1 : 1'b0;

/********************************����************************************/
//ȡʵ�����鲿��ƽ����
always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        source_data <= 64'd0;
        data_real   <= 32'd0;
        data_imag   <= 32'd0;
    end
    else begin
        if(source_real[31]==1'b0)               //�ɲ������ԭ��
            data_real <= source_real[31:0];
        else
            data_real <= ~source_real[31:0] + 1'b1;
            
        if(source_imag[31]==1'b0)               //�ɲ������ԭ��
            data_imag <= source_imag[31:0];
        else
            data_imag <= ~source_imag[31:0] + 1'b1;            
                                                //����ԭ��ƽ����
        source_data <= (data_real * data_real) + (data_imag * data_imag);
    end
end

//����ȡģ���㹲�����˶���ʱ�����ڣ��˴���ʱ����ʱ������
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

//��source_data��һ��
always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wr_fifo_data  <= 64'd0;
    end
    else begin
        wr_fifo_data  <= source_data;
    end
end

//���sqrt_busy�½���
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

//����FIFOд�����ź�
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

//����FIFO�������ź�
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        fifo_rd_req <= 1'b0;
    end
    else if((!fifo_rd_empty) && (!sqrt_busy) && (fifo_rd_req == 1'b0) &&(fifo_pre_rd_flag == 1'b1)) begin   //FIFO�ǿ�
        fifo_rd_req <= 1'b1;           
    end
    else begin
        fifo_rd_req <= 1'b0;           
    end    
end

/*******************************״̬��************************************/
//����FIFOд�˿ڣ�ÿ����FIFO��д��ǰ��֡��128��������
always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wr_state <= 2'd0;
        wr_en    <= 1'b0;
        wr_cnt   <= 8'd0;
    end
    else begin
        case(wr_state)
            2'd0: begin             //�ȴ�һ֡���ݵĿ�ʼ�ź�
                if(data_input_start_flag) begin   //����д���ݹ��̣�����дʹ��wr_en
                    wr_state <= 2'd1; 
                    wr_en    <= 1'b1;
                end
                else begin          
                    wr_state <= 2'd0;
                    wr_en    <= 1'b0;
                end
            end
            2'd1: begin             
                if(fifo_wr_req)     //��д��FIFO�е����ݼ���
                    wr_cnt   <= wr_cnt + 1'b1;
                else
                    wr_cnt   <= wr_cnt;
                                    //����FFT�õ������ݾ��жԳ��ԣ����ֻȡһ֡���ݵ�һ��
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


/********************************����************************************/

sqrt #(
    .DW             (64              ) 		//��������λ��
)
u_sqrt
(
    .clk            (clk             ),		//ʱ��
    .rst_n          (rst_n           ),		//�͵�ƽ��λ���첽��λͬ���ͷ�        
    .din_cnt        (data_cnt        ),   
    .din_i          (rd_fifo_data    ),		//������������
    .din_valid_i    (fifo_rd_req     ),		//����������Ч                   
    .busy_o         (sqrt_busy       ),		//sqrt��Ԫ��æ     
    .dout_cnt       (data_index      ),            
    .sqrt_o         (data_modulus    ),	    //����������
    .rem_o	        (data_modulus_rem)      //�����������
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
                               