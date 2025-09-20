module touch_data_hd (
    input wire clk,
    input wire reset,
    input wire [31:0] data_in,
    output reg [2:0]Interface_control,
    output wire rest,
    //output wire [7:0] led,
    output wire [15:0] x,
    output wire [15:0] y,
    output wire [31:0] xh_control,
    output wire fft_,
    output wire stop_,
    output wire td1_,
    output wire td2_,
    output wire chaf_,
    output wire [2:0] p_x1_,
    output wire [2:0] p_x2_,
    output wire [4:0] p_y_,
    output wire zon,
    output wire cz_
);

parameter H_ACT = 12'd1024; 
parameter V_ACT = 12'd600;  
wire  [15:0]  bcd_data_x ;
wire  [15:0]  bcd_data_y ;
wire [31:0] data;
wire sbq;

wire   [3:0]              data0    ;  // Y轴坐标个位数
wire   [3:0]              data1    ;  // Y轴坐标十位数
wire   [3:0]              data2    ;  // Y轴坐标百位数

wire   [3:0]              data3    ;  // X轴坐标个位数
wire   [3:0]              data4    ;  // X轴坐标十位数
wire   [3:0]              data5    ;  // X轴坐标百位数
wire   [3:0]              data6    ;  // X轴坐标千位数

binary2bcd u_binary2bcd_x(
    .sys_clk         (clk),
    .sys_rst_n       (reset),
    .data            (data_in[31:16]),

    .bcd_data        (bcd_data_x)    
);

binary2bcd u_binary2bcd_y(
    .sys_clk         (clk),
    .sys_rst_n       (reset),
    .data            (data_in[15:0]),

    .bcd_data        (bcd_data_y)    
); 
assign data = {bcd_data_x,bcd_data_y};
assign  data6 = data[31:28] ;   // X轴坐标千位数
assign  data5 = data[27:24] ;   // X轴坐标百位数
assign  data4 = data[23:20] ;   // X轴坐标十位数
assign  data3 = data[19:16] ;   // X轴坐标个位数

