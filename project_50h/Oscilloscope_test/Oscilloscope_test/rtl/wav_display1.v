
module wav_display1 # (
    parameter                            H_ACT = 12'd1920,
    parameter                            V_ACT = 12'd1080
) (
	input                       rst_n,   
	input                       pclk,
	input[15:0]                 wave_color,
    input                       clk ,
	input[7:0]                  data,
	input[7:0]		            amp_h,
	input[0:0]		            stop,	
	input[7:0]		            p_x,
    input                       d_clk,
	input                       i_hs,    
	input                       i_vs,    
	input                       i_de,	
	input[15:0]                 i_data,  
	output                      o_hs,    
	output                      o_vs,    
	output                      o_de,    
	output[15:0]                o_data
);

wire [10:0]wr_addr ;
reg  wren ;
reg [10:0]sample_cnt ;
reg [31:0]wait_cnt ;

reg [3:0] state ;
parameter IDLE = 3'b001 ;
parameter S_SAMPLE = 3'b010 ;
parameter S_WAIT = 3'b100 ;


wire[11:0] pos_x;
wire[11:0] pos_y;
wire       pos_hs;
wire       pos_vs;
wire       pos_de;
wire[15:0] pos_data;
reg[15:0]  v_data;
reg[10:0]   rdaddress;
wire[7:0]  q;
reg        x_en;


assign o_data = v_data;
assign o_hs = pos_hs;
assign o_vs = pos_vs;
assign o_de = pos_de;
always@(posedge pclk)
begin
	if(pos_y >= V_ACT/6 && pos_y <= (V_ACT - V_ACT/6) && pos_x >= H_ACT/5 && pos_x  <= (H_ACT - H_ACT/5))
		x_en <= 1'b1;
	else
		x_en <= 1'b0;
end

