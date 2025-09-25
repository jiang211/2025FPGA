//////////////////////////////////////////////////////////////////////
// 公	司	：科一电子
// 功	能	：双路65Msps的ADC实现单路130Msps的ADC采集
// 模	块	：高速双路AD9226模块
// 创建日期	：2017-09-01
// 调试工具	：Quartus II 13.0
// 版	本	：V1.0 
// 说	明	：通过SignalTap II观察采集的数据波形
//////////////////////////////////////////////////////////////////////
module AD9226_2CH(
	
	input 			Ext_Rst_n,	// 外部复位
	input 			Ext_Clk,	// 外部时钟50Mhz
	
	input 			Otr_A,		// 通道A超出范围
	input	[11:0]	Adc_In_A,	// 通道A输入数据
	output			Adc_Clk_A,	// 通道A时钟
	
	input 			Otr_B,		// 通道B超出范围
	input	[11:0]	Adc_In_B,	// 通道B输入数据
	output			Adc_Clk_B	// 通道B时钟
);

// 根据AD9226的时序，AD9226的数据会延时3.5ns~7ns
// 所以Adc_ReadClk_65M相对于Adc_Clk_65M滞后4ns的时候读的数据才会稳定，不会出现毛刺
wire Adc_ReadClk_65M;			// 65MHz时钟
wire Clk_130M;					// 130MHz时钟
wire Adc_Clk_65M;				// 65MHz的ADC时钟

wire [11:0] Adc_Out;			// 采集数据

wire Rdempty;					// FIFO的读空信号
reg	 Read_En;					// FIFO的读使能信号
reg [11:0] Adc_Data_CHA;		// 通道A采集数据
reg [11:0] Adc_Data_CHB;		// 通道B采集数据

assign Adc_Clk_A =  Adc_Clk_65M;// 通道A时钟输出
assign Adc_Clk_B = ~Adc_Clk_65M;// 通道B时钟输出

// 模块：PLL
// 功能：为系统提供时钟源
PLL PLL_CLK(
	.inclk0	(Ext_Clk),			// 外部时钟50Mhz
	.c0		(Adc_ReadClk_65M),	// 65MHz时钟
	.c1		(Adc_Clk_65M),		// 65MHz的ADC时钟
	.c2		(Clk_130M)			// 130MHz时钟
);

// 功能：读取通道A的采集数据
always @(posedge Adc_ReadClk_65M)
begin
	Adc_Data_CHA <= Adc_In_A^12'hFFF;
end

// 功能：读取通道B的采集数据
always @(negedge Adc_ReadClk_65M)
begin
	Adc_Data_CHB <= Adc_In_B^12'hFFF;
end

// 功能：FIFO的读使能
always @(posedge Clk_130M) 
begin 
	if (!Ext_Rst_n) 
	begin 
		Read_En <= 1'b0;
	end 
	else 
	begin 
		Read_En <= ~Rdempty;
	end 
end 

// 功能：FIFO将1个24位的数据转换为2个12位的数据
FIFO Fifo_24to12(
	.aclr	(~Ext_Rst_n),					// 复位
	.wrclk 	(Adc_ReadClk_65M),				// 写时钟
	.wrreq 	(1'b1),							// 写使能
	.data 	({Adc_Data_CHB, Adc_Data_CHA}),	// 写数据
	
	.rdclk 	(Clk_130M),						// 读时钟
	.rdreq 	(Read_En),						// 读使能
	.q 		(Adc_Out),						// 读数据
	.rdempty(Rdempty)						// 读空
);

endmodule 