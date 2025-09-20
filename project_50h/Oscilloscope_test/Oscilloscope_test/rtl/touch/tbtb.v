`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:Meyesemi 
// Engineer: Will
// 
// Create Date: 2023-01-29 20:31  
// Design Name:  
// Module Name: 
// Project Name: 
// Target Devices: Pango
// Tool Versions: 
// Description: 
//      
// Dependencies: 
// 
// Revision:
// Revision 1.0 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define UD #1

module tbtb();
reg rst_n;
reg clk;
reg [9:0]money;
reg set;
reg [1:0]boost;

wire [9:0]remain;
wire yellow;
wire red;

game_count test(
    .clk(clk),
    .rst_n(rst_n),
    .money(money),
    .set(set),
    .boost(boost),
    .remain(remain),
    .yellow(yellow),
    .red(red)
);

initial begin
clk = 0;
rst_n = 0;

set = 0;
boost = 2'b01;            //普通模式
money = 10'd0;

#15 rst_n = 1;
#10 money = 10'd15;
#10 set = 1;             //充值15元
#10 set = 0;
#50 boost = 2'b11;        //体验模式

#30  money = 10'd15;     
#70  set = 1;            //再充值1次
#10  set = 0;
#50  boost = 2'b10;      //畅玩模式
#50  boost = 2'b11;      //第二次进入体验模式，按题意应当无法进入
#10  boost = 2'b00;      //关机
#20  boost = 2'b01;      //重新进入普通模式一直到红灯亮
end
always #5 clk = ~clk;

endmodule