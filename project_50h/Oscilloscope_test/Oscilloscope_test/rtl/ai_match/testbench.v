// ============================================================
// 三角�? testbench
// 作�?�：xxx
// 说明�?
// 1. 产生 clk、rst_n�?
// 2. 产生 8bit 三角波数�? data_tri�?
// 3. �? data_tri 接到 DUT 的输入端口；
// 4. �? DUT 输出 log �? VCD/FSDB（可选）�?
// ============================================================
`timescale 1ns / 1ps

module tb_tri_wave;

// -----------------------------------------------------------
// 参数
// -----------------------------------------------------------
parameter CLK_PERIOD = 10;      // 10 ns -> 100 MHz 采样时钟
parameter DW         = 8;       // 数据位宽
parameter DEPTH      = 64;     // 三角波一个周期采样点�?
parameter CLK_FREQ = 32'd50_000_000;


wire [31:0] SAD_FREQ = (CLK_FREQ>>2) / (amplitude-128);
     

// -----------------------------------------------------------
// 信号
// -----------------------------------------------------------
reg                 clk;
reg                 rst_n;
reg                 valid;

reg [31:0] freq_word ;  // 1 kHz @ 50 MHz
reg [15:0] amplitude ;
wire [7:0] wave_out;
wire [7:0] wave_out_270;
wire [7:0] wave_sqr;
wire [7:0] wave_sqr_180;

wire [DW -1 : 0 ] fifo_dout;
// 下面�? data_tri 接到 DUT 的输入端口，请按实际改名

// -----------------------------------------------------------
// 实例�? DUT（请把名字和端口换成你自己的�?
// -----------------------------------------------------------
divirative u_dut (
    .clk_50M        (clk),
    .rst_n      (rst_n),

    .valid      (valid),
    .wave_data  (wave_out),
    .fifo_dout  (fifo_dout),
    .output_valid(output_valid)
);

// -----------------------------------------------------------
// 时钟
// -----------------------------------------------------------
initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end

// -----------------------------------------------------------
// 复位
// -----------------------------------------------------------
initial begin
    valid = 0;
    rst_n = 0;
    freq_word = 32'd500000;
    amplitude = 16'd159;
    repeat(10) @(posedge clk);
    rst_n = 1;
    valid = 1;
end

// -----------------------------------------------------------
// 三角波发生器
// -----------------------------------------------------------
// triangle_dds  #(
//     .CLK_FREQ(CLK_FREQ)
// ) dut0 (
//     .clk(clk),
//     .rst_n(rst_n),
//     .freq_word(freq_word),
//     .amplitude(amplitude),
//     .SAD_FREQ(SAD_FREQ),

//     .wave_out(wave_out),
//     .wave_out_270(wave_out_270)

// );

// sqr_wave_gen  #(
//     .CLK_FREQ(CLK_FREQ)
// ) dut1 (
//     .clk(clk),
//     .rst_n(rst_n),
//     .freq_word(freq_word),
//     .amplitude(amplitude),
//     .cycle_num(CLK_FREQ/freq_word),
//     .SAD_FREQ(SAD_FREQ),

//     .sel_phase(0),
//     .wave_out(wave_sqr)

// );
// sqr_wave_gen  #(
//     .CLK_FREQ(CLK_FREQ)
// ) dut2 (
//     .clk(clk),
//     .rst_n(rst_n),
//     .freq_word(freq_word),
//     .amplitude(amplitude),
//     .cycle_num(CLK_FREQ/freq_word),
//     .SAD_FREQ(SAD_FREQ),

//     .sel_phase(1),
//     .wave_out(wave_sqr_180)

// );
wire [8:0] addr ;
easy_divider div0 (
    .rst_n    (rst_n),
    .clk      (clk), 

    .addr     (addr),
    .freq_word(freq_word),

    .divisor  (SAD_FREQ)
);

wire [7:0] tri_wave;
wire [7:0] sqr_wave;
wire [7:0] sin_wave;

wire [7:0] tri_ini;
wire [7:0] sin_ini;
tri_lut tri_lut0(
    .addr(addr),
    .data(tri_ini)
);


sqr_lut sqr_lut0(
    .addr(addr),
    .sel_signal(1),
    .amplitude(amplitude),
    .data(sqr_wave)
);

sin_lut sin_lut0(
    .addr(addr),
    .data(sin_ini)
);

assign tri_wave = ((tri_ini * (amplitude-128)) >>7) + 128 - (amplitude-128);
assign sin_wave = ((sin_ini * (amplitude-128)) >>7) + 128 - (amplitude-128);



reg gate;
wire [1:0] wave_type;
reg [1:0]  wave_signal;
wire [7: 0]wave_choose;
assign wave_choose = (wave_signal == 0) ? tri_wave : (wave_signal == 1) ? sqr_wave : sin_wave;
// reg wave_in;
top top (
    .clk(clk),
    .rst_n(rst_n),

    .freq_word(freq_word),
    .amplitude(amplitude),
    .gate(gate),
    .wave_in(wave_choose),
    .wave_type(wave_type)

);


// 组合逻辑：cnt 0~255 上升�?256~511 下降

// -----------------------------------------------------------
// 仿真控制 & 波形 dump


// -----------------------------------------------------------
initial begin
    gate <= 0;
    wave_signal <= 0;

    // wave_in <= wave_sqr;

    #1000;
    gate <= 1;

    #10000;
    gate <= 0;
    wave_signal <= 1;

    #1000;
    gate <= 1;

    #10000;
    gate <= 0;
    wave_signal <= 2;

    #1000;
    gate <= 1;
    #10000;
    $display("Simulation finished");
    $finish;
end

endmodule