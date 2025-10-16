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
    input                                clk,
    input                                pix_clk,
    input [X_BITS-1:0]                   act_x,    
    input [Y_BITS-1:0]                   act_y,
    
    input                                vs_in, 
    input                                hs_in, 
    input                                de_in,

    input[31:0]                          targe_fre,
	input[10:0]                          targe_vpp,
    
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
//wire [9:0] char1_x, char1_y, char2_x, char2_y;
wire ren1, ren2,ren_num_l1,ren_num_l2,ren_num_l3,ren_num_l4,ren_num_l5,ren_num_l6,ren_num_l7,ren_num_l8,ren_num_l9,ren_num_l0;
wire ren_num_r1,ren_num_r2,ren_num_r3,ren_num_r4,ren_num_r5,ren_num_r6,ren_num_r7,ren_num_r8,ren_num_r9,ren_num_r0;
wire [9:0] char_x, char_y;
wire [239:0] rom_data;
wire [9:0] char1_x, char1_y, char2_x, char2_y,char_num_l0_x,char_num_l0_y,char_num_l1_x, char_num_l1_y, char_num_l2_x, char_num_l2_y, char_num_l3_x, char_num_l3_y, char_num_l4_x, char_num_l4_y, char_num_l5_x, char_num_l5_y, char_num_l6_x, char_num_l6_y, char_num_l7_x, char_num_l7_y, char_num_l8_x, char_num_l8_y,char_num_l9_x,char_num_l9_y;
wire [9:0] char_num_r0_x,char_num_r0_y,char_num_r1_x, char_num_r1_y, char_num_r2_x, char_num_r2_y, char_num_r3_x, char_num_r3_y, char_num_r4_x, char_num_r4_y, char_num_r5_x, char_num_r5_y, char_num_r6_x, char_num_r6_y, char_num_r7_x, char_num_r7_y, char_num_r8_x, char_num_r8_y, char_num_r9_x, char_num_r9_y;
//复位 49-96
assign char1_x= ((act_x >= (H_ACT/5 + 'd55))  && (act_x <= (H_ACT/5 - 'd55 + H_ACT/5)) && (act_y >= 'd28	   ) && (act_y <= V_ACT/6 - 28))? act_x - H_ACT/5 - 55: 10'd0;
assign char1_y= ((act_x >= (H_ACT/5 + 'd55))  && (act_x <= (H_ACT/5 - 'd55 + H_ACT/5)) && (act_y >= 'd28	   ) && (act_y <= V_ACT/6 - 28))? act_y - 28: 10'd0;
assign ren1   = ((act_x >= (H_ACT/5 + 'd55))  && (act_x <= (H_ACT/5 - 'd55 + H_ACT/5)) && (act_y >= 'd28	   ) && (act_y <= V_ACT/6 - 28))? 1'b0 : 1'b1;
//返回 0-48
assign char2_x= ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + 'd55)) && (act_x <= (H_ACT - H_ACT/5 - 'd55)) && (act_y >= 'd28	   ) && (act_y <= V_ACT/6 - 28))? act_x - H_ACT/5 - H_ACT/5 - H_ACT/5 - 55: 10'd0;
assign char2_y= ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + 'd55)) && (act_x <= (H_ACT - H_ACT/5 - 'd55)) && (act_y >= 'd28	   ) && (act_y <= V_ACT/6 - 28))? act_y - 28: 10'd0;
assign ren2   = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + 'd55)) && (act_x <= (H_ACT - H_ACT/5 - 'd55)) && (act_y >= 'd28	   ) && (act_y <= V_ACT/6 - 28))? 1'b0 : 1'b1;
// num 97-576
assign char_num_l1_x = ((act_x >= ('d30)) && (act_x <= (H_ACT/15 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/6 + 28) && (act_y <= V_ACT/3 - 28 ))? act_x - 30: 10'd0;
assign char_num_l1_y = ((act_x >= ('d30)) && (act_x <= (H_ACT/15 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/6 + 28) && (act_y <= V_ACT/3 - 28 ))? act_y - V_ACT/6 - 28: 10'd0;
assign ren_num_l1    = ((act_x >= ('d30)) && (act_x <= (H_ACT/15 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/6 + 28) && (act_y <= V_ACT/3 - 28 ))? 1'b0 : 1'b1;

assign char_num_l2_x = ((act_x >= (H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/6 + 28) && (act_y <= V_ACT/3 - 28 ))? act_x - H_ACT/15 - H_ACT/15 - 30: 10'd0;
assign char_num_l2_y = ((act_x >= (H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/6 + 28) && (act_y <= V_ACT/3 - 28 ))? act_y - V_ACT/6 - 28: 10'd0;
assign ren_num_l2    = ((act_x >= (H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/6 + 28) && (act_y <= V_ACT/3 - 28 ))? 1'b0 : 1'b1;

assign char_num_l3_x = ((act_x >= (H_ACT/5 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 - 'd30)) && (act_y >= V_ACT/6 + 28) && (act_y <= V_ACT/3 - 28 ))? act_x - H_ACT/5 - H_ACT/15 - 30: 10'd0;
assign char_num_l3_y = ((act_x >= (H_ACT/5 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 - 'd30)) && (act_y >= V_ACT/6 + 28) && (act_y <= V_ACT/3 - 28 ))? act_y - V_ACT/6 - 28: 10'd0;
assign ren_num_l3    = ((act_x >= (H_ACT/5 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 - 'd30)) && (act_y >= V_ACT/6 + 28) && (act_y <= V_ACT/3 - 28 ))? 1'b0 : 1'b1;

assign char_num_l4_x = ((act_x >= ('d30)) && (act_x <= (H_ACT/15 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/3 + 28) && (act_y <= V_ACT/6 + V_ACT/3 - 28 ))? act_x - 30: 10'd0;
assign char_num_l4_y = ((act_x >= ('d30)) && (act_x <= (H_ACT/15 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/3 + 28) && (act_y <= V_ACT/6 + V_ACT/3 - 28 ))? act_y - V_ACT/3 - 28: 10'd0;
assign ren_num_l4    = ((act_x >= ('d30)) && (act_x <= (H_ACT/15 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/3 + 28) && (act_y <= V_ACT/6 + V_ACT/3 - 28 ))? 1'b0 : 1'b1;

assign char_num_l5_x = ((act_x >= (H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/3 + 28) && (act_y <= V_ACT/6 + V_ACT/3 - 28 ))? act_x - H_ACT/15 - H_ACT/15 - 30: 10'd0;
assign char_num_l5_y = ((act_x >= (H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/3 + 28) && (act_y <= V_ACT/6 + V_ACT/3 - 28 ))? act_y - V_ACT/3 - 28: 10'd0;
assign ren_num_l5    = ((act_x >= (H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/3 + 28) && (act_y <= V_ACT/6 + V_ACT/3 - 28 ))? 1'b0 : 1'b1;

assign char_num_l6_x = ((act_x >= (H_ACT/5 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 - 'd30)) && (act_y >= V_ACT/3 + 28) && (act_y <= V_ACT/6 + V_ACT/3 - 28 ))? act_x - H_ACT/5 - H_ACT/15 - 30: 10'd0;
assign char_num_l6_y = ((act_x >= (H_ACT/5 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 - 'd30)) && (act_y >= V_ACT/3 + 28) && (act_y <= V_ACT/6 + V_ACT/3 - 28 ))? act_y - V_ACT/3 - 28: 10'd0;
assign ren_num_l6    = ((act_x >= (H_ACT/5 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 - 'd30)) && (act_y >= V_ACT/3 + 28) && (act_y <= V_ACT/6 + V_ACT/3 - 28 ))? 1'b0 : 1'b1;

assign char_num_l7_x = ((act_x >= ('d30)) && (act_x <= (H_ACT/15 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/2 + 28) && (act_y <= V_ACT/3 + V_ACT/3 - 28 ))? act_x - 30: 10'd0;
assign char_num_l7_y = ((act_x >= ('d30)) && (act_x <= (H_ACT/15 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/2 + 28) && (act_y <= V_ACT/3 + V_ACT/3 - 28 ))? act_y - V_ACT/2 - 28: 10'd0;
assign ren_num_l7    = ((act_x >= ('d30)) && (act_x <= (H_ACT/15 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/2 + 28) && (act_y <= V_ACT/3 + V_ACT/3 - 28 ))? 1'b0 : 1'b1;

assign char_num_l8_x = ((act_x >= (H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/2 + 28) && (act_y <= V_ACT/3 + V_ACT/3 - 28 ))? act_x - H_ACT/15 - H_ACT/15 - 30: 10'd0;
assign char_num_l8_y = ((act_x >= (H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/2 + 28) && (act_y <= V_ACT/3 + V_ACT/3 - 28 ))? act_y - V_ACT/2 - 28: 10'd0;
assign ren_num_l8    = ((act_x >= (H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/2 + 28) && (act_y <= V_ACT/3 + V_ACT/3 - 28 ))? 1'b0 : 1'b1;

assign char_num_l9_x = ((act_x >= (H_ACT/5 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 - 'd30)) && (act_y >= V_ACT/2 + 28) && (act_y <= V_ACT/3 + V_ACT/3 - 28 ))? act_x - H_ACT/5 - H_ACT/15 - 30: 10'd0;
assign char_num_l9_y = ((act_x >= (H_ACT/5 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 - 'd30)) && (act_y >= V_ACT/2 + 28) && (act_y <= V_ACT/3 + V_ACT/3 - 28 ))? act_y - V_ACT/2 - 28: 10'd0;
assign ren_num_l9    = ((act_x >= (H_ACT/5 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 - 'd30)) && (act_y >= V_ACT/2 + 28) && (act_y <= V_ACT/3 + V_ACT/3 - 28 ))? 1'b0 : 1'b1;

assign char_num_l0_x = ((act_x >= (H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/3 + V_ACT/3 + 28) && (act_y <= V_ACT/3 + V_ACT/2 - 28 ))? act_x - H_ACT/15 - H_ACT/15 - 30: 10'd0;
assign char_num_l0_y = ((act_x >= (H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/3 + V_ACT/3 + 28) && (act_y <= V_ACT/3 + V_ACT/2 - 28 ))? act_y - V_ACT/3 - V_ACT/3 - 28: 10'd0;
assign ren_num_l0    = ((act_x >= (H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/3 + V_ACT/3 + 28) && (act_y <= V_ACT/3 + V_ACT/2 - 28 ))? 1'b0 : 1'b1;

assign char_num_r1_x = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/6 + 28) && (act_y <= V_ACT/3 - 28 ))? act_x - H_ACT/5 - H_ACT/5 - H_ACT/5 - 30: 10'd0;
assign char_num_r1_y = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/6 + 28) && (act_y <= V_ACT/3 - 28 ))? act_y - V_ACT/6 - 28: 10'd0;
assign ren_num_r1    = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/6 + 28) && (act_y <= V_ACT/3 - 28 ))? 1'b0 : 1'b1;

assign char_num_r2_x = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/6 + 28) && (act_y <= V_ACT/3 - 28 ))? act_x - H_ACT/5 - H_ACT/5 - H_ACT/5 - H_ACT/15 - H_ACT/15 - 30: 10'd0;
assign char_num_r2_y = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/6 + 28) && (act_y <= V_ACT/3 - 28 ))? act_y - V_ACT/6 - 28: 10'd0;
assign ren_num_r2    = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/6 + 28) && (act_y <= V_ACT/3 - 28 ))? 1'b0 : 1'b1;

assign char_num_r3_x = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT - 'd30)) && (act_y >= V_ACT/6 + 28) && (act_y <= V_ACT/3 - 28 ))? act_x - H_ACT/5 - H_ACT/5 - H_ACT/5 - H_ACT/5 - H_ACT/15 - 30: 10'd0;
assign char_num_r3_y = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT - 'd30)) && (act_y >= V_ACT/6 + 28) && (act_y <= V_ACT/3 - 28 ))? act_y - V_ACT/6 - 28: 10'd0;
assign ren_num_r3    = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT - 'd30)) && (act_y >= V_ACT/6 + 28) && (act_y <= V_ACT/3 - 28 ))? 1'b0 : 1'b1;

assign char_num_r4_x = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/3 + 28) && (act_y <= V_ACT/6 + V_ACT/3 - 28 ))? act_x - H_ACT/5 - H_ACT/5 - H_ACT/5 - 30: 10'd0;
assign char_num_r4_y = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/3 + 28) && (act_y <= V_ACT/6 + V_ACT/3 - 28 ))? act_y - V_ACT/3 - 28: 10'd0;
assign ren_num_r4    = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/3 + 28) && (act_y <= V_ACT/6 + V_ACT/3 - 28 ))? 1'b0 : 1'b1;

assign char_num_r5_x = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/3 + 28) && (act_y <= V_ACT/6 + V_ACT/3 - 28 ))? act_x - H_ACT/5 - H_ACT/5 - H_ACT/5 - H_ACT/15 - H_ACT/15 - 30: 10'd0;
assign char_num_r5_y = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/3 + 28) && (act_y <= V_ACT/6 + V_ACT/3 - 28 ))? act_y - V_ACT/3 - 28: 10'd0;
assign ren_num_r5    = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/3 + 28) && (act_y <= V_ACT/6 + V_ACT/3 - 28 ))? 1'd0: 1'd1;

assign char_num_r6_x = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT - 'd30)) && (act_y >= V_ACT/3 + 28) && (act_y <= V_ACT/6 + V_ACT/3 - 28 ))? act_x - H_ACT/5 - H_ACT/5 - H_ACT/5 - H_ACT/5 - H_ACT/15 - 30: 10'd0;
assign char_num_r6_y = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT - 'd30)) && (act_y >= V_ACT/3 + 28) && (act_y <= V_ACT/6 + V_ACT/3 - 28 ))? act_y - V_ACT/3 - 28: 10'd0;
assign ren_num_r6    = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT - 'd30)) && (act_y >= V_ACT/3 + 28) && (act_y <= V_ACT/6 + V_ACT/3 - 28 ))? 1'b0 : 1'b1;

assign char_num_r7_x = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/2 + 28) && (act_y <= V_ACT/3 + V_ACT/3 - 28 ))? act_x - H_ACT/5 - H_ACT/5 - H_ACT/5 - 30: 10'd0;
assign char_num_r7_y = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/2 + 28) && (act_y <= V_ACT/3 + V_ACT/3 - 28 ))? act_y - V_ACT/2 - 28: 10'd0;
assign ren_num_r7    = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/2 + 28) && (act_y <= V_ACT/3 + V_ACT/3 - 28 ))? 1'b0 : 1'b1;

assign char_num_r8_x = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/2 + 28) && (act_y <= V_ACT/3 + V_ACT/3 - 28 ))? act_x - H_ACT/5 - H_ACT/5 - H_ACT/5 - H_ACT/15 - H_ACT/15 - 30: 10'd0;
assign char_num_r8_y = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/2 + 28) && (act_y <= V_ACT/3 + V_ACT/3 - 28 ))? act_y - V_ACT/2 - 28: 10'd0;
assign ren_num_r8    = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/2 + 28) && (act_y <= V_ACT/3 + V_ACT/3 - 28 ))? 1'b0 : 1'b1;

assign char_num_r9_x = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT - 'd30)) && (act_y >= V_ACT/2 + 28) && (act_y <= V_ACT/3 + V_ACT/3 - 28 ))? act_x - H_ACT/5 - H_ACT/5 - H_ACT/5 - H_ACT/5 - H_ACT/15 - 30: 10'd0;
assign char_num_r9_y = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT - 'd30)) && (act_y >= V_ACT/2 + 28) && (act_y <= V_ACT/3 + V_ACT/3 - 28 ))? act_y - V_ACT/2 - 28: 10'd0;
assign ren_num_r9    = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT - 'd30)) && (act_y >= V_ACT/2 + 28) && (act_y <= V_ACT/3 + V_ACT/3 - 28 ))? 1'b0 : 1'b1;

assign char_num_r0_x = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/3 + V_ACT/3 + 28) && (act_y <= V_ACT/3 + V_ACT/2 - 28 ))? act_x - H_ACT/5 - H_ACT/5 - H_ACT/5 - H_ACT/15 - H_ACT/15 - 30: 10'd0;
assign char_num_r0_y = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/3 + V_ACT/3 + 28) && (act_y <= V_ACT/3 + V_ACT/2 - 28 ))? act_y - V_ACT/3 - V_ACT/3 - 28: 10'd0;
assign ren_num_r0    = ((act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 + H_ACT/15 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/5 + H_ACT/15 - 'd30)) && (act_y >= V_ACT/3 + V_ACT/3 + 28) && (act_y <= V_ACT/3 + V_ACT/2 - 28 ))? 1'b0 : 1'b1;

wire [31:0] fre_;
wire [9:0] wr_addr1,wr_addr2,wr_addr3;
reg [9:0] wr_addr;
assign fre_ = (targe_fre >= 'd1000) ? targe_fre / 1000 : targe_fre;
wire [4:0] first_1,second_1,third_1,first_2,second_2,third_2;
wire [4:0] first,second,third;
wire [9:0] char_num_vpp_x,char_num_vpp_y,char_num_fre_x,char_num_fre_y,char_vpp_x,char_vpp_y,char_fre_x,char_fre_y;
wire [9:0] char_targe_x,char_targe_y;
reg [4:0] first_,second_,third_;
wire ren_num_vpp,ren_num_fre,ren_vpp,ren_fre;
wire ren_targe;
wire [23:0] rom_data1,rom_data2,rom_data3,rom_data4,rom_data5,rom_data6;
wire [71:0] rom_data_targe_fre,rom_data_targe_vpp;
wire [71:0] ram_data;
assign char_num_vpp_x = ((act_x >= (H_ACT/5 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 - 'd103)) && (act_y >= V_ACT/3 + V_ACT/2 + 28) && (act_y <= V_ACT - 28 ))? act_x - H_ACT/5 - 30: 10'd0;
assign char_num_vpp_y = ((act_x >= (H_ACT/5 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 - 'd103)) && (act_y >= V_ACT/3 + V_ACT/2 + 28) && (act_y <= V_ACT - 28 ))? act_y - V_ACT/3 - V_ACT/2 - 28: 10'd0;
assign ren_num_vpp    = ((act_x >= (H_ACT/5 + 'd30)) && (act_x <= (H_ACT/5 + H_ACT/5 - 'd103)) && (act_y >= V_ACT/3 + V_ACT/2 + 28) && (act_y <= V_ACT - 28 ))? 1'b0 : 1'b1;

assign char_num_fre_x = ((act_x >= (H_ACT - H_ACT/5 + 'd30)) && (act_x <= (H_ACT - 'd103)) && (act_y >= V_ACT/3 + V_ACT/2 + 28) && (act_y <= V_ACT - 28 ))? act_x - H_ACT + H_ACT/5 - 30: 10'd0;
assign char_num_fre_y = ((act_x >= (H_ACT - H_ACT/5 + 'd30)) && (act_x <= (H_ACT - 'd103)) && (act_y >= V_ACT/3 + V_ACT/2 + 28) && (act_y <= V_ACT - 28 ))? act_y - V_ACT/3 - V_ACT/2 - 28: 10'd0;
assign ren_num_fre    = ((act_x >= (H_ACT - H_ACT/5 + 'd30)) && (act_x <= (H_ACT - 'd103)) && (act_y >= V_ACT/3 + V_ACT/2 + 28) && (act_y <= V_ACT - 28 ))? 1'b0 : 1'b1;

assign char_vpp_x = ((act_x >= ('d55)) && (act_x <= (H_ACT/5 - 'd55)) && (act_y >= V_ACT/3 + V_ACT/2 + 28) && (act_y <= V_ACT - 28 ))? act_x - 55: 10'd0;
assign char_vpp_y = ((act_x >= ('d55)) && (act_x <= (H_ACT/5 - 'd55)) && (act_y >= V_ACT/3 + V_ACT/2 + 28) && (act_y <= V_ACT - 28 ))? act_y - V_ACT/3 - V_ACT/2 - 28: 10'd0;
assign ren_vpp    = ((act_x >= ('d55)) && (act_x <= (H_ACT/5 - 'd55)) && (act_y >= V_ACT/3 + V_ACT/2 + 28) && (act_y <= V_ACT - 28 ))? 1'b0 : 1'b1;

assign char_fre_x = ((act_x >= (H_ACT - H_ACT/5 - H_ACT/5 + 'd55)) && (act_x <= (H_ACT - H_ACT/5 - 'd55)) && (act_y >= V_ACT/3 + V_ACT/2 + 28) && (act_y <= V_ACT - 28 ))? act_x - H_ACT + H_ACT/5 + H_ACT/5 - 55: 10'd0;
assign char_fre_y = ((act_x >= (H_ACT - H_ACT/5 - H_ACT/5 + 'd55)) && (act_x <= (H_ACT - H_ACT/5 - 'd55)) && (act_y >= V_ACT/3 + V_ACT/2 + 28) && (act_y <= V_ACT - 28 ))? act_y - V_ACT/3 - V_ACT/2 - 28: 10'd0;
assign ren_fre    = ((act_x >= (H_ACT - H_ACT/5 - H_ACT/5 + 'd55)) && (act_x <= (H_ACT - H_ACT/5 - 'd55)) && (act_y >= V_ACT/3 + V_ACT/2 + 28) && (act_y <= V_ACT - 28 ))? 1'b0 : 1'b1;

assign ren_targe = (ren_num_vpp && ren_num_fre) ? 1'b1 : 1'b0;

assign char_targe_x = (!ren_num_vpp)? char_num_vpp_x :
                      (!ren_num_fre)? char_num_fre_x : 10'd0;

assign char_targe_y = (!ren_num_vpp)? char_num_vpp_y :
                      (!ren_num_fre)? char_num_fre_y : 10'd0;

data_sep u_data_sep_vpp(
    .data(fre_),
    .first(first_1),	
	.second(second_1),
	.third(third_1)
);

data_sep u_data_sep_fre(
    .data(targe_vpp),
    .first(first_2),	
	.second(second_2),
	.third(third_2)
);




assign wr_addr1 = char_targe_y + first_1 * 12'd48;
assign wr_addr2 = char_targe_y + second_1 * 12'd48;
assign wr_addr3 = char_targe_y + third_1 * 12'd48;

wire [9:0] wr_addr4,wr_addr5,wr_addr6;
assign wr_addr4 = char_targe_y + first_2 * 12'd48;
assign wr_addr5 = char_targe_y + second_2 * 12'd48;
assign wr_addr6 = char_targe_y + third_2 * 12'd48;

// num_rom num_rom_m3(
// 	.addr(wr_addr1),
// 	.clk(pix_clk),
// 	.rst(1'b0),
// 	.rd_data(rom_data1)
// 	);

// num_rom num_rom_m4(
// 	.addr(wr_addr2),
// 	.clk(pix_clk),
// 	.rst(1'b0),
// 	.rd_data(rom_data2)
// 	);

// num_rom num_rom_m5(
// 	.addr(wr_addr3),
// 	.clk(pix_clk),
// 	.rst(1'b0),
// 	.rd_data(rom_data3)
// 	);

assign rom_data1 = data1[wr_addr1];
assign rom_data2 = data1[wr_addr2];
assign rom_data3 = data1[wr_addr3];
assign rom_data4 = data1[wr_addr4];
assign rom_data5 = data1[wr_addr5];
assign rom_data6 = data1[wr_addr6];
assign rom_data_targe_fre = {rom_data1, rom_data2, rom_data3};
assign rom_data_targe_vpp = {rom_data4, rom_data5, rom_data6};


assign char_x = (!ren1) ? char1_x :
                (!ren2) ? char2_x : 
                (!ren_vpp) ? char_vpp_x : 
                (!ren_fre) ? char_fre_x : 
                (!ren_num_l0) ? char_num_l0_x : 
                (!ren_num_l1) ? char_num_l1_x : 
                (!ren_num_l2) ? char_num_l2_x :  
                (!ren_num_l3) ? char_num_l3_x : 
                (!ren_num_l4) ? char_num_l4_x : 
                (!ren_num_l5) ? char_num_l5_x : 
                (!ren_num_l6) ? char_num_l6_x : 
                (!ren_num_l7) ? char_num_l7_x : 
                (!ren_num_l8) ? char_num_l8_x : 
                (!ren_num_l9) ? char_num_l9_x :
                (!ren_num_r0) ? char_num_r0_x :
                (!ren_num_r1) ? char_num_r1_x : 
                (!ren_num_r2) ? char_num_r2_x :  
                (!ren_num_r3) ? char_num_r3_x : 
                (!ren_num_r4) ? char_num_r4_x : 
                (!ren_num_r5) ? char_num_r5_x : 
                (!ren_num_r6) ? char_num_r6_x : 
                (!ren_num_r7) ? char_num_r7_x : 
                (!ren_num_r8) ? char_num_r8_x : 
                (!ren_num_r9) ? char_num_r9_x :  10'd0;

assign char_y = (!ren1) ? char1_y :
                (!ren2) ? char2_y + 'd48 : 
                (!ren_vpp) ? char_vpp_y + 'd576 : 
                (!ren_fre) ? char_fre_y + 'd624 : 
                (!ren_num_l0) ? char_num_l0_y + 'd96 : 
                (!ren_num_l1) ? char_num_l1_y + 'd144 : 
                (!ren_num_l2) ? char_num_l2_y + 'd192 : 
                (!ren_num_l3) ? char_num_l3_y + 'd240 : 
                (!ren_num_l4) ? char_num_l4_y + 'd288 : 
                (!ren_num_l5) ? char_num_l5_y + 'd336 : 
                (!ren_num_l6) ? char_num_l6_y + 'd384 : 
                (!ren_num_l7) ? char_num_l7_y + 'd432 : 
                (!ren_num_l8) ? char_num_l8_y + 'd480 :
                (!ren_num_l9) ? char_num_l9_y + 'd528 : 
                (!ren_num_r0) ? char_num_r0_y + 'd96 :
                (!ren_num_r1) ? char_num_r1_y + 'd144 : 
                (!ren_num_r2) ? char_num_r2_y + 'd192 : 
                (!ren_num_r3) ? char_num_r3_y + 'd240 : 
                (!ren_num_r4) ? char_num_r4_y + 'd288 : 
                (!ren_num_r5) ? char_num_r5_y + 'd336 : 
                (!ren_num_r6) ? char_num_r6_y + 'd384 : 
                (!ren_num_r7) ? char_num_r7_y + 'd432 : 
                (!ren_num_r8) ? char_num_r8_y + 'd480 :
                (!ren_num_r9) ? char_num_r9_y + 'd528 : 10'd0;

assign ren = (ren1 & ren2 & ren_vpp & ren_fre & ren_num_l0 & ren_num_l1 & ren_num_l2 & ren_num_l3 & ren_num_l4 & ren_num_l5 & ren_num_l6 & ren_num_l7 & ren_num_l8 & ren_num_l9 & ren_num_r0 & ren_num_r1 & ren_num_r2 & ren_num_r3 & ren_num_r4 & ren_num_r5 & ren_num_r6 & ren_num_r7 & ren_num_r8 & ren_num_r9) ? 1'b1 : 1'b0;

always@(posedge pix_clk)
begin
	if(ren1 == 1'b0 || ren2 == 1'b0 )
		if(rom_data['d96 - char_x] == 1)
			rgb_data <= 15'h0000;
		else
			rgb_data <= 15'hffff;
    else if(ren_vpp == 1'b0 || ren_fre == 1'b0)
		if(rom_data['d72 - char_x] == 1)
			rgb_data <= 15'h0000;
		else
			rgb_data <= 15'hffff;
    else if(ren_num_l0 == 1'b0 ||ren_num_l1 == 1'b0 || ren_num_l2 == 1'b0 || ren_num_l3 == 1'b0 || ren_num_l4 == 1'b0 || ren_num_l5 == 1'b0 || ren_num_l6 == 1'b0 || ren_num_l7 == 1'b0 || ren_num_l8 == 1'b0 || ren_num_l9 == 1'b0 || ren_num_r0 == 1'b0 || ren_num_r1 == 1'b0 || ren_num_r2 == 1'b0 || ren_num_r3 == 1'b0 || ren_num_r4 == 1'b0 || ren_num_r5 == 1'b0 || ren_num_r6 == 1'b0 || ren_num_r7 == 1'b0 || ren_num_r8 == 1'b0 || ren_num_r9 == 1'b0)
		if(rom_data['d24 - char_x] == 1)
			rgb_data <= 15'h0000;
		else
			rgb_data <= 15'hffff;
    else if(ren_num_fre == 1'b0)
		if(rom_data_targe_fre['d72 - char_targe_x] == 1)
			rgb_data <= 15'h0000;
		else
			rgb_data <= 15'hffff;
    else if(ren_num_vpp == 1'b0)
		if(rom_data_targe_vpp['d72 - char_targe_x] == 1)
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
reg     [23:0] data1        [479:0]  ;           //
always @(*)begin
    data1[0]   = 24'h000000;
    data1[1]   = 24'h000000;
    data1[2]   = 24'h000000;
    data1[3]   = 24'h000000;
    data1[4]   = 24'h000000;
    data1[5]   = 24'h000000;
    data1[6]   = 24'h000000;
    data1[7]   = 24'h007E00;
    data1[8]   = 24'h01FF80;
    data1[9]   = 24'h07FFC0;
    data1[10]  = 24'h07FFE0;
    data1[11]  = 24'h0FE7F0;
    data1[12]  = 24'h1F83F0;
    data1[13]  = 24'h1F81F8;
    data1[14]  = 24'h3F00F8;
    data1[15]  = 24'h3F00F8;
    data1[16]  = 24'h3E00FC;
    data1[17]  = 24'h7E007C;
    data1[18]  = 24'h7E007C;
    data1[19]  = 24'h7E007C;
    data1[20]  = 24'h7C007C;
    data1[21]  = 24'h7C007C;
    data1[22]  = 24'h7C007C;
    data1[23]  = 24'h7C007C;
    data1[24]  = 24'h7C007C;
    data1[25]  = 24'h7C007C;
    data1[26]  = 24'h7C007C;
    data1[27]  = 24'h7C007C;
    data1[28]  = 24'h7C007C;
    data1[29]  = 24'h7E007C;
    data1[30]  = 24'h7E007C;
    data1[31]  = 24'h3E00FC;
    data1[32]  = 24'h3F00F8;
    data1[33]  = 24'h3F00F8;
    data1[34]  = 24'h1F81F8;
    data1[35]  = 24'h1FC3F0;
    data1[36]  = 24'h0FFFF0;
    data1[37]  = 24'h07FFE0;
    data1[38]  = 24'h03FFC0;
    data1[39]  = 24'h01FF80;
    data1[40]  = 24'h003C00;
    data1[41]  = 24'h000000;
    data1[42]  = 24'h000000;
    data1[43]  = 24'h000000;
    data1[44]  = 24'h000000;
    data1[45]  = 24'h000000;
    data1[46]  = 24'h000000;
    data1[47]  = 24'h000000;
    data1[48]  = 24'h000000;
    data1[49]  = 24'h000000;
    data1[50]  = 24'h000000;
    data1[51]  = 24'h000000;
    data1[52]  = 24'h000000;
    data1[53]  = 24'h000000;
    data1[54]  = 24'h000000;
    data1[55]  = 24'h001E00;
    data1[56]  = 24'h001E00;
    data1[57]  = 24'h003E00;
    data1[58]  = 24'h007E00;
    data1[59]  = 24'h00FE00;
    data1[60]  = 24'h01FE00;
    data1[61]  = 24'h03FE00;
    data1[62]  = 24'h0FFE00;
    data1[63]  = 24'h0FFE00;
    data1[64]  = 24'h0FBE00;
    data1[65]  = 24'h0E3E00;
    data1[66]  = 24'h0C3E00;
    data1[67]  = 24'h003E00;
    data1[68]  = 24'h003E00;
    data1[69]  = 24'h003E00;
    data1[70]  = 24'h003E00;
    data1[71]  = 24'h003E00;
    data1[72]  = 24'h003E00;
    data1[73]  = 24'h003E00;
    data1[74]  = 24'h003E00;
    data1[75]  = 24'h003E00;
    data1[76]  = 24'h003E00;
    data1[77]  = 24'h003E00;
    data1[78]  = 24'h003E00;
    data1[79]  = 24'h003E00;
    data1[80]  = 24'h003E00;
    data1[81]  = 24'h003E00;
    data1[82]  = 24'h003E00;
    data1[83]  = 24'h003E00;
    data1[84]  = 24'h003E00;
    data1[85]  = 24'h003E00;
    data1[86]  = 24'h003E00;
    data1[87]  = 24'h003E00;
    data1[88]  = 24'h000000;
    data1[89]  = 24'h000000;
    data1[90]  = 24'h000000;
    data1[91]  = 24'h000000;
    data1[92]  = 24'h000000;
    data1[93]  = 24'h000000;
    data1[94]  = 24'h000000;
    data1[95]  = 24'h000000;
    data1[96]  = 24'h000000;
    data1[97]  = 24'h000000;
    data1[98]  = 24'h000000;
    data1[99]  = 24'h000000;
    data1[100] = 24'h000000;
    data1[101] = 24'h000000;
    data1[102] = 24'h000000;
    data1[103] = 24'h00FF00;
    data1[104] = 24'h03FFC0;
    data1[105] = 24'h07FFE0;
    data1[106] = 24'h0FFFF0;
    data1[107] = 24'h1FE7F0;
    data1[108] = 24'h3F81F8;
    data1[109] = 24'h3E01F8;
    data1[110] = 24'h7E00F8;
    data1[111] = 24'h7C00FC;
    data1[112] = 24'h1C00FC;
    data1[113] = 24'h0000F8;
    data1[114] = 24'h0000F8;
    data1[115] = 24'h0001F8;
    data1[116] = 24'h0001F0;
    data1[117] = 24'h0003F0;
    data1[118] = 24'h0003E0;
    data1[119] = 24'h0007E0;
    data1[120] = 24'h000FC0;
    data1[121] = 24'h001F80;
    data1[122] = 24'h001F80;
    data1[123] = 24'h003F00;
    data1[124] = 24'h007E00;
    data1[125] = 24'h00FC00;
    data1[126] = 24'h01FC00;
    data1[127] = 24'h01F800;
    data1[128] = 24'h03F000;
    data1[129] = 24'h07E000;
    data1[130] = 24'h0FC000;
    data1[131] = 24'h1F8000;
    data1[132] = 24'h3FFFFC;
    data1[133] = 24'h3FFFFC;
    data1[134] = 24'h3FFFFC;
    data1[135] = 24'h7FFFFC;
    data1[136] = 24'h000000;
    data1[137] = 24'h000000;
    data1[138] = 24'h000000;
    data1[139] = 24'h000000;
    data1[140] = 24'h000000;
    data1[141] = 24'h000000;
    data1[142] = 24'h000000;
    data1[143] = 24'h000000;
    data1[144] = 24'h000000;
    data1[145] = 24'h000000;
    data1[146] = 24'h000000;
    data1[147] = 24'h000000;
    data1[148] = 24'h000000;
    data1[149] = 24'h000000;
    data1[150] = 24'h000000;
    data1[151] = 24'h007E00;
    data1[152] = 24'h03FFC0;
    data1[153] = 24'h07FFE0;
    data1[154] = 24'h0FFFF0;
    data1[155] = 24'h0FC7F8;
    data1[156] = 24'h1F81F8;
    data1[157] = 24'h3F00F8;
    data1[158] = 24'h3E00F8;
    data1[159] = 24'h3E00FC;
    data1[160] = 24'h0C00F8;
    data1[161] = 24'h0000F8;
    data1[162] = 24'h0000F8;
    data1[163] = 24'h0001F0;
    data1[164] = 24'h0007F0;
    data1[165] = 24'h007FE0;
    data1[166] = 24'h007FC0;
    data1[167] = 24'h007FC0;
    data1[168] = 24'h007FE0;
    data1[169] = 24'h0007F0;
    data1[170] = 24'h0001F8;
    data1[171] = 24'h0000F8;
    data1[172] = 24'h0000FC;
    data1[173] = 24'h0000FC;
    data1[174] = 24'h00007C;
    data1[175] = 24'h3C00FC;
    data1[176] = 24'h7C00FC;
    data1[177] = 24'h3E00FC;
    data1[178] = 24'h3F01F8;
    data1[179] = 24'h3F83F8;
    data1[180] = 24'h1FFFF0;
    data1[181] = 24'h0FFFE0;
    data1[182] = 24'h07FFC0;
    data1[183] = 24'h03FF80;
    data1[184] = 24'h007C00;
    data1[185] = 24'h000000;
    data1[186] = 24'h000000;
    data1[187] = 24'h000000;
    data1[188] = 24'h000000;
    data1[189] = 24'h000000;
    data1[190] = 24'h000000;
    data1[191] = 24'h000000;
    data1[192] = 24'h000000;
    data1[193] = 24'h000000;
    data1[194] = 24'h000000;
    data1[195] = 24'h000000;
    data1[196] = 24'h000000;
    data1[197] = 24'h000000;
    data1[198] = 24'h000000;
    data1[199] = 24'h0001E0;
    data1[200] = 24'h0003E0;
    data1[201] = 24'h0003E0;
    data1[202] = 24'h0007E0;
    data1[203] = 24'h000FE0;
    data1[204] = 24'h000FE0;
    data1[205] = 24'h001FE0;
    data1[206] = 24'h003FE0;
    data1[207] = 24'h003FE0;
    data1[208] = 24'h007FE0;
    data1[209] = 24'h00FFE0;
    data1[210] = 24'h01FBE0;
    data1[211] = 24'h01F3E0;
    data1[212] = 24'h03F3E0;
    data1[213] = 24'h07E3E0;
    data1[214] = 24'h07C3E0;
    data1[215] = 24'h0FC3E0;
    data1[216] = 24'h1F83E0;
    data1[217] = 24'h1F03E0;
    data1[218] = 24'h3E03E0;
    data1[219] = 24'h7E03E0;
    data1[220] = 24'h7C03E0;
    data1[221] = 24'hFFFFFF;
    data1[222] = 24'hFFFFFF;
    data1[223] = 24'hFFFFFF;
    data1[224] = 24'hFFFFFF;
    data1[225] = 24'h0003E0;
    data1[226] = 24'h0003E0;
    data1[227] = 24'h0003E0;
    data1[228] = 24'h0003E0;
    data1[229] = 24'h0003E0;
    data1[230] = 24'h0003E0;
    data1[231] = 24'h0003E0;
    data1[232] = 24'h000000;
    data1[233] = 24'h000000;
    data1[234] = 24'h000000;
    data1[235] = 24'h000000;
    data1[236] = 24'h000000;
    data1[237] = 24'h000000;
    data1[238] = 24'h000000;
    data1[239] = 24'h000000;
    data1[240] = 24'h000000;
    data1[241] = 24'h000000;
    data1[242] = 24'h000000;
    data1[243] = 24'h000000;
    data1[244] = 24'h000000;
    data1[245] = 24'h000000;
    data1[246] = 24'h000000;
    data1[247] = 24'h000000;
    data1[248] = 24'h0FFFF8;
    data1[249] = 24'h0FFFF8;
    data1[250] = 24'h0FFFF8;
    data1[251] = 24'h0FFFF8;
    data1[252] = 24'h0F8000;
    data1[253] = 24'h1F0000;
    data1[254] = 24'h1F0000;
    data1[255] = 24'h1F0000;
    data1[256] = 24'h1F0000;
    data1[257] = 24'h1F0000;
    data1[258] = 24'h3EFE00;
    data1[259] = 24'h3FFF80;
    data1[260] = 24'h3FFFE0;
    data1[261] = 24'h3FFFF0;
    data1[262] = 24'h7F87F0;
    data1[263] = 24'h7E03F8;
    data1[264] = 24'h7C01F8;
    data1[265] = 24'h0000FC;
    data1[266] = 24'h0000FC;
    data1[267] = 24'h00007C;
    data1[268] = 24'h00007C;
    data1[269] = 24'h00007C;
    data1[270] = 24'h0000FC;
    data1[271] = 24'h7800FC;
    data1[272] = 24'hF800FC;
    data1[273] = 24'hFC00F8;
    data1[274] = 24'h7C01F8;
    data1[275] = 24'h7E03F8;
    data1[276] = 24'h3FFFF0;
    data1[277] = 24'h3FFFE0;
    data1[278] = 24'h1FFFC0;
    data1[279] = 24'h07FF00;
    data1[280] = 24'h00FC00;
    data1[281] = 24'h000000;
    data1[282] = 24'h000000;
    data1[283] = 24'h000000;
    data1[284] = 24'h000000;
    data1[285] = 24'h000000;
    data1[286] = 24'h000000;
    data1[287] = 24'h000000;
    data1[288] = 24'h000000;
    data1[289] = 24'h000000;
    data1[290] = 24'h000000;
    data1[291] = 24'h000000;
    data1[292] = 24'h000000;
    data1[293] = 24'h000000;
    data1[294] = 24'h000000;
    data1[295] = 24'h000FC0;
    data1[296] = 24'h000FC0;
    data1[297] = 24'h001F80;
    data1[298] = 24'h001F00;
    data1[299] = 24'h003F00;
    data1[300] = 24'h007E00;
    data1[301] = 24'h007C00;
    data1[302] = 24'h00FC00;
    data1[303] = 24'h01F800;
    data1[304] = 24'h01F800;
    data1[305] = 24'h03F000;
    data1[306] = 24'h07E000;
    data1[307] = 24'h07FF80;
    data1[308] = 24'h0FFFE0;
    data1[309] = 24'h0FFFF0;
    data1[310] = 24'h1FFFF8;
    data1[311] = 24'h1FC1FC;
    data1[312] = 24'h3F00FE;
    data1[313] = 24'h3F007E;
    data1[314] = 24'h7E003E;
    data1[315] = 24'h7E003E;
    data1[316] = 24'h7E003F;
    data1[317] = 24'h7E003F;
    data1[318] = 24'h7E003E;
    data1[319] = 24'h7E003E;
    data1[320] = 24'h7E003E;
    data1[321] = 24'h3E007E;
    data1[322] = 24'h3F007E;
    data1[323] = 24'h3F80FC;
    data1[324] = 24'h1FE3F8;
    data1[325] = 24'h0FFFF8;
    data1[326] = 24'h07FFF0;
    data1[327] = 24'h03FFC0;
    data1[328] = 24'h007F00;
    data1[329] = 24'h000000;
    data1[330] = 24'h000000;
    data1[331] = 24'h000000;
    data1[332] = 24'h000000;
    data1[333] = 24'h000000;
    data1[334] = 24'h000000;
    data1[335] = 24'h000000;
    data1[336] = 24'h000000;
    data1[337] = 24'h000000;
    data1[338] = 24'h000000;
    data1[339] = 24'h000000;
    data1[340] = 24'h000000;
    data1[341] = 24'h000000;
    data1[342] = 24'h000000;
    data1[343] = 24'h000000;
    data1[344] = 24'h7FFFFE;
    data1[345] = 24'h7FFFFE;
    data1[346] = 24'h7FFFFE;
    data1[347] = 24'h7FFFFE;
    data1[348] = 24'h00007C;
    data1[349] = 24'h0000FC;
    data1[350] = 24'h0000F8;
    data1[351] = 24'h0001F0;
    data1[352] = 24'h0001F0;
    data1[353] = 24'h0003E0;
    data1[354] = 24'h0003E0;
    data1[355] = 24'h0007C0;
    data1[356] = 24'h0007C0;
    data1[357] = 24'h000F80;
    data1[358] = 24'h000F80;
    data1[359] = 24'h001F00;
    data1[360] = 24'h001F00;
    data1[361] = 24'h003F00;
    data1[362] = 24'h003E00;
    data1[363] = 24'h003E00;
    data1[364] = 24'h007C00;
    data1[365] = 24'h007C00;
    data1[366] = 24'h00FC00;
    data1[367] = 24'h00F800;
    data1[368] = 24'h00F800;
    data1[369] = 24'h01F800;
    data1[370] = 24'h01F800;
    data1[371] = 24'h01F000;
    data1[372] = 24'h03F000;
    data1[373] = 24'h03F000;
    data1[374] = 24'h03F000;
    data1[375] = 24'h03E000;
    data1[376] = 24'h000000;
    data1[377] = 24'h000000;
    data1[378] = 24'h000000;
    data1[379] = 24'h000000;
    data1[380] = 24'h000000;
    data1[381] = 24'h000000;
    data1[382] = 24'h000000;
    data1[383] = 24'h000000;
    data1[384] = 24'h000000;
    data1[385] = 24'h000000;
    data1[386] = 24'h000000;
    data1[387] = 24'h000000;
    data1[388] = 24'h000000;
    data1[389] = 24'h000000;
    data1[390] = 24'h000000;
    data1[391] = 24'h00FC00;
    data1[392] = 24'h03FF80;
    data1[393] = 24'h0FFFE0;  
    data1[394] = 24'h0FFFF0;
    data1[395] = 24'h1FC7F0;
    data1[396] = 24'h3F01F8;
    data1[397] = 24'h3E00F8;
    data1[398] = 24'h3E00F8;
    data1[399] = 24'h3E00F8;
    data1[400] = 24'h3E00F8;
    data1[401] = 24'h3E00F8;
    data1[402] = 24'h3E01F8;
    data1[403] = 24'h3F01F0;
    data1[404] = 24'h1FC7F0;
    data1[405] = 24'h0FFFE0;
    data1[406] = 24'h07FFC0;
    data1[407] = 24'h0FFFC0;
    data1[408] = 24'h1FFFF0;
    data1[409] = 24'h3FEFF8;
    data1[410] = 24'h3F01F8;
    data1[411] = 24'h7E00FC;
    data1[412] = 24'h7C007C;
    data1[413] = 24'h7C007C;
    data1[414] = 24'h7C007C;
    data1[415] = 24'h7C007C;
    data1[416] = 24'h7C007C;
    data1[417] = 24'h7C00FC;
    data1[418] = 24'h7E00FC;
    data1[419] = 24'h7F01F8;
    data1[420] = 24'h3FFFF8;
    data1[421] = 24'h1FFFF0;
    data1[422] = 24'h1FFFE0;
    data1[423] = 24'h07FFC0;
    data1[424] = 24'h00FE00;
    data1[425] = 24'h000000;
    data1[426] = 24'h000000;
    data1[427] = 24'h000000;
    data1[428] = 24'h000000;
    data1[429] = 24'h000000;
    data1[430] = 24'h000000;
    data1[431] = 24'h000000;
    data1[432] = 24'h000000;
    data1[433] = 24'h000000;
    data1[434] = 24'h000000;
    data1[435] = 24'h000000;
    data1[436] = 24'h000000;
    data1[437] = 24'h000000;
    data1[438] = 24'h000000;
    data1[439] = 24'h00FC00;
    data1[440] = 24'h03FF80;
    data1[441] = 24'h0FFFC0;
    data1[442] = 24'h1FFFE0;
    data1[443] = 24'h3FFFF0;
    data1[444] = 24'h3F03F8;
    data1[445] = 24'h7E01F8;
    data1[446] = 24'h7E00FC;
    data1[447] = 24'hFC00FC;
    data1[448] = 24'hFC00FC;
    data1[449] = 24'hFC00FC;
    data1[450] = 24'hFC00FC;
    data1[451] = 24'hFC00FC;
    data1[452] = 24'hFC00F8;
    data1[453] = 24'h7C01F8;
    data1[454] = 24'h7E01F8;
    data1[455] = 24'h7F03F0;
    data1[456] = 24'h3FFFF0;
    data1[457] = 24'h1FFFE0;
    data1[458] = 24'h0FFFE0;
    data1[459] = 24'h07FFC0;
    data1[460] = 24'h000FC0;
    data1[461] = 24'h001F80;
    data1[462] = 24'h001F80;
    data1[463] = 24'h003F00;
    data1[464] = 24'h003F00;
    data1[465] = 24'h007E00;
    data1[466] = 24'h007C00;
    data1[467] = 24'h00FC00;
    data1[468] = 24'h00F800;
    data1[469] = 24'h01F800;
    data1[470] = 24'h03F000;
    data1[471] = 24'h03E000;
    data1[472] = 24'h07E000;
    data1[473] = 24'h000000;
    data1[474] = 24'h000000;
    data1[475] = 24'h000000;
    data1[476] = 24'h000000;
    data1[477] = 24'h000000;
    data1[478] = 24'h000000;
    data1[479] = 24'h000000;
end

endmodule