always@(posedge d_clk)
begin
	if(x_en == 1'b1)
		rdaddress <= rdaddress + p_x;
	else
		rdaddress <= 10'd0;
end

wire l = (q < 8'd127) ? 1'b1 : 1'b0;
wire [7:0]dis_data = (l) ? 8'd127 - q : q - 8'd127;
wire [7:0]dis_data_inv = dis_data * (20 + amp_h) / 20;
always@(posedge pclk)
begin
	if(x_en == 1'b1)begin
		if(l)begin
			if(('d300 - pos_y)/2 == dis_data_inv)
				v_data <= wave_color;
			else
				v_data <= pos_data;
		end
		else begin
			if((pos_y - 'd300)/2 == dis_data_inv)
				v_data <= wave_color;
			else
				v_data <= pos_data;
		end
	end
	else
		v_data <= pos_data;
end

always @(posedge clk ) begin
	if (~rst_n)begin
		state <= 3'b001 ;
		wren <= 1'b0 ;
		sample_cnt <= 11'd0;
		wait_cnt <= 32'd0;
	end
	else begin
		case (state)
			IDLE : begin
				state <= S_SAMPLE ; 
			end 
			S_SAMPLE : begin
				if(sample_cnt == 11'd1023)
				begin
					sample_cnt <= 11'd0;
					wren <= 1'b0;
					state <= S_WAIT;
				end
				else
				begin
					sample_cnt <= sample_cnt + 11'd1;
				end
			end
			S_WAIT : begin
				if(wait_cnt == 32'd33_670_033)
				begin
					state <= S_SAMPLE;
                     wren <= 1'b1;
					wait_cnt <= 32'd0;
				end
				else
				begin
					wait_cnt <= wait_cnt + 32'd1;
				end
			end
			default: state <= IDLE ; 
		endcase
	end 
end

assign wr_addr = sample_cnt ;





ram u_ram(
        .wr_data(data),
        .wr_addr(wr_addr),
        .wr_en(wren&(!stop)),
        .wr_clk(clk),
        .wr_rst(~rst_n),
        .rd_data(q),
        .rd_addr(rdaddress),
        .rd_clk(pclk),
        .rd_rst(~rst_n)
    );

timing_gen_xy timing_gen_xy_m0(
	.rst_n    (rst_n    ),
	.clk      (pclk     ),
	.i_hs     (i_hs     ),
	.i_vs     (i_vs     ),
	.i_de     (i_de     ),
	.i_data   (i_data   ),
	.o_hs     (pos_hs   ),
	.o_vs     (pos_vs   ),
	.o_de     (pos_de   ),
	.o_data   (pos_data ),
	.x        (pos_x    ),
	.y        (pos_y    )
);
endmodule
/*
module wav_display1 # (
    parameter                            H_ACT = 12'd1920,
    parameter                            V_ACT = 12'd1080
) (
	input                       rst_n,   
	input                       pclk,
	input[15:0]                 wave_color,
    input                       clk ,
	input[7:0]                  data,
	input[7:0]		            amp_h,
	input[0:0]		            stop,	
	input[7:0]		            p_x,
    input                       d_clk,
	input                       i_hs,    
	input                       i_vs,    
	input                       i_de,	
	input[15:0]                 i_data,  
	output                      o_hs,    
	output                      o_vs,    
	output                      o_de,    
	output[15:0]                o_data
);

wire [10:0]wr_addr ;
reg  wren ;
reg [10:0]sample_cnt ;
reg [31:0]wait_cnt ;

reg [3:0] state ;
parameter IDLE = 3'b001 ;
parameter S_SAMPLE = 3'b010 ;
parameter S_WAIT = 3'b100 ;


wire[11:0] pos_x;
wire[11:0] pos_y;
wire       pos_hs;
wire       pos_vs;
wire       pos_de;
wire[15:0] pos_data;
reg[15:0]  v_data;
reg[10:0]   rdaddress;
wire[7:0]  q;
reg        x_en;


assign o_data = v_data;
assign o_hs = pos_hs;
assign o_vs = pos_vs;
assign o_de = pos_de;
always@(posedge pclk)
begin
	if(pos_y >= V_ACT/6 && pos_y <= (V_ACT - V_ACT/6) && pos_x >= H_ACT/5 && pos_x  <= (H_ACT - H_ACT/5))
		x_en <= 1'b1;
	else
		x_en <= 1'b0;
end

always@(posedge d_clk)
begin
	if(x_en == 1'b1)
		rdaddress <= rdaddress + p_x;
	else
		rdaddress <= 10'd0;
end


wire l = (q < 8'd127) ? 1'b1 : 1'b0;
wire [7:0]dis_data = (l) ? 8'd127 - q : q - 8'd127;
wire [7:0]dis_data_inv = dis_data * (20 + amp_h) / 20;
always@(posedge pclk)
begin
	if(x_en == 1'b1)
		if(l)begin
			if((12'd300- pos_y) == dis_data_inv)
				v_data <= wave_color;
			else
				v_data <= pos_data;
			end
		else begin
			if((pos_y - 12'd300) == dis_data_inv)
				v_data <= wave_color;
			else 
				v_data <= pos_data;
		end
	else
		v_data <= pos_data;
end

always @(posedge pclk ) begin
	if (~rst_n)begin
		state <= 3'b001 ;
		wren <= 1'b0 ;
		sample_cnt <= 11'd0;
		wait_cnt <= 32'd0;
	end
	else begin
		case (state)
			IDLE : begin
				state <= S_SAMPLE ; 
			end 
			S_SAMPLE : begin
				if(pulse_signal)
				begin
					sample_cnt <= 11'd0;
					wren <= 1'b0;
					state <= S_WAIT;
				end
				else if(!pos_y)
				begin
					wren <= 1'b1;
				end
				else begin
					wren <= 1'b0;
				end
			end
			S_WAIT : begin
				if(wait_cnt == 32'd15)
				begin
					state <= S_SAMPLE;
					wait_cnt <= 32'd0;
				end
				else if(pulse_signal)
				begin
					wait_cnt <= wait_cnt + 32'd1;
				end
			end
			default: state <= IDLE ; 
		endcase
	end 
end
reg y_0_en_pulse_r1,y_0_en_pulse_r2,y_0_en_pulse_r3;
wire y_0_en;

assign y_0_en = (pos_y == 12'd0) ? 1'b1 : 1'b0;
always @(posedge pclk) begin
    if (!rst_n) begin
        y_0_en_pulse_r1 <= 0;  
        y_0_en_pulse_r2 <= 0;
        y_0_en_pulse_r3 <= 0;
    end else begin
        y_0_en_pulse_r1 <= y_0_en;
        y_0_en_pulse_r2 <= y_0_en_pulse_r1;
        y_0_en_pulse_r3 <= y_0_en_pulse_r2;
    end
end
wire pulse_signal = ~y_0_en_pulse_r3 & y_0_en_pulse_r2;


ram u_ram(
        .wr_data(data),
        .wr_addr(pos_x),
        .wr_en(wren&(!stop)),
        .wr_clk(pclk),
        .wr_rst(~rst_n),
        .rd_data(q),
        .rd_addr(pos_x),
        .rd_clk(pclk),
        .rd_rst(~rst_n)
    );

timing_gen_xy timing_gen_xy_m0(
	.rst_n    (rst_n    ),
	.clk      (pclk     ),
	.i_hs     (i_hs     ),
	.i_vs     (i_vs     ),
	.i_de     (i_de     ),
	.i_data   (i_data   ),
	.o_hs     (pos_hs   ),
	.o_vs     (pos_vs   ),
	.o_de     (pos_de   ),
	.o_data   (pos_data ),
	.x        (pos_x    ),
	.y        (pos_y    )
);
endmodule
*/