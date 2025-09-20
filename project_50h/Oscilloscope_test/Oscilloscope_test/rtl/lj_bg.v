`timescale 1ns / 1ps

`define UD #1

module lj_bg # (
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
wire [9:0] char1_x, char1_y, char2_x, char2_y;
wire ren1, ren2, ren3,ren;
wire [9:0] char_x, char_y;
wire [239:0] rom_data;
///复位
assign char1_x = ((act_x >= (400)) && (act_x<= (624)) && (act_y>= 244) && (act_y <= 356))? act_x - 400 : 10'd0;
assign char1_y = ((act_x >= (400)) && (act_x<= (624)) && (act_y>= 244) && (act_y <= 356))? act_y - 244 : 10'd0;
assign ren1    = ((act_x >= (400)) && (act_x<= (624)) && (act_y>= 244) && (act_y <= 356))? 1'b0 : 1'b1;
//返回
assign char2_x = ((act_x >= (780)) && (act_x <= (1004)) && (act_y >=44) && (act_y <= 156))? act_x - 780 : 10'd0;
assign char2_y = ((act_x >= (780)) && (act_x <= (1004)) && (act_y >=44) && (act_y <= 156))? act_y - 44 : 10'd0;
assign ren2    = ((act_x >= (780)) && (act_x <= (1004)) && (act_y >=44) && (act_y <= 156))? 1'b0 : 1'b1;

assign char_x = (!ren1) ? char1_x :
                (!ren2) ? char2_x : 10'd0;

assign char_y = (!ren1) ? char1_y + 'd558 :
                (!ren2) ? char2_y + 'd336 :10'd0;

assign ren = (ren1 & ren2) ? 1'b1 : 1'b0;

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