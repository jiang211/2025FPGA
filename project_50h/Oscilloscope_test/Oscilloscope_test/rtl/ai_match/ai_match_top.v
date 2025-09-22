module ai_match_top #(
    parameter CLK_FREQ = 32'd50_000_000,
    parameter PH_W = 32,
    parameter DT_W = 8
) (
    input  wire                clk,
    input  wire                rst_n,

    input  wire [PH_W-1:0]     freq_word,
    input  wire [DT_W-1:0]     amplitude,  // 峰值（正数）
    input gate,

    input [DT_W -1 : 0] wave_in,
    output [1:0] wave_type
);

localparam THRESHOLD = 2;

localparam IDLE = 0;
localparam START_MATCHING = 1;
localparam FINISH_MATCHING = 2;

//gate 开启之后开始寻找峰值
reg [1:0] matching_gate;
reg [7:0] cycle_cnt;
always @(posedge clk) begin
    if(!gate)begin
        matching_gate <= IDLE;
        cycle_cnt <= 0;
    end else begin
        case (matching_gate)
            IDLE :begin
             if(wave_in - amplitude <= THRESHOLD || amplitude - wave_in <= THRESHOLD) matching_gate <= START_MATCHING;
            end 
            START_MATCHING : begin

             cycle_cnt <= cycle_cnt + 1;
             if(cycle_cnt == ((CLK_FREQ / freq_word) * 2)) matching_gate <= FINISH_MATCHING;   

            end
            FINISH_MATCHING : begin

            end
            default: matching_gate <= IDLE;
        endcase
    end
end

//从输入波形的峰值开始进行模板匹配
reg [7:0] wave_reg0;
reg [7:0] wave_reg1;
reg [7:0] wave_reg2;
always @(posedge clk) begin
    wave_reg0 <= wave_in;
    wave_reg1 <= wave_reg0;
    wave_reg2 <= wave_reg1;
end


//对输入波形进行求导
wire [7:0] dwave;
divirative div0 (
    .clk_50M        (clk),
    .rst_n      (matching_gate),

    .valid      (matching_gate),
    .wave_data  (wave_in),
    .fifo_dout  (dwave),

    .output_valid(output_valid)
);

//产生一个三角波模板
wire [7:0] tri_wave;
wire [7:0] sqr_wave;
wire [7:0] sin_wave;

reg [31:0] SAD_FREQ;
reg [31:0] cycle_num;

always @(posedge clk) begin
    if (!rst_n) begin
        SAD_FREQ <= 0;
        cycle_num <= 0;
    end else begin
        SAD_FREQ <= CLK_FREQ / 512;
        cycle_num <= CLK_FREQ/freq_word >> 1;

    end
end

wire [8:0] addr;
easy_divider div1 (
    .rst_n    (matching_gate),
    .clk      (clk), 

    .addr     (addr),
    .freq_word(freq_word),

    .divisor  (SAD_FREQ)
);

wire [7:0] tri_ini;
wire [7:0] sin_ini;
tri_lut tri_lut0(
    .addr(addr - 4),
    .data(tri_ini)
);


sqr_lut sqr_lut0(
    .addr(addr),
    .sel_signal(1),
    .amplitude(amplitude),
    .data(sqr_wave)
);

sin_lut sin_lut0(
    .addr(addr -128 - 32),
    .data(sin_ini)
);

assign tri_wave = ((tri_ini * (amplitude-128)) >>7) + 128 - (amplitude-128);
assign sin_wave = ((sin_ini * (amplitude-128)) >>7) + 128 - (amplitude-128);


wire [7:0] dtri_wave;
wire [7:0] dsin_wave;

divirative div2 (
    .clk_50M        (clk),
    .rst_n      (matching_gate),

    .valid      (matching_gate),
    .wave_data  (sin_wave),
    .fifo_dout  (dsin_wave),

    .output_valid(output_valid)
);


divirative div3 (
    .clk_50M        (clk),
    .rst_n      (matching_gate),

    .valid      (matching_gate),
    .wave_data  (tri_wave),
    .fifo_dout  (dtri_wave),

    .output_valid(output_valid)
);


// sqr_lut sqr_lut1(
//     .addr(addr),
//     .sel_signal(1),
//     .amplitude((amplitude -128) * freq_word / (CLK_FREQ >> 2) +128),
//     .data(dtri_wave)
// );

// triangle_dds #(
//     .CLK_FREQ(CLK_FREQ)
// ) dut0 (
//     .clk(clk),
//     .rst_n(matching_gate),

//     .freq_word(freq_word),
//     .amplitude(amplitude),
//     .SAD_FREQ(SAD_FREQ),

//     .wave_out(tri_wave)

// );

//产生方波模板
// sqr_wave_gen #(
//     .CLK_FREQ(CLK_FREQ)
// ) dut1 (
//     .clk(clk),
//     .rst_n(matching_gate),
    
//     .freq_word(freq_word),
//     .amplitude(amplitude),
//     .cycle_num(cycle_num),
//     .SAD_FREQ(SAD_FREQ),

//     .sel_phase(0),
//     .wave_out(sqr_wave)
// );

//产生三角波的求导波


// sqr_wave_gen #(
//     .CLK_FREQ(CLK_FREQ)
// ) dut2 (
//     .clk(clk),
//     .rst_n(matching_gate),
    
//     .freq_word(freq_word),
//     .amplitude((amplitude -128) * freq_word / (CLK_FREQ >> 2) +128),
//     .cycle_num(cycle_num),
//     .SAD_FREQ(SAD_FREQ),

//     .sel_phase(0),
//     .wave_out(dtri_wave)
// );
//模板匹配
template_match u_template_match (
    .clk        (clk),
    .rst_n      (rst_n),

    .wave_valid (matching_gate),
    .type_valid (type_valid),

    .tri_template (tri_wave),
    .sqr_template (sqr_wave),
    .sin_template (sin_wave),
    .dtri_template (dtri_wave),
    .dsin_template (dsin_wave),

    .wave_in    (wave_reg2),
    .dwave_in   (dwave),
    .wave_type  (wave_type)
);


endmodule