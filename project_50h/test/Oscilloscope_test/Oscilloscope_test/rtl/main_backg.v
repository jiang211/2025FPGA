`timescale 1ns / 1ps

`define UD #1

module main_backg # (
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
wire [9:0] char1_x, char1_y, char2_x, char2_y, char3_x, char3_y;
wire ren1, ren2, ren3,ren;
wire [9:0] char_x, char_y;
wire [239:0] rom_data;
///信号发生器
// assign char1_x = ((act_x >= (75)) && (act_x<= (315)) && (act_y>= 300) && (act_y <= 348))? act_x - 75 : 10'd0;
// assign char1_y = ((act_x >= (75)) && (act_x<= (315)) && (act_y>= 300) && (act_y <= 348))? act_y - 300 : 10'd0;
// assign ren1    = ((act_x >= (75)) && (act_x<= (315)) && (act_y>= 300) && (act_y <= 348))? 1'b0 : 1'b1;
//示波器
assign char2_x = ((act_x >= (390)) && (act_x <= (630)) && (act_y >=300) && (act_y <=348))? act_x - 390 : 10'd0;
assign char2_y = ((act_x >= (390)) && (act_x <= (630)) && (act_y >=300) && (act_y <=348))? act_y - 300 : 10'd0;
assign ren2    = ((act_x >= (390)) && (act_x <= (630)) && (act_y >=300) && (act_y <=348))? 1'b0 : 1'b1;
//逻辑分析仪
assign char3_x = ((act_x >= (705)) && (act_x <= (945)) && (act_y >=300) && (act_y <= 348))? act_x - 705 : 10'd0;
assign char3_y = ((act_x >= (705)) && (act_x <= (945)) && (act_y >=300) && (act_y <= 348))? act_y - 300 : 10'd0;
assign ren3    = ((act_x >= (705)) && (act_x <= (945)) && (act_y >=300) && (act_y <= 348))? 1'b0 : 1'b1;

assign char_x = //(!ren1) ? char1_x :
                (!ren2) ? char2_x :
                (!ren3) ? char3_x : 
                10'd0;

assign char_y = //(!ren1) ? char1_y        :
                (!ren2) ? char2_y + 'd48 :
                (!ren3) ? char3_y + 'd96 : 
                10'd0;

//assign ren = (ren1 & ren2 & ren3) ? 1'b1 : 1'b0;
assign ren = (ren2 & ren3) ? 1'b1 : 1'b0;

always@(posedge pix_clk)
begin
	if(ren == 1'b0)
		if(rom_data['d240 - char_x] == 1)
			rgb_data <= 16'hffff;
		else
			rgb_data <= 16'h0000;
	else
		rgb_data <= 16'h0000;
end


bg_rom bg_rom_m0(
	.addr(char_y),
	.clk(pix_clk),
	.rst(ren),
	.rd_data(rom_data)
	);
endmodule
