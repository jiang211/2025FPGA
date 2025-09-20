module fft_hdmi_rw_fifo_ctrl(
    input             wd_clk,
    input             hdmi_clk,
    input             rst_n,
    //FFT��������
    input      [31:0] fft_data,        //FFTƵ������
    input             fft_valid,       //FFTƵ��������Ч�ź�
    output            data_input_start_flag, //FFTȡģfifoʹ���ź�
    
    input             data_req,        //���������ź�
    input             fft_point_done,  //FFT��ǰƵ�׻������
    output reg [9:0]  fft_point_cnt,   //FFTƵ��λ��
    //FIFO���ƶ˿�  
    input             fifo_rd_empty,   //FIFO�����ź�
    input      [10:0] fifo_wr_cnt,     //FIFO��ǰ�����������
    output            fifo_rd_req,     //FIFO�������ź�
    output            fifo_pre_rd_req, //FIFOԤ�������ź�
    output     [31:0] fifo_wr_data,    //FIFOд����
    output            fifo_wr_req      //FIFOд�����ź�
   );

//parameter define
parameter TRANSFORM_LEN = 256;        //FFT��������:256

//reg define
reg           fft_valid_r;
reg  [31:0]   fft_data_r ;

reg           data_input_start_flag_r  ;
reg           fifo_pre_rd_req_r        ;
reg           fifo_pre_rd_flag_r       ;
reg           fifo_rd_req_r            ;

//*****************************************************
//**                    main code
//*****************************************************
 
assign fifo_wr_req  = fft_valid_r; //����fifoд�����ź�
assign fifo_wr_data = fft_data_r;
assign data_input_start_flag = data_input_start_flag_r;
assign fifo_pre_rd_req = fifo_pre_rd_req_r;
assign fifo_rd_req = fifo_rd_req_r;



//����������Ч�ź���ʱһ��ʱ������
always @ (posedge wd_clk or negedge rst_n) begin
    if(!rst_n) begin
        fft_data_r  <= 32'd0;
        fft_valid_r <= 1'b0;
    end
    else begin
        fft_data_r  <= fft_data;
        fft_valid_r <= fft_valid;
    end     
end

//��FIFO�е����ݱ�����һ���ʱ�򣬽�����һ֡����д����
always @ (posedge wd_clk or negedge rst_n) begin
    if(!rst_n) begin
        data_input_start_flag_r <= 1'b0;
    end
    else if(fifo_wr_cnt <= TRANSFORM_LEN/4) begin
        data_input_start_flag_r <= 1'b1;
    end
    else begin
        data_input_start_flag_r <= 1'b0;
    end
end

//Ԥ��ȡFIFO�����fifo����ӿ���һ������
always @(posedge hdmi_clk or negedge rst_n)begin
    if(!rst_n)begin  //��λ
        fifo_pre_rd_req_r <= 'd0;
        fifo_pre_rd_flag_r <= 'd0;
    end
    else if((!fifo_rd_empty) && (fifo_pre_rd_flag_r == 'd0)) begin
        fifo_pre_rd_req_r <= 'd1;
        fifo_pre_rd_flag_r <= 'd1;
    end
    else begin
        fifo_pre_rd_req_r <= 'd0;
    end
end

//����FIFO�������źź͵�ǰ��FIFO�ж����ĵڼ����㣬fft_point_cnt��0~127��
always @(posedge hdmi_clk or negedge rst_n) begin
    if(!rst_n) begin
        fifo_rd_req_r <= 1'b0;
        fft_point_cnt <= 8'd0;
    end
    else begin
        if((!fifo_rd_empty) && (fifo_pre_rd_flag_r == 1'b1)) begin   //FIFO�ǿ�
            fifo_rd_req_r <= data_req;
            if(fft_point_done) begin
                if(fft_point_cnt == TRANSFORM_LEN/2 - 1)
                    fft_point_cnt <= 8'd0;
                else
                    fft_point_cnt <= fft_point_cnt + 1'b1;            
            end            
        end    
    end
end


endmodule