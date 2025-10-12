module data_display # (
    parameter                            H_ACT = 12'd1920,
    parameter                            V_ACT = 12'd1080,
	parameter							 place_x = 10'd0
) (
	input                       rst_n,   
	input                       pclk,
    input                       sys_clk,
	input[23:0]                 wave_color,
    input[10:0]                  max ,
	input[10:0]                  min,
    input[31:0]                  fre,
	input[10:0]                  v,
	input                       i_hs,    
	input                       i_vs,    
	input                       i_de,	
	input[23:0]                 i_data,  
	output                      o_hs/* synthesis PAP_MARK_DEBUG="true" */,    
	output                      o_vs/* synthesis PAP_MARK_DEBUG="true" */,    
	output                      o_de/* synthesis PAP_MARK_DEBUG="true" */,    
	output[23:0]                o_data/* synthesis PAP_MARK_DEBUG="true" */
);

wire[11:0] pos_x;
wire[11:0] pos_y;
wire      pos_hs;
wire      pos_vs;
wire      pos_de;
wire      ren1,ren2,ren3,ren,ren4;
wire[23:0] pos_data;
wire [23:0] rom_data1,rom_data2,rom_data3;
wire [71:0] rom_data;
reg[23:0] v_data;
wire [9:0] wr_addr1,wr_addr2,wr_addr3;
reg [9:0] wr_addr;
wire [4:0] first_1,second_1,third_1,first_2,second_2,third_2,first_3,second_3,third_3,first_4,second_4,third_4;
wire [4:0] first,second,third;
reg [4:0] first_,second_,third_;
wire [143:0] ram_data;
wire [31:0] fre_;
assign fre_ = (fre >= 'd1000) ? fre / 1000 : fre;
wire[9:0] char2_x, char2_y,char1_x, char1_y,char3_x,char_x,char_y,char3_y,char4_x,char4_y;;
assign o_data = v_data;
assign o_hs = pos_hs;
assign o_vs = pos_vs;
assign o_de = pos_de;
data_sep u_data_sep1(
    .data(min),
    .first(first_1),
	.second(second_1),
	.third(third_1)
);

data_sep u_data_sep2(
    .data(max),
    .first(first_2),
	.second(second_2),
	.third(third_2)
);

data_sep u_data_sep3(
    .data(fre_),
    .first(first_3),	
	.second(second_3),
	.third(third_3)
);

data_sep u_data_sep4(
    .data(v),
    .first(first_4),	
	.second(second_4),
	.third(third_4)
);
///最小值
assign char1_x = ((pos_x >= (55 + place_x)) && (pos_x <= (55 + 72 + place_x)) && (pos_y >= 28 + V_ACT/6) && (pos_y <= V_ACT/3 - 28))? pos_x - (55 + place_x) : 10'd0;
assign char1_y = ((pos_x >= (55 + place_x)) && (pos_x <= (55 + 72 + place_x)) && (pos_y >= 28 + V_ACT/6) && (pos_y <= V_ACT/3 - 28))? pos_y - V_ACT/6 - 28 : 10'd0;
assign ren1    = ((pos_x >= (55 + place_x)) && (pos_x <= (55 + 72 + place_x)) && (pos_y >= 28 + V_ACT/6) && (pos_y <= V_ACT/3 - 28))? 1'b0 : 1'b1;
//最大值
assign char2_x = ((pos_x >= (55 + place_x)) && (pos_x <= (55 + 72 + place_x)) && (pos_y >= 28 + V_ACT/3) && (pos_y <= V_ACT/2 - 28))? pos_x - (55 + place_x) : 10'd0;
assign char2_y = ((pos_x >= (55 + place_x)) && (pos_x <= (55 + 72 + place_x)) && (pos_y >= 28 + V_ACT/3) && (pos_y <= V_ACT/2 - 28))? pos_y - V_ACT/3 - 28 : 10'd0;
assign ren2    = ((pos_x >= (55 + place_x)) && (pos_x <= (55 + 72 + place_x)) && (pos_y >= 28 + V_ACT/3) && (pos_y <= V_ACT/2 - 28))? 1'b0 : 1'b1;
//频率
assign char3_x = ((pos_x >= (55 + place_x)) && (pos_x <= (55 + 72 + place_x)) && (pos_y >= V_ACT/2 - 28) && (pos_y <= V_ACT/3 + V_ACT/3 - 28))? pos_x - (55 + place_x) : 10'd0;
assign char3_y = ((pos_x >= (55 + place_x)) && (pos_x <= (55 + 72 + place_x)) && (pos_y >= V_ACT/2 - 28) && (pos_y <= V_ACT/3 + V_ACT/3 - 28))? pos_y - V_ACT/2 - 28 : 10'd0;
assign ren3    = ((pos_x >= (55 + place_x)) && (pos_x <= (55 + 72 + place_x)) && (pos_y >= V_ACT/2 - 28) && (pos_y <= V_ACT/3 + V_ACT/3 - 28))? 1'b0 : 1'b1;
//电压
assign char4_x = ((pos_x >= (55 + place_x)) && (pos_x <= (55 + 72 + place_x)) && (pos_y >= V_ACT/3 + V_ACT/3 + 28) && (pos_y <= V_ACT - V_ACT/6 - 28))? pos_x - (55 + place_x) : 10'd0;
assign char4_y = ((pos_x >= (55 + place_x)) && (pos_x <= (55 + 72 + place_x)) && (pos_y >= V_ACT/3 + V_ACT/3 + 28) && (pos_y <= V_ACT - V_ACT/6 - 28))? pos_y - V_ACT/3 - V_ACT/3 - 28 : 10'd0;
assign ren4    = ((pos_x >= (55 + place_x)) && (pos_x <= (55 + 72 + place_x)) && (pos_y >= V_ACT/3 + V_ACT/3 + 28) && (pos_y <= V_ACT - V_ACT/6 - 28))? 1'b0 : 1'b1;

assign ren = (ren1 & ren2 & ren3 & ren4) ? 1'b1 : 1'b0;

assign char_x = (!ren1)? char1_x :
                (!ren2)? char2_x : 
                (!ren3)? char3_x :
				(!ren4)? char4_x : 10'd0;

assign char_y = (!ren1)? char1_y :
                (!ren2)? char2_y : 
                (!ren3)? char3_y : 
				(!ren4)? char4_y : 10'd0;
always@(posedge pclk)begin
	if(!ren1)begin
		first_ = first_1;
		second_ = second_1;
		third_ = third_1;
	end
	else if(!ren2)begin
		first_ = first_2;
		second_ = second_2;
		third_ = third_2;
	end
	else if(!ren3)begin
		first_ = first_3;
		second_ = second_3;
		third_ = third_3;
	end
	else if(!ren4)begin
		first_ = first_4;
		second_ = second_4;
		third_ = third_4;
	end
	else begin
		first_ = first_;
		second_ = second_;
		third_ = third_;
	end
end
assign first =  first_;

assign second = second_;

assign third =  third_;

always@(posedge pclk)
begin
	if(ren == 1'b0)
		if(ram_data['d72 - char_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else
		v_data <= pos_data;
end


always @(posedge sys_clk ) begin
	if (~rst_n)begin
		wr_addr <= 10'd0;
	end
	else if(ren ==1'b0)begin
		if(wr_addr == 10'd48)
			wr_addr <= 10'd0;
		else
			wr_addr <= wr_addr + 10'd1;
	end 
end

assign wr_addr1 = wr_addr + first * 12'd48;
assign wr_addr2 = wr_addr + second * 12'd48;
assign wr_addr3 = wr_addr + third * 12'd48;

num_rom num_rom_m0(
	.addr(wr_addr1),
	.clk(pclk),
	.rst(1'b0),
	.rd_data(rom_data1)
	);

num_rom num_rom_m1(
	.addr(wr_addr2),
	.clk(pclk),
	.rst(1'b0),
	.rd_data(rom_data2)
	);

num_rom num_rom_m2(
	.addr(wr_addr3),
	.clk(pclk),
	.rst(1'b0),
	.rd_data(rom_data3)
	);

assign rom_data = {rom_data1, rom_data2, rom_data3};

ram1 u_ram(
    .wr_data(rom_data),
    .wr_addr(wr_addr),
    .wr_en(1'b1),
    .wr_clk(pclk),
    .wr_rst(~rst_n),
    .rd_data(ram_data),
    .rd_addr(char_y),
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