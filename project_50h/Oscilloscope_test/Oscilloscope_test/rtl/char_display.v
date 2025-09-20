module char_display # (
    parameter                            H_ACT = 12'd1920,
    parameter                            V_ACT = 12'd1080
) (
	input                       rst_n,   
	input                       pclk,
	input[15:0]                 wave_color,
	input                       i_hs,    
	input                       i_vs,    
	input                       i_de,	
	input[31:0]                 fre1,	
	input[31:0]                 fre2,	
	input[15:0]                 i_data,  
	output                      o_hs,    
	output                      o_vs,    
	output                      o_de,    
	output[15:0]                o_data
);

wire[11:0] pos_x;
wire[11:0] pos_y;
wire      pos_hs;
wire      pos_vs;
wire      pos_de;
wire[15:0] pos_data;
wire [324:0] rom_data1,rom_data2,rom_data3,rom_data4,rom_data5,rom_data6,rom_data7,rom_data8,rom_data9,rom_data10,rom_data11,rom_data12,rom_data13,rom_data14,rom_data15,rom_data16,rom_data17,rom_data18;
wire [324:0] rom_data;
reg[15:0] v_data;
wire [9:0] char1_x,char2_x,char3_x,char4_x,char5_x,char6_x,char7_x,char8_x,char9_x,char10_x,char11_x,char12_x,char13_x,char14_x,char15_x,char16_x,char17_x,char18_x,char19_x,char20_x,char21_x,char22_x,char23_x,char24_x,char25_x;
wire [9:0] char1_y,char2_y,char3_y,char4_y,char5_y,char6_y,char7_y,char8_y,char9_y,char10_y,char11_y,char12_y,char13_y,char14_y,char15_y,char16_y,char17_y,char18_y,char19_y,char20_y,char21_y,char22_y,char23_y,char24_y,char25_y;
wire       ren1,ren2,ren3,ren4,ren5,ren6,ren7,ren8,ren9,ren10,ren11,ren12,ren13,ren14,ren15,ren16,ren17,ren18,ren19,ren20,ren21,ren22,ren23,ren24,ren25;
wire ren;
wire [9:0] char_y;
//通道1
assign char1_x = (pos_x <= (H_ACT/5 - 30)) && (pos_x >= ('d30) && (pos_y >= 28	   ) && (pos_y <= V_ACT/6 - 28))? pos_x - 30: 10'd0;
assign char1_y = (pos_x <= (H_ACT/5 - 30)) && (pos_x >= ('d30) && (pos_y >= 28	   ) && (pos_y <= V_ACT/6 - 28))? pos_y - 28: 10'd0;
assign ren1    = (pos_x <= (H_ACT/5 - 30)) && (pos_x >= ('d30) && (pos_y >= 28	   ) && (pos_y <= V_ACT/6 - 28))? 1'b0 : 1'b1;
///min1
assign char2_x = (pos_x <= (50)) && (pos_x >= ('d2) && (pos_y >= V_ACT/6 + 2) && (pos_y <= V_ACT/6 + 28))? pos_x - 2: 10'd0;
assign char2_y = (pos_x <= (50)) && (pos_x >= ('d2) && (pos_y >= V_ACT/6 + 2) && (pos_y <= V_ACT/6 + 28))? pos_y - V_ACT/6 - 2: 10'd0;
assign ren2    = (pos_x <= (50)) && (pos_x >= ('d2) && (pos_y >= V_ACT/6 + 2) && (pos_y <= V_ACT/6 + 28))? 1'b0 : 1'b1;
//max1
assign char3_x = (pos_x <= (50)) && (pos_x >= ('d2) && (pos_y >= V_ACT/3 + 2) && (pos_y <= V_ACT/3 + 28))? pos_x - 2: 10'd0;
assign char3_y = (pos_x <= (50)) && (pos_x >= ('d2) && (pos_y >= V_ACT/3 + 2) && (pos_y <= V_ACT/3 + 28))? pos_y - V_ACT/3 - 2: 10'd0;
assign ren3    = (pos_x <= (50)) && (pos_x >= ('d2) && (pos_y >= V_ACT/3 + 2) && (pos_y <= V_ACT/3 + 28))? 1'b0 : 1'b1;
//fre1
assign char4_x = (pos_x <= (50)) && (pos_x >= ('d2) && (pos_y >= V_ACT/2 + 2) && (pos_y <= V_ACT/2 + 28))? pos_x - 2: 10'd0;
assign char4_y = (pos_x <= (50)) && (pos_x >= ('d2) && (pos_y >= V_ACT/2 + 2) && (pos_y <= V_ACT/2 + 28))? pos_y - V_ACT/2 - 2: 10'd0;
assign ren4    = (pos_x <= (50)) && (pos_x >= ('d2) && (pos_y >= V_ACT/2 + 2) && (pos_y <= V_ACT/2 + 28))? 1'b0 : 1'b1;
//vol1
assign char5_x = (pos_x <= (50)) && (pos_x >= ('d2) && (pos_y >= V_ACT/3 + V_ACT/3 + 2) && (pos_y <= V_ACT/3 + V_ACT/3 + 28))? pos_x - 2 : 10'd0;
assign char5_y = (pos_x <= (50)) && (pos_x >= ('d2) && (pos_y >= V_ACT/3 + V_ACT/3 + 2) && (pos_y <= V_ACT/3 + V_ACT/3 + 28))? pos_y - V_ACT + V_ACT/3 - 2: 10'd0;
assign ren5    = (pos_x <= (50)) && (pos_x >= ('d2) && (pos_y >= V_ACT/3 + V_ACT/3 + 2) && (pos_y <= V_ACT/3 + V_ACT/3 + 28))? 1'b0 : 1'b1;
//+/-
assign char6_x = (pos_x <= (H_ACT/5 - 42)) && (pos_x >= ('d42) && (pos_y >= V_ACT - V_ACT/6 + 28) && (pos_y <= V_ACT - 28))? pos_x - 42: 10'd0;
assign char6_y = (pos_x <= (H_ACT/5 - 42)) && (pos_x >= ('d42) && (pos_y >= V_ACT - V_ACT/6 + 28) && (pos_y <= V_ACT - 28))? pos_y - V_ACT + V_ACT/6 - 28: 10'd0;
assign ren6    = (pos_x <= (H_ACT/5 - 42)) && (pos_x >= ('d42) && (pos_y >= V_ACT - V_ACT/6 + 28) && (pos_y <= V_ACT - 28))? 1'b0 : 1'b1;
//通道2
assign char7_x = ((pos_x >= (H_ACT - H_ACT/5 + 'd30)) && (pos_y >= 'd28	   ) && (pos_y <= V_ACT/6 - 28) && (pos_x <= H_ACT - 'd30))? pos_x - H_ACT + H_ACT/5 - 30 : 10'd0;
assign char7_y = ((pos_x >= (H_ACT - H_ACT/5 + 'd30)) && (pos_y >= 'd28	   ) && (pos_y <= V_ACT/6 - 28) && (pos_x <= H_ACT - 'd30))? pos_y - 28: 10'd0;
assign ren7    = ((pos_x >= (H_ACT - H_ACT/5 + 'd30)) && (pos_y >= 'd28	   ) && (pos_y <= V_ACT/6 - 28) && (pos_x <= H_ACT - 'd30))? 1'b0 : 1'b1;
///min2
assign char8_x = ((pos_x >= (H_ACT - H_ACT/5 + 'd2)) && (pos_x <= (H_ACT - H_ACT/5 + 'd50)) && (pos_y >= V_ACT/6 + 'd2) && (pos_y <= V_ACT/6 + 'd28))? pos_x - H_ACT + H_ACT/5 - 2: 10'd0;
assign char8_y = ((pos_x >= (H_ACT - H_ACT/5 + 'd2)) && (pos_x <= (H_ACT - H_ACT/5 + 'd50)) && (pos_y >= V_ACT/6 + 'd2) && (pos_y <= V_ACT/6 + 'd28))? pos_y - V_ACT/6 - 2: 10'd0;
assign ren8    = ((pos_x >= (H_ACT - H_ACT/5 + 'd2)) && (pos_x <= (H_ACT - H_ACT/5 + 'd50)) && (pos_y >= V_ACT/6 + 'd2) && (pos_y <= V_ACT/6 + 'd28))? 1'b0 : 1'b1;
//max2
assign char9_x = ((pos_x >= (H_ACT - H_ACT/5 + 'd2)) && (pos_x <= (H_ACT - H_ACT/5 + 'd50)) && (pos_y >= V_ACT/3 + 'd2) && (pos_y <= V_ACT/3 + 'd28))? pos_x - H_ACT + H_ACT/5 - 2: 10'd0;
assign char9_y = ((pos_x >= (H_ACT - H_ACT/5 + 'd2)) && (pos_x <= (H_ACT - H_ACT/5 + 'd50)) && (pos_y >= V_ACT/3 + 'd2) && (pos_y <= V_ACT/3 + 'd28))? pos_y - V_ACT/3 - 2: 10'd0;
assign ren9    = ((pos_x >= (H_ACT - H_ACT/5 + 'd2)) && (pos_x <= (H_ACT - H_ACT/5 + 'd50)) && (pos_y >= V_ACT/3 + 'd2) && (pos_y <= V_ACT/3 + 'd28))? 1'b0 : 1'b1;
//fre2
assign char10_x= ((pos_x >= (H_ACT - H_ACT/5 + 'd2)) && (pos_x <= (H_ACT - H_ACT/5 + 'd50)) && (pos_y >= V_ACT/2 + 2) && (pos_y <= V_ACT/2 + 28))? pos_x  - H_ACT + H_ACT/5 - 2: 10'd0;
assign char10_y= ((pos_x >= (H_ACT - H_ACT/5 + 'd2)) && (pos_x <= (H_ACT - H_ACT/5 + 'd50)) && (pos_y >= V_ACT/2 + 2) && (pos_y <= V_ACT/2 + 28))? pos_y - V_ACT/2 - 2: 10'd0;
assign ren10   = ((pos_x >= (H_ACT - H_ACT/5 + 'd2)) && (pos_x <= (H_ACT - H_ACT/5 + 'd50)) && (pos_y >= V_ACT/2 + 2) && (pos_y <= V_ACT/2 + 28))? 1'b0 : 1'b1;
//vol2				
assign char11_x= ((pos_x >= (H_ACT - H_ACT/5 + 'd2)) && (pos_x <= (H_ACT - H_ACT/5 + 'd50)) && (pos_y >= V_ACT/3 + V_ACT/3 + 2) && (pos_y <= V_ACT/3 + V_ACT/3 + 28))? pos_x - H_ACT + H_ACT/5 - 2: 10'd0;
assign char11_y= ((pos_x >= (H_ACT - H_ACT/5 + 'd2)) && (pos_x <= (H_ACT - H_ACT/5 + 'd50)) && (pos_y >= V_ACT/3 + V_ACT/3 + 2) && (pos_y <= V_ACT/3 + V_ACT/3 + 28))? pos_y - V_ACT + V_ACT/3 - 2: 10'd0;
assign ren11   = ((pos_x >= (H_ACT - H_ACT/5 + 'd2)) && (pos_x <= (H_ACT - H_ACT/5 + 'd50)) && (pos_y >= V_ACT/3 + V_ACT/3 + 2) && (pos_y <= V_ACT/3 + V_ACT/3 + 28))? 1'b0 : 1'b1;
//+/-	
assign char12_x= ((pos_x >= (H_ACT - H_ACT/5 + 'd42)) && (pos_x <= (H_ACT - 'd42)) && (pos_y >= V_ACT - V_ACT/6 + 28) && (pos_y <= V_ACT - 28))? pos_x - H_ACT + H_ACT/5 - 42: 10'd0;
assign char12_y= ((pos_x >= (H_ACT - H_ACT/5 + 'd42)) && (pos_x <= (H_ACT - 'd42)) && (pos_y >= V_ACT - V_ACT/6 + 28) && (pos_y <= V_ACT - 28))? pos_y - V_ACT + V_ACT/6 - 28: 10'd0;
assign ren12   = ((pos_x >= (H_ACT - H_ACT/5 + 'd42)) && (pos_x <= (H_ACT - 'd42)) && (pos_y >= V_ACT - V_ACT/6 + 28) && (pos_y <= V_ACT - 28))? 1'b0 : 1'b1;
//复位
assign char13_x= ((pos_x >= (H_ACT/5 + 'd55))  && (pos_x <= (H_ACT/5 - 'd55 + H_ACT/5)) && (pos_y >= 'd28	   ) && (pos_y <= V_ACT/6 - 28))? pos_x - H_ACT/5 - 55: 10'd0;
assign char13_y= ((pos_x >= (H_ACT/5 + 'd55))  && (pos_x <= (H_ACT/5 - 'd55 + H_ACT/5)) && (pos_y >= 'd28	   ) && (pos_y <= V_ACT/6 - 28))? pos_y - 28: 10'd0;
assign ren13   = ((pos_x >= (H_ACT/5 + 'd55))  && (pos_x <= (H_ACT/5 - 'd55 + H_ACT/5)) && (pos_y >= 'd28	   ) && (pos_y <= V_ACT/6 - 28))? 1'b0 : 1'b1;
//FFT
assign char14_x= (pos_x >= (H_ACT/5 + H_ACT/5 + 'd42) && (pos_x <= (H_ACT/5 - 'd42 + H_ACT/5 + H_ACT/5)) && (pos_y >= 'd28	   ) && (pos_y <= V_ACT/6 - 28))? pos_x - H_ACT/5 - H_ACT/5 - 42: 10'd0;
assign char14_y= (pos_x >= (H_ACT/5 + H_ACT/5 + 'd42) && (pos_x <= (H_ACT/5 - 'd42 + H_ACT/5 + H_ACT/5)) && (pos_y >= 'd28	   ) && (pos_y <= V_ACT/6 - 28))? pos_y - 28: 10'd0;
assign ren14   = (pos_x >= (H_ACT/5 + H_ACT/5 + 'd42) && (pos_x <= (H_ACT/5 - 'd42 + H_ACT/5 + H_ACT/5)) && (pos_y >= 'd28	   ) && (pos_y <= V_ACT/6 - 28))? 1'b0 : 1'b1;
//返回
assign char15_x= ((pos_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + 'd55)) && (pos_x <= (H_ACT - H_ACT/5 - 'd55)) && (pos_y >= 'd28	   ) && (pos_y <= V_ACT/6 - 28))? pos_x - H_ACT/5 - H_ACT/5 - H_ACT/5 - 55: 10'd0;
assign char15_y= ((pos_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + 'd55)) && (pos_x <= (H_ACT - H_ACT/5 - 'd55)) && (pos_y >= 'd28	   ) && (pos_y <= V_ACT/6 - 28))? pos_y - 28: 10'd0;
assign ren15   = ((pos_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + 'd55)) && (pos_x <= (H_ACT - H_ACT/5 - 'd55)) && (pos_y >= 'd28	   ) && (pos_y <= V_ACT/6 - 28))? 1'b0 : 1'b1;
//暂停
assign char16_x= ((pos_x >= (H_ACT/5 + 55)) && (pos_x <= (H_ACT/5 + H_ACT/5 - 55))&& (pos_y >= V_ACT - V_ACT/6 + 28) && (pos_y <= (V_ACT - 28)))? pos_x - H_ACT/5 - 55: 10'd0;
assign char16_y= ((pos_x >= (H_ACT/5 + 55)) && (pos_x <= (H_ACT/5 + H_ACT/5 - 55))&& (pos_y >= V_ACT - V_ACT/6 + 28) && (pos_y <= (V_ACT - 28)))? pos_y - V_ACT + V_ACT/6 -28 : 10'd0;
assign ren16   = ((pos_x >= (H_ACT/5 + 55)) && (pos_x <= (H_ACT/5 + H_ACT/5 - 55))&& (pos_y >= V_ACT - V_ACT/6 + 28) && (pos_y <= (V_ACT - 28)))? 1'b0 : 1'b1;
//插值
assign char17_x= ((pos_x >= (H_ACT/5 + H_ACT/5 + 55)) && (pos_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 - 55))&& (pos_y >= V_ACT - V_ACT/6 + 28) && (pos_y <= V_ACT - 28))? pos_x - H_ACT/5 - H_ACT/5 - 55: 10'd0;
assign char17_y= ((pos_x >= (H_ACT/5 + H_ACT/5 + 55)) && (pos_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 - 55))&& (pos_y >= V_ACT - V_ACT/6 + 28) && (pos_y <= V_ACT - 28))? pos_y - V_ACT + V_ACT/6 - 28: 10'd0;
assign ren17   = ((pos_x >= (H_ACT/5 + H_ACT/5 + 55)) && (pos_x <= (H_ACT/5 + H_ACT/5 + H_ACT/5 - 55))&& (pos_y >= V_ACT - V_ACT/6 + 28) && (pos_y <= V_ACT - 28))? 1'b0 : 1'b1;
//差分
assign char18_x= ((pos_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + 55)) && (pos_x <= H_ACT -  H_ACT/5 - 55)) && (pos_y <= V_ACT - 28) && (pos_y >= V_ACT - V_ACT/6 + 28)? pos_x - H_ACT/5 - H_ACT/5 - H_ACT/5 - 55: 10'd0;
assign char18_y= ((pos_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + 55)) && (pos_x <= H_ACT -  H_ACT/5 - 55)) && (pos_y <= V_ACT - 28) && (pos_y >= V_ACT - V_ACT/6 + 28)? pos_y - V_ACT + V_ACT/6 - 28: 10'd0;
assign ren18   = ((pos_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5 + 55)) && (pos_x <= H_ACT -  H_ACT/5 - 55)) && (pos_y <= V_ACT - 28) && (pos_y >= V_ACT - V_ACT/6 + 28)? 1'b0 : 1'b1;
//khz
assign char19_x= ((pos_x >= (H_ACT - H_ACT/5 + 'd52)) && (pos_x <= (H_ACT - H_ACT/5 + 'd92)) && (pos_y >= V_ACT/2 + 10) && (pos_y <= V_ACT/2 + 28))? pos_x  - H_ACT + H_ACT/5 - 52: 10'd0;
assign char19_y= ((pos_x >= (H_ACT - H_ACT/5 + 'd52)) && (pos_x <= (H_ACT - H_ACT/5 + 'd92)) && (pos_y >= V_ACT/2 + 10) && (pos_y <= V_ACT/2 + 28))? pos_y - V_ACT/2 - 10: 10'd0;
assign ren19   = ((pos_x >= (H_ACT - H_ACT/5 + 'd52)) && (pos_x <= (H_ACT - H_ACT/5 + 'd92)) && (pos_y >= V_ACT/2 + 10) && (pos_y <= V_ACT/2 + 28))? 1'b0 : 1'b1;
//mhz
assign char20_x= ((pos_x >= (H_ACT - H_ACT/5 + 'd52)) && (pos_x <= (H_ACT - H_ACT/5 + 'd92)) && (pos_y >= V_ACT/2 + 10) && (pos_y <= V_ACT/2 + 28))? pos_x  - H_ACT + H_ACT/5 - 52: 10'd0;
assign char20_y= ((pos_x >= (H_ACT - H_ACT/5 + 'd52)) && (pos_x <= (H_ACT - H_ACT/5 + 'd92)) && (pos_y >= V_ACT/2 + 10) && (pos_y <= V_ACT/2 + 28))? pos_y - V_ACT/2 - 10: 10'd0;
assign ren20   = ((pos_x >= (H_ACT - H_ACT/5 + 'd52)) && (pos_x <= (H_ACT - H_ACT/5 + 'd92)) && (pos_y >= V_ACT/2 + 10) && (pos_y <= V_ACT/2 + 28))? 1'b0 : 1'b1;
//vpp
assign char21_x= ((pos_x >= (H_ACT - H_ACT/5 + 'd52)) && (pos_x <= (H_ACT - H_ACT/5 + 'd92)) && (pos_y >= V_ACT/2 + 10 + V_ACT/6) && (pos_y <= V_ACT/2 + 28 + V_ACT/6))? pos_x  - H_ACT + H_ACT/5 - 52: 10'd0;
assign char21_y= ((pos_x >= (H_ACT - H_ACT/5 + 'd52)) && (pos_x <= (H_ACT - H_ACT/5 + 'd92)) && (pos_y >= V_ACT/2 + 10 + V_ACT/6) && (pos_y <= V_ACT/2 + 28 + V_ACT/6))? pos_y - V_ACT/2 - 10 - V_ACT/6: 10'd0;
assign ren21   = ((pos_x >= (H_ACT - H_ACT/5 + 'd52)) && (pos_x <= (H_ACT - H_ACT/5 + 'd92)) && (pos_y >= V_ACT/2 + 10 + V_ACT/6) && (pos_y <= V_ACT/2 + 28 + V_ACT/6))? 1'b0 : 1'b1;
//khz
assign char22_x = ((pos_x <= 92)) && (pos_x >= ('d52) && (pos_y >= V_ACT/2 + 10) && (pos_y <= V_ACT/2 + 28))? pos_x - 52: 10'd0;
assign char22_y = ((pos_x <= 92)) && (pos_x >= ('d52) && (pos_y >= V_ACT/2 + 10) && (pos_y <= V_ACT/2 + 28))? pos_y - V_ACT/2 - 10: 10'd0;
assign ren22    = ((pos_x <= 92)) && (pos_x >= ('d52) && (pos_y >= V_ACT/2 + 10) && (pos_y <= V_ACT/2 + 28))? 1'b0 : 1'b1;
//mhz
assign char23_x = ((pos_x <= 92)) && (pos_x >= ('d52) && (pos_y >= V_ACT/2 + 10) && (pos_y <= V_ACT/2 + 28))? pos_x - 52: 10'd0;
assign char23_y = ((pos_x <= 92)) && (pos_x >= ('d52) && (pos_y >= V_ACT/2 + 10) && (pos_y <= V_ACT/2 + 28))? pos_y - V_ACT/2 - 10: 10'd0;
assign ren23    = ((pos_x <= 92)) && (pos_x >= ('d52) && (pos_y >= V_ACT/2 + 10) && (pos_y <= V_ACT/2 + 28))? 1'b0 : 1'b1;
//vpp
assign char24_x = ((pos_x <= 92)) && (pos_x >= ('d52) && (pos_y >= V_ACT/2 + 10 + V_ACT/6) && (pos_y <= V_ACT/2 + 28 + V_ACT/6))? pos_x - 52: 10'd0;
assign char24_y = ((pos_x <= 92)) && (pos_x >= ('d52) && (pos_y >= V_ACT/2 + 10 + V_ACT/6) && (pos_y <= V_ACT/2 + 28 + V_ACT/6))? pos_y - V_ACT/2 - 10 - V_ACT/6: 10'd0;
assign ren24    = ((pos_x <= 92)) && (pos_x >= ('d52) && (pos_y >= V_ACT/2 + 10 + V_ACT/6) && (pos_y <= V_ACT/2 + 28 + V_ACT/6))? 1'b0 : 1'b1;
wire [9:0] charhz1_y,charhz2_y;
assign charhz1_y = (fre2 < 1000) ? char19_y : char19_y + 16;
assign charhz2_y = (fre1 < 1000) ? char22_y : char22_y + 16;
always@(posedge pclk)
begin
	if(ren1 == 1'b0)
		if(rom_data['d144 - char1_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else if(ren2 == 1'b0)
		if(rom_data['d48 - char2_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else if(ren3 == 1'b0)
		if(rom_data['d48 - char3_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else if(ren4 == 1'b0)
		if(rom_data['d48 - char4_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else if(ren5 == 1'b0)
		if(rom_data['d48 - char5_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else if(ren6 == 1'b0)
		if(rom_data['d120 - char6_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else if(ren7 == 1'b0)
		if(rom_data['d144 - char7_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else if(ren8 == 1'b0)
		if(rom_data['d48 - char8_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else if(ren9 == 1'b0)
		if(rom_data['d48 - char9_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else if(ren10 == 1'b0)
		if(rom_data['d48 - char10_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else if(ren11 == 1'b0)
		if(rom_data['d48 - char11_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else if(ren12 == 1'b0)
		if(rom_data['d120 - char12_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else if(ren13 == 1'b0)
		if(rom_data['d96 - char13_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else if(ren14 == 1'b0)
		if(rom_data['d120 - char14_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else if(ren15 == 1'b0)
		if(rom_data['d96 - char15_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else if(ren16 == 1'b0)
		if(rom_data['d96 - char16_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else if(ren17 == 1'b0)
		if(rom_data['d96 - char17_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else if(ren18 == 1'b0)
		if(rom_data['d96 - char18_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else if(ren19 == 1'b0)
		if(rom_data['d40 - char19_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else if(ren21 == 1'b0)
		if(rom_data['d40 - char21_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else if(ren22 == 1'b0)
		if(rom_data['d40 - char22_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else if(ren24 == 1'b0)
		if(rom_data['d40 - char24_x] == 1)
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else
		v_data <= pos_data;
end
assign char_y = (!ren1) ? char1_y        :
				(!ren2) ? char2_y + 'd48 : //min1
				(!ren3) ? char3_y + 'd72 : //max1
				(!ren4) ? char4_y + 'd96 : //fre1
				(!ren5) ? char5_y + 'd120 : //vol1
				(!ren6) ? char6_y + 'd144 : //+/-
				(!ren7) ? char7_y + 'd192 : //td2
				(!ren8) ? char8_y + 'd240 : //min2
				(!ren9) ? char9_y + 'd264 : //max2
				(!ren10) ? char10_y + 'd288 : //fre2
				(!ren11) ? char11_y + 'd312 : //vol2
				(!ren12) ? char12_y + 'd144 : //td3
				(!ren13) ? char13_y + 'd336 : //fw
				(!ren14) ? char14_y + 'd384 : //fft
				(!ren15) ? char15_y + 'd432 : //fh
				(!ren16) ? char16_y + 'd480 : //zt
				(!ren18) ? char18_y + 'd528 : //st
				(!ren19) ? charhz1_y + 'd576 : //khz
				(!ren21) ? char21_y + 'd608 : //vpp
				(!ren22) ? charhz2_y + 'd576 : //khz
				(!ren24) ? char24_y + 'd608 : //vpp
				(!ren17) ? char17_y + 'd624 : //tr
				10'd0;
assign ren = (ren1 && ren2 && ren3 && ren4 && ren5 && ren6 && ren7 && ren8 && ren9 && ren10 && ren11 && ren12 && ren13 && ren14 && ren15 && ren16 && ren17 && ren18 && ren19 && ren20 && ren21 && ren22 && ren23 && ren24)? 1'b1 : 1'b0;

char_rom char_rom_m0(
	.addr(char_y),
	.clk(pclk),
	.rst(ren),
	.rd_data(rom_data)
	);


assign o_data = v_data;
assign o_hs = pos_hs;
assign o_vs = pos_vs;
assign o_de = pos_de;
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