assign  data2 = data[11:8]  ;   // Y轴坐标百位数
assign  data1 = data[7:4]   ;   // Y轴坐标十位数
assign  data0 = data[3:0]   ;   // Y轴坐标个位数
assign x = data6 * 1000 + data5 * 100 + data4 * 10 + data3;
assign y = data2 * 100 + data1 * 10 + data0;
//assign led[0] = td1_click ;
//assign led[1] = td2_click ;
//assign led[2] = fft_click ;
//assign led[3] = chaf_click;
//assign led[4] = stop_click;
//assign led[5] = Interface_control[0];
//assign led[6] = Interface_control[1];
//assign led[7] = Interface_control[2];
always@(posedge clk or negedge reset) begin
    if(!reset) begin
        Interface_control <= 3'd0;
    end /*else if(x >= 'd75  && x <= 'd315 && y >= 'd200 && y <= 'd448 && Interface_control == 3'd0) begin
        Interface_control <= 3'd1;
    end */else if(x >= 'd390 && x <= 'd630 && y >= 'd200 && y <= 'd448 && Interface_control == 3'd0) begin
        Interface_control <= 3'd2;
    end /*else if(x >= 'd705 && x <= 'd945 && y >= 'd200 && y <= 'd448 && Interface_control == 3'd0) begin
        Interface_control <= 3'd3;
    end */else if (fft_pos_edge) begin
        Interface_control <= 3'd4;
    end else if(rest) begin
        Interface_control <= 3'd0;
    end else if(fft_rst) begin
        Interface_control <= 3'd2; 
    end else begin
        Interface_control <= Interface_control;
    end
end

assign rest = ((Interface_control == 3'd2) && (x >= H_ACT/5 + H_ACT/5 + H_ACT/5) && (x <= H_ACT - H_ACT/5) && (y >= 0) && (y <= V_ACT/6)) ||
              ((Interface_control == 3'd1) && (x >= 768) && (x <= H_ACT) && (y >= 0) && (y <= V_ACT/3)) ||
              ((Interface_control == 3'd3) && (x >= 768) && (x <= H_ACT) && (y >= 0) && (y <= V_ACT/3));
wire fft_rst;
assign fft_rst = ((Interface_control == 3'd4) && (x >= H_ACT - H_ACT/5) && (x <= H_ACT) && (y >= 0) && (y <= V_ACT/6));

assign zon = (rest || fft_rst || rst1 || rst2 || rst3 || select_click || fre_1_click || fre_2_click || amp_1_click || amp_2_click || p_x_1_click || p_x_2_click || p_y_1_click || p_y_2_click || td1_click || td2_click || fft_click || stop_click || chaf_click || cz_click);

wire [2:0] select_;
wire [3:0] fre_1_;
wire [2:0] fre_2_;
wire [3:0] amp_;

//信号发生器
reg [2:0] select;
reg [3:0] fre_1; //频率加
reg [2:0] fre_2; //频率减
reg [3:0] amp; //振幅加
wire rst1; //复位
wire select_click; //点击选择
wire fre_1_click; //频率加点击
wire fre_2_click; //频率减点击
wire amp_1_click; //振幅加点击
wire amp_2_click; //振幅减点击
//逻辑分析仪
wire rst2;
//示波器
wire rst3;//复位    
reg td1;
reg td2;
reg fft;
reg cz;
reg stop;
reg chaf;
reg [2:0] p_x1;
reg [2:0] p_x2;
reg [4:0] p_y;
wire p_x_1_click;//X轴坐标加点击
wire p_x_2_click;//X轴坐标减点击
wire p_y_1_click;//Y轴坐标加点击
wire p_y_2_click;//Y轴坐标减点击
wire td1_click;
wire td2_click;
wire fft_click;
wire stop_click;
wire chaf_click;
wire cz_click;

wire select_pos_edge;
wire fre1_pos_edge;
wire fre2_pos_edge;
wire amp1_pos_edge;
wire amp2_pos_edge;
wire p_x1_pos_edge;
wire p_x2_pos_edge;
wire p_y1_pos_edge;
wire p_y2_pos_edge;
wire td1_pos_edge;
wire td2_pos_edge;
wire fft_pos_edge;
wire stop_pos_edge;
wire chaf_pos_edge;
wire cz_pos_edge;

reg select_pulse_r1,select_pulse_r2,select_pulse_r3;
reg fre1_pulse_r1,fre1_pulse_r2,fre1_pulse_r3;
reg fre2_pulse_r1,fre2_pulse_r2,fre2_pulse_r3;
reg amp1_pulse_r1,amp1_pulse_r2,amp1_pulse_r3;
reg amp2_pulse_r1,amp2_pulse_r2,amp2_pulse_r3;
reg p_x1_pulse_r1,p_x1_pulse_r2,p_x1_pulse_r3;
reg p_x2_pulse_r1,p_x2_pulse_r2,p_x2_pulse_r3;
reg p_y1_pulse_r1,p_y1_pulse_r2,p_y1_pulse_r3;
reg p_y2_pulse_r1,p_y2_pulse_r2,p_y2_pulse_r3;
reg td1_pulse_r1,td1_pulse_r2,td1_pulse_r3;
reg td2_pulse_r1,td2_pulse_r2,td2_pulse_r3;
reg fft_pulse_r1,fft_pulse_r2,fft_pulse_r3;
reg stop_pulse_r1,stop_pulse_r2,stop_pulse_r3;
reg chaf_pulse_r1,chaf_pulse_r2,chaf_pulse_r3;
reg cz_pulse_r1,cz_pulse_r2,cz_pulse_r3;

always @ (posedge clk or negedge reset) //异步
 if(!reset) 
    begin
        select_pulse_r1 <= 1'b0;
        select_pulse_r2 <= 1'b0;
        select_pulse_r3 <= 1'b0;
        fre1_pulse_r1 <= 1'b0;
        fre1_pulse_r2 <= 1'b0; 
        fre1_pulse_r3 <= 1'b0;
        fre2_pulse_r1 <= 1'b0;
        fre2_pulse_r2 <= 1'b0;
        fre2_pulse_r3 <= 1'b0;
        amp1_pulse_r1 <= 1'b0;
        amp1_pulse_r2 <= 1'b0;
        amp1_pulse_r3 <= 1'b0;
        amp2_pulse_r1 <= 1'b0;
        amp2_pulse_r2 <= 1'b0;
        amp2_pulse_r3 <= 1'b0;
        p_x1_pulse_r1 <= 1'b0;
        p_x1_pulse_r2 <= 1'b0;
        p_x1_pulse_r3 <= 1'b0;
        p_x2_pulse_r1 <= 1'b0;
        p_x2_pulse_r2 <= 1'b0;
        p_x2_pulse_r3 <= 1'b0;
        p_y1_pulse_r1 <= 1'b0;
        p_y1_pulse_r2 <= 1'b0;
        p_y1_pulse_r3 <= 1'b0;
        p_y2_pulse_r1 <= 1'b0;
        p_y2_pulse_r2 <= 1'b0;
        p_y2_pulse_r3 <= 1'b0;
        td1_pulse_r1 <= 1'b0;
        td1_pulse_r2 <= 1'b0;
        td1_pulse_r3 <= 1'b0;
        td2_pulse_r1 <= 1'b0;
        td2_pulse_r2 <= 1'b0;
        td2_pulse_r3 <= 1'b0;
        fft_pulse_r1 <= 1'b0;
        fft_pulse_r2 <= 1'b0;
        fft_pulse_r3 <= 1'b0;
        stop_pulse_r1 <= 1'b0;
        stop_pulse_r2 <= 1'b0;
        stop_pulse_r3 <= 1'b0;
        chaf_pulse_r1 <= 1'b0;
        chaf_pulse_r2 <= 1'b0;
        chaf_pulse_r3 <= 1'b0;
        cz_pulse_r1 <= 1'b0;
        cz_pulse_r2 <= 1'b0;
        cz_pulse_r3 <= 1'b0;
    end
 else 
    begin
        select_pulse_r1 <= select_click;
        select_pulse_r2 <= select_pulse_r1;
        select_pulse_r3 <= select_pulse_r2;
        fre1_pulse_r1 <= fre_1_click;
        fre1_pulse_r2 <= fre1_pulse_r1;
        fre1_pulse_r3 <= fre1_pulse_r2;
        fre2_pulse_r1 <= fre_2_click;
        fre2_pulse_r2 <= fre2_pulse_r1;
        fre2_pulse_r3 <= fre2_pulse_r2;
        amp1_pulse_r1 <= amp_1_click;
        amp1_pulse_r2 <= amp1_pulse_r1;
        amp1_pulse_r3 <= amp1_pulse_r2;
        amp2_pulse_r1 <= amp_2_click;
        amp2_pulse_r2 <= amp2_pulse_r1;
        amp2_pulse_r3 <= amp2_pulse_r2;
        p_x1_pulse_r1 <= p_x_1_click;
        p_x1_pulse_r2 <= p_x1_pulse_r1;
        p_x1_pulse_r3 <= p_x1_pulse_r2;
        p_x2_pulse_r1 <= p_x_2_click;
        p_x2_pulse_r2 <= p_x2_pulse_r1;
        p_x2_pulse_r3 <= p_x2_pulse_r2;
        p_y1_pulse_r1 <= p_y_1_click;
        p_y1_pulse_r2 <= p_y1_pulse_r1;
        p_y1_pulse_r3 <= p_y1_pulse_r2;
        p_y2_pulse_r1 <= p_y_2_click;
        p_y2_pulse_r2 <= p_y2_pulse_r1;
        p_y2_pulse_r3 <= p_y2_pulse_r2;
        td1_pulse_r1 <= td1_click;
        td1_pulse_r2 <= td1_pulse_r1;
        td1_pulse_r3 <= td1_pulse_r2;
        td2_pulse_r1 <= td2_click;
        td2_pulse_r2 <= td2_pulse_r1;
        td2_pulse_r3 <= td2_pulse_r2;
        fft_pulse_r1 <= fft_click;
        fft_pulse_r2 <= fft_pulse_r1;
        fft_pulse_r3 <= fft_pulse_r2;
        stop_pulse_r1 <= stop_click;
        stop_pulse_r2 <= stop_pulse_r1;
        stop_pulse_r3 <= stop_pulse_r2;
        chaf_pulse_r1 <= chaf_click;
        chaf_pulse_r2 <= chaf_pulse_r1;
        chaf_pulse_r3 <= chaf_pulse_r2;
        cz_pulse_r1 <= cz_click;
        cz_pulse_r2 <= cz_pulse_r1;
        cz_pulse_r3 <= cz_pulse_r2;
    end


//下降沿检测
assign select_pos_edge = ~select_pulse_r2  & select_pulse_r3;
assign fre1_pos_edge   = ~fre1_pulse_r2  & fre1_pulse_r3;
assign fre2_pos_edge   = ~fre2_pulse_r2  & fre2_pulse_r3;
assign amp1_pos_edge   = ~amp1_pulse_r2  & amp1_pulse_r3;
assign amp2_pos_edge   = ~amp2_pulse_r2  & amp2_pulse_r3;
assign p_x1_pos_edge   = ~p_x1_pulse_r2  & p_x1_pulse_r3;
assign p_x2_pos_edge   = ~p_x2_pulse_r2  & p_x2_pulse_r3;
assign p_y1_pos_edge   = ~p_y1_pulse_r2  & p_y1_pulse_r3;
assign p_y2_pos_edge   = ~p_y2_pulse_r2  & p_y2_pulse_r3;
assign td1_pos_edge    = ~td1_pulse_r2    & td1_pulse_r3;
assign td2_pos_edge    = ~td2_pulse_r2    & td2_pulse_r3;
assign fft_pos_edge    = ~fft_pulse_r2    & fft_pulse_r3;
assign stop_pos_edge   = ~stop_pulse_r2  & stop_pulse_r3;
assign chaf_pos_edge   = ~chaf_pulse_r2  & chaf_pulse_r3;
assign cz_pos_edge     = ~cz_pulse_r2    & cz_pulse_r3;

assign rst1 = ((Interface_control == 3'd1) && (x >= 0) && (x <= H_ACT/4) && (y >= V_ACT/3 + V_ACT/3) && (y <= V_ACT)); 
assign rst2 = ((Interface_control == 3'd2) && (x >= H_ACT/5) && (x <= H_ACT/5 + H_ACT/5) && (y >= 0) && (y <= V_ACT/6));
assign rst3 = ((Interface_control == 3'd3) && (x >= 300) && (x <= 700) && (y >= 200) && (y <= 400));


assign select_click = ((Interface_control == 3'd1) && (x >= 0) && (x <= H_ACT/4) && (y >= V_ACT/3) && (y <= V_ACT/3 + V_ACT/3));
assign fre_1_click = ((Interface_control == 3'd1) && (x >= H_ACT/2) && (x <= H_ACT/2 + H_ACT/8) && (y >= V_ACT/3) && (y <= V_ACT/3 + V_ACT/3));
assign fre_2_click = ((Interface_control == 3'd1) && (x >= H_ACT/2 + H_ACT/8) && (x <= H_ACT/2 + H_ACT/4) && (y >= V_ACT/3) && (y <= V_ACT/3 + V_ACT/3));
assign amp_1_click = ((Interface_control == 3'd1) && (x >= H_ACT/2 ) && (x <= H_ACT/2 + H_ACT/8) && (y >= V_ACT/3 + V_ACT/3) && (y <= V_ACT));
assign amp_2_click = ((Interface_control == 3'd1) && (x >= H_ACT/2 + H_ACT/8) && (x <= H_ACT/2 + H_ACT/4) && (y >= V_ACT/3 + V_ACT/3) && (y <= V_ACT));

assign p_x_1_click = ((Interface_control == 3'd2) && (x >=0 ) && (x <= H_ACT/10) && (y >= V_ACT - V_ACT/6) && (y <= V_ACT));
assign p_x_2_click = ((Interface_control == 3'd2) && (x >= H_ACT/10) && (x <= H_ACT/5) && (y >= V_ACT - V_ACT/6) && (y <= V_ACT));
assign p_y_1_click = ((Interface_control == 3'd2) && (x >= H_ACT - H_ACT/5) && (x <= H_ACT -  H_ACT/10) && (y >= V_ACT - V_ACT/6) && (y <= V_ACT));
assign p_y_2_click = ((Interface_control == 3'd2) && (x >= H_ACT - H_ACT/10) && (x <= H_ACT) && (y >= V_ACT - V_ACT/6) && (y <= V_ACT));

assign td1_click  =  ((Interface_control == 3'd2) && (x >= 10) && (x <= H_ACT/5) && (y >= 10) && (y <= V_ACT/6));
assign td2_click  =  ((Interface_control == 3'd2) && (x >= H_ACT - H_ACT/5) && (x <= H_ACT) && (y >= 0) && (y <= V_ACT/6));
assign fft_click  =  ((Interface_control == 3'd2) && (x >= H_ACT/5 + H_ACT/5) && (x <= H_ACT/5 + H_ACT/5 + H_ACT/5) && (y >= 0) && (y <= V_ACT/6));
assign chaf_click = ((Interface_control == 3'd2) && (x >= H_ACT/5 + H_ACT/5 + H_ACT/5) && (x <= H_ACT - H_ACT/5) && (y >= V_ACT/2 + V_ACT/3) && (y <= V_ACT));
assign stop_click = ((Interface_control == 3'd2) && (x >= H_ACT/5) && (x <= H_ACT/5 +  H_ACT/5) && (y >= V_ACT/2 + V_ACT/3) && (y <= V_ACT));
assign cz_click   = ((Interface_control == 3'd2) && (x >= H_ACT/5 + H_ACT/5) && (x <= H_ACT/5 + H_ACT/5 + H_ACT/5) && (y >= V_ACT/2 + V_ACT/3) && (y <= V_ACT));

always@(posedge clk or negedge reset) begin
    if(!reset) begin
        select <= 3'd0;
        fre_1 <= 4'd1;
        fre_2 <= 3'd0;
        amp <= 4'd0;
        td1 <= 0;
        td2 <= 0;
        fft <= 0;
        stop <= 0;
        chaf <= 0;
        p_x1 <= 3'd0;
        cz <= 0;
        p_x2 <= 3'd1;
        p_y <= 3'd0;
    end else if(rst1) begin
        select <= 3'd0;
        fre_1 <= 4'd1;
        fre_2 <= 3'd0;
        amp <= 4'd0;
    end else if(rst2) begin
        td1 <= 0;
        td2 <= 0;
        fft <= 0;
        stop <= 0;
        chaf <= 0;
        p_x1 <= 3'd0;
        p_x2 <= 3'd1;
        cz <= 0;
        p_y <= 3'd0;
    end else if(select_pos_edge) begin
        if(select > 3'd5)
            select <= 3'd0;
        else
            select <= select + 3'd1;
    end else if(fre1_pos_edge) begin
        fre_1 <= fre_1 + 1;
    end else if(fre2_pos_edge) begin
        fre_2 <= fre_2 + 1;
    end else if(amp2_pos_edge) begin
        amp <= amp + 1;
    end else if(amp1_pos_edge) begin
        amp <= amp - 1;
    end else if(td1_pos_edge) begin
        td1 <= ~td1;
    end else if(td2_pos_edge) begin
        td2 <= ~td2;
    end else if(fft_pos_edge) begin
        fft <= ~fft;
    end else if(stop_pos_edge) begin
        stop <= ~stop;
    end else if(chaf_pos_edge) begin
        chaf <= ~chaf;
    end else if(p_x1_pos_edge) begin
        p_x1 <= p_x1 + 1;
    end else if(p_x2_pos_edge) begin
        p_x2 <= p_x2 + 1;
    end else if(p_y1_pos_edge) begin
        p_y <= p_y + 1;
    end else if(p_y2_pos_edge) begin
        p_y <= p_y - 1;
    end else if(cz_pos_edge) begin
        cz <= ~cz;
    end else begin
        select <= select;
        fre_1 <= fre_1;
        fre_2 <= fre_2;
        amp <= amp;
        td1 <= td1;
        td2 <= td2;
        fft <= fft;
        stop <= stop;
        chaf <= chaf;
        p_x1 <= p_x1;
        p_x2 <= p_x2;
        p_y <= p_y;
        cz <= cz;
    end
end

assign select_ = select;
assign fre_1_ = fre_1;
assign fre_2_ = fre_2;
assign amp_ = amp;
assign td1_ = td1;
assign td2_ = td2;
assign fft_ = fft;
assign stop_ = stop;
assign chaf_ = chaf;
assign p_x1_ = p_x1;
assign p_x2_ = p_x2;
assign p_y_ = p_y;
assign cz_ = cz;
assign xh_control = {{18{1'b0}},amp_, fre_1_, fre_2_, select_};


endmodule