// // triangle_dds_pos.v
// // 32-bit phase, DT_W-bit output, 0 ~ +amplitude only, no multipliers
// module triangle_dds #(
//     parameter CLK_FREQ = 32'd50_000_000,
//     // parameter SAD_FREQ = 196850,
//     parameter PH_W = 32,
//     parameter DT_W = 8
// )(
//     input  wire                clk,
//     input  wire                rst_n,

//     input  wire [PH_W-1:0]     freq_word,
//     input  wire [DT_W-1:0]     amplitude,  // 峰值（正数）
//     input  wire [31:0]         SAD_FREQ,

//     output reg  [DT_W-1:0]     wave_out     // 0 ~ amplitude
// );

// // wire [31:0] SAD_FREQ = (CLK_FREQ>>2) / (amplitude-128);

// // wire [7:0] wave_info [0 : 511]; 
// //归一化频率
// //50M/512,即每个周期中，三角波的数值都会加一。
// // localparam SAD_FREQ = 196850;       
// /*-------- 相位累加器 --------*/

// localparam RAISE = 0;
// localparam FALL = 1;

// reg [PH_W-1:0] phase;

// reg sign_status;

// wire [PH_W-2:0] addr = phase / SAD_FREQ;


// reg [10 : 0] step;
// reg [31:0]pharse_ini_step0;
// reg [31:0]pharse_ini_step1;
// reg [31:0]pharse_ini_step2;
// always @(posedge clk ) begin
//     if (!rst_n) begin
//         step <= 0;
//     end
//     else begin
//         step <= freq_word / SAD_FREQ;
//         pharse_ini_step0 <= SAD_FREQ * amplitude;
//         pharse_ini_step1 <= pharse_ini_step0 / freq_word;
//         pharse_ini_step2 <= pharse_ini_step1 * freq_word;
//     end 
// end


// always @(posedge clk ) begin
//     if (!rst_n) begin
//         sign_status <= 0;
//     end
//     else begin
//         case (sign_status)
//             RAISE : if(addr >= amplitude - step) begin sign_status <= FALL; end
//             FALL  : if(addr <= 256 - amplitude + step) begin sign_status <= RAISE; end
//             default : sign_status <= FALL;
//         endcase
//     end 
// end



// always @(posedge clk)
//     // if (!rst_n) phase <= 0;
//     if (!rst_n) phase <= pharse_ini_step2;
//     else        phase <= sign_status== RAISE ? phase + freq_word : phase - freq_word;


// /*-------- 幅度缩放 --------*/
// // wire [DT_W-1:0] ramp_clip = ramp[PH_W-2:0] >255 ? 255 : ramp[DT_W -1:0]; // 高 DT_W 位
// // wire [DT_W-1:0] ramp_clip_270 = ramp_270[PH_W-2:0] >255 ? 255 : ramp_270[DT_W -1:0]; // 高 DT_W 位
// // wire [2*DT_W -1 :0]   prod = ramp_clip * (amplitude+1);
// // wire [2*DT_W -1 :0]   prod_270 = ramp_clip_270 * (amplitude+1);
// // wire [DT_W-1:0] abs_val = prod[2*DT_W -1 :DT_W];   
// // wire [DT_W-1:0] abs_val_270 = prod_270[2*DT_W -1 :DT_W];   
// wire [DT_W-1:0] abs_val = addr;   

// always @(posedge clk)
//     if (!rst_n) wave_out <= 0;
//     else        wave_out <= abs_val;   // 无符号，0 ~ amplitude

// endmodule



module triangle_dds #(
    parameter CLK_FREQ = 32'd50_000_000,
    // parameter SAD_FREQ = 196850,
    parameter PH_W = 32,
    parameter DT_W = 8
)(
    input  wire                clk,
    input  wire                rst_n,

    input  wire [PH_W-1:0]     freq_word,
    input  wire [DT_W-1:0]     amplitude,  // 峰值（正数）
    input  wire [31:0]         SAD_FREQ,

    output [DT_W-1:0]     wave_out     // 0 ~ amplitude
);



sin_lut sin_lut0(
    .addr(addr),
    .data(wave_out)
);

endmodule