//////////////////////////////////////////////////////////////////////
// 公	司	：科一电子
// 功	能	：ADC9248双路65Msps驱动程序
// 模	块	：AD9248_V1.0模块
// 创建日期	：2017-09-01
// 调试工具	：Quartus II 13.0
// 版	本	：V1.0 
// 说	明	：通过SignalTap II观察采集的数据波形
//////////////////////////////////////////////////////////////////////
module AD9248(
	
	input 			Ext_Rst_n,	// 外部复位
	input 			Ext_Clk,	// 外部时钟50Mhz
	
	input 			Otr_A,		// 通道A超出范围
	input 			Otr_B,		// 通道B超出范围
	input	[13:0]	Adc_In,		// 通道输入数据
	output			Adc_Clk_A,	// 通道A时钟
	output			Adc_Clk_B	// 通道B时钟
);

wire ReadClk;			// 65MHz时钟
wire Adc_Clk_65M;		// 65MHz的ADC时钟

wire [13:0] CHA_DATA;			// 通道A采集数据
wire [13:0] CHB_DATA;			// 通道B采集数据
wire [13:0] Adc_Data_CHA;		// 通道A采集数据
wire [13:0] Adc_Data_CHB;		// 通道B采集数据
//wire CHA_Empty;
//wire CHB_Empty;

assign Adc_Clk_A = Adc_Clk_65M;	// 通道A时钟输出
assign Adc_Clk_B = ~Adc_Clk_65M; // 通道B时钟输出

// 模块：PLL
// 功能：为系统提供时钟源
PLL PLL_CLK(
	.inclk0	(Ext_Clk),			// 外部时钟50Mhz
	.c0		(ReadClk),			// 65MHz时钟
	.c1		(Adc_Clk_65M)		// 65MHz的ADC时钟
);

// 功能：读取通道A通道B的采集数据
DDIO u_DDIO(
	.datain			( Adc_In			),
	.inclock		( ReadClk			),
	.dataout_h		( Adc_Data_CHB		),
	.dataout_l		( Adc_Data_CHA		)
);

FIFO u_CHA_FIFO(
	.data			( Adc_Data_CHA 		),
	.rdclk			( ReadClk			),
	.rdreq			( ~CHA_Empty		),
	.wrclk			( ReadClk			),
	.wrreq			( 1'b1				),
	.q				( CHA_DATA			),
	.rdempty		( CHA_Empty 		)
);

FIFO u_CHB_FIFO(
	.data			( Adc_Data_CHB 		),
	.rdclk			( ReadClk			),
	.rdreq			( ~CHB_Empty		),
	.wrclk			( ReadClk			),
	.wrreq			( 1'b1				),
	.q				( CHB_DATA			),
	.rdempty		( CHB_Empty 		)
);

endmodule 