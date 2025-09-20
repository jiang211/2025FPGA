module sincer_top(
    input            clk,
    input            rst_n,
    input            wr_en,//必须为明确的
    input            rd_en,
    input  [7:0]     ori_data,
    output [7:0]     sin_data,
    output           p_wr_full,
    output           p_almost_full,
    output           n_rd_empty,
    output           n_almost_empty
);

//复位与初始化
wire w_rst;
reg inst_flag = 0;
reg [2:0] inst_cnt = 0;
reg [2:0] rst_cnt = 0;

//p_fifo
//reg p_wr_en = 0;
//reg p_rd_en = 0;
wire [79:0] w_sincer;
wire wp_rd_en;
//wire wp_wr_full, wp_almost_full;
wire wp_rd_empty, wp_almost_empty;
//wire [7:0] wp_wr_data;
wire [7:0] wp_rd_data;

//n_fifo
//reg n_wr_en = 0;
//reg n_rd_en = 0;
wire wn_wr_full, wn_almost_full; 
//wn_rd_empty, wn_almost_empty;
wire [15:0] wn_wr_data;
//wire [7:0] wn_rd_data;

//FSM
localparam INST = 3'd0;
localparam RST  = 3'd1;
localparam WORKING = 3'd2;

reg [2:0] state = INST;
reg [2:0] n_state = INST;

//*初始化、复位控制
assign w_rst = inst_flag ? 1'b0 : 1'b1;

//数据流
//assign wp_wr_data = ori_data;
//assign sin_data = wn_rd_data;

//TODO:测试用数据流
//assign wn_wr_data = wp_rd_data;



//*FSM状态机
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RST;
    end
    else begin
        state <= n_state;
    end
end

always @(*) begin
    case (state)
        INST: begin
            if (inst_cnt >= 7) begin
                n_state = WORKING;
            end
            else begin
                n_state = INST;
            end
        end
        RST: begin
            if (rst_cnt >= 7) begin
                n_state = WORKING;
            end
            else begin
                n_state = RST;
            end
        end
        WORKING: begin
            n_state = WORKING;
        end
        default:n_state = WORKING;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin//立刻输出复位状态的输出，不等n_state指示了   
        inst_flag <= 1;
        rst_cnt <= 0;
    end
    else begin
        case (n_state)//此处不需要default，因为上面下一个状态准备已经有纠错了
            INST: begin
                if (inst_cnt <= 1) begin
                    inst_flag <= 1;
                end
                else begin
                    inst_flag <= 0;
                end
                inst_cnt <= inst_cnt + 1;
            end  
            RST: begin
                if (rst_cnt <=  1) begin
                    inst_flag <= 1;
                end
                else begin
                    inst_flag <= 0;
                end
                rst_cnt <= rst_cnt + 1;
            end
            WORKING: begin
                inst_cnt <= 0;
                rst_cnt <= 0;
                //TODO:测试用
                /*
                p_wr_en <= 1;
                p_rd_en <= 1;
                n_wr_en <= 1;
                n_rd_en <= 1;
                */
            end
        endcase
    end
end

//通过复位实现初始化
sincer sincf (
    .clk(clk),//
    .rst_n(w_rst),//
    .orig_data(wp_rd_data),//
    .p_almost_e(wp_almost_empty),//
    .o_DV(w_sincer_DV),//
    .o_RQ(wp_rd_en),//
    .interp_0(w_sincer[7:0]),//
    .interp_1(w_sincer[15:8]),
    .interp_2(w_sincer[23:16]),
    .interp_3(w_sincer[31:24]),
    .interp_4(w_sincer[39:32]),
    .interp_5(w_sincer[47:40]),
    .interp_6(w_sincer[55:48]),
    .interp_7(w_sincer[63:56]),
    .interp_8(w_sincer[71:64]),
    .interp_9(w_sincer[79:72])
);

Data_convert dc (
    .clk(clk),
    .rst_n(w_rst),
    .i_DV(w_sincer_DV),//安全的
    .i_data(w_sincer),//[79:0].
    .o_DV(w_convert_DV),//
    .o_data(wn_wr_data)//[15:0].
);
//fifo的数据宽度必须是2的次方
//TODO,换成输入位宽为16的n_fifo
p_fifo pf (
  .clk(clk),                      // input.
  .rst(!w_rst),                      // input.
  .wr_en(wr_en),                  // input.要求信号值明确
  .wr_data(ori_data),              // input [7:0].
  .wr_full(p_wr_full),              // output
  .almost_full(p_almost_full),      // output
  .rd_en(wp_rd_en),                  // input.安全的
  .rd_data(wp_rd_data),              // output [7:0].
  .rd_empty(wp_rd_empty),            // output
  .almost_empty(wp_almost_empty)     // output
);

n_fifo nf (
  .clk(clk),                      // input.
  .rst(!w_rst),                      // input.
  .wr_en(w_convert_DV),                  // input.安全的
  .wr_data(wn_wr_data),              // input [15:0].
  .wr_full(wn_wr_full),              // output
  .almost_full(wn_almost_full),      // output
  .rd_en(rd_en),                  // input
  .rd_data(sin_data),              // output [7:0].
  .rd_empty(n_rd_empty),            // output
  .almost_empty(n_almost_empty)     // output
);
endmodule