`timescale 1ns / 1ps

`define UD #1

module xh_bg # (
    parameter                            COCLOR_DEPP=8, // number of bits per channel
    parameter                            X_BITS=13,
    parameter                            Y_BITS=13,
    parameter                            H_ACT = 12'd1280,
    parameter                            V_ACT = 12'd720
)(                                       
    input                                rstn, 
    input                                pix_clk,
    input [X_BITS-1:0]                   act_x,    
    input [Y_BITS-1:0]                   act_y,
    
    input                                vs_in, 
    input                                hs_in, 
    input                                de_in,
    
    output reg                           vs_out, 
    output reg                           hs_out, 
    output reg                           de_out,
    output reg [15:0]                    rgb_data
);

    always @(posedge pix_clk)
    begin
        vs_out <= `UD vs_in;
        hs_out <= `UD hs_in;
        de_out <= `UD de_in;
    end
wire [9:0] char1_x, char1_y, char2_x, char2_y, char3_x, char3_y, char4_x, char4_y,char5_x, char5_y, char6_x, char6_y,char7_x,char7_y;
wire ren1, ren2, ren3,ren,ren4,ren5,ren6,ren7;
wire [9:0] char_x, char_y;
wire [239:0] rom_data;
///波形
assign char1_x = ((act_x >= (16)) && (act_x<= (240)) && (act_y>= 244) && (act_y <= 356))? act_x - 16 : 10'd0;
assign char1_y = ((act_x >= (16)) && (act_x<= (240)) && (act_y>= 244) && (act_y <= 356))? act_y - 244 : 10'd0;
assign ren1    = ((act_x >= (16)) && (act_x<= (240)) && (act_y>= 244) && (act_y <= 356))? 1'b0 : 1'b1;
//频率
assign char2_x = ((act_x >= (272)) && (act_x <= (496)) && (act_y >=244) && (act_y <=356))? act_x - 272 : 10'd0;
assign char2_y = ((act_x >= (272)) && (act_x <= (496)) && (act_y >=244) && (act_y <=356))? act_y - 244 : 10'd0;
assign ren2    = ((act_x >= (272)) && (act_x <= (496)) && (act_y >=244) && (act_y <=356))? 1'b0 : 1'b1;
//幅度值
assign char3_x = ((act_x >= (272)) && (act_x <= (496)) && (act_y >=444) && (act_y <= 556))? act_x - 272 : 10'd0;
assign char3_y = ((act_x >= (272)) && (act_x <= (496)) && (act_y >=444) && (act_y <= 556))? act_y - 444 : 10'd0;
assign ren3    = ((act_x >= (272)) && (act_x <= (496)) && (act_y >=444) && (act_y <= 556))? 1'b0 : 1'b1;
//返回
assign char4_x = ((act_x >= (780)) && (act_x <= (1004)) && (act_y >=44) && (act_y <= 156))? act_x - 780 : 10'd0;
assign char4_y = ((act_x >= (780)) && (act_x <= (1004)) && (act_y >=44) && (act_y <= 156))? act_y - 44 : 10'd0;
assign ren4    = ((act_x >= (780)) && (act_x <= (1004)) && (act_y >=44) && (act_y <= 156))? 1'b0 : 1'b1;
//+/-
assign char5_x = ((act_x >= (528)) && (act_x <= (752)) && (act_y >=244) && (act_y <= 356))? act_x - 528 : 10'd0;
assign char5_y = ((act_x >= (528)) && (act_x <= (752)) && (act_y >=244) && (act_y <= 356))? act_y - 244 : 10'd0;
assign ren5    = ((act_x >= (528)) && (act_x <= (752)) && (act_y >=244) && (act_y <= 356))? 1'b0 : 1'b1;
//+/-
assign char6_x = ((act_x >= (528)) && (act_x <= (752)) && (act_y >=444) && (act_y <= 556))? act_x - 528 : 10'd0;
assign char6_y = ((act_x >= (528)) && (act_x <= (752)) && (act_y >=444) && (act_y <= 556))? act_y - 444 : 10'd0;
assign ren6    = ((act_x >= (528)) && (act_x <= (752)) && (act_y >=444) && (act_y <= 556))? 1'b0 : 1'b1;
///复位
assign char7_x = ((act_x >= (16)) && (act_x<= (240)) && (act_y>= 444) && (act_y <= 556))? act_x - 16 : 10'd0;
assign char7_y = ((act_x >= (16)) && (act_x<= (240)) && (act_y>= 444) && (act_y <= 556))? act_y - 444 : 10'd0;
assign ren7    = ((act_x >= (16)) && (act_x<= (240)) && (act_y>= 444) && (act_y <= 556))? 1'b0 : 1'b1;

assign char_x = (!ren1) ? char1_x :
                (!ren2) ? char2_x :
                (!ren3) ? char3_x : 
                (!ren4) ? char4_x :
                (!ren5) ? char5_x :
                (!ren6) ? char6_x :
                (!ren7)  ? char7_x :10'd0;

assign char_y = (!ren1) ? char1_y        :
                (!ren2) ? char2_y + 'd112 :
                (!ren3) ? char3_y + 'd224 :
                (!ren4) ? char4_y + 'd336 :
                (!ren5) ? char5_y + 'd448 :
                (!ren6) ? char6_y + 'd448 :
                (!ren7) ? char7_y + 'd558 :10'd0;

assign ren = (ren1 & ren2 & ren3 & ren4 & ren5 & ren6 & ren7) ? 1'b1 : 1'b0;

always@(posedge pix_clk)
begin
	if(ren == 1'b0)
		if(rom_data['d224 - char_x] == 1)
			rgb_data <= 15'h0000;
		else
			rgb_data <= 15'hffff;
	else
		rgb_data <= 15'hffff;
end


xh_rom xh_rom_m0(
	.addr(char_y),
	.clk(pix_clk),
	.rst(ren),
	.rd_data(rom_data)
	);
endmodule