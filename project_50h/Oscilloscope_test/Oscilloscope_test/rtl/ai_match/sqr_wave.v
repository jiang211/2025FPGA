// sqr_wave_gen.v
// 32-bit phase, 8-bit output, 0° / 180° selectable by sel_phase
module sqr_wave_gen #(
    parameter CLK_FREQ = 32'd50_000_000,
    parameter PH_W = 32,
    parameter DT_W = 8
)(
    input  wire                clk,
    input  wire                rst_n,

    input  wire [PH_W-1:0]     freq_word,
    input  wire [DT_W-1:0]     amplitude,  // 峰值（正数）
    input  wire [DT_W-1:0]     cycle_num,
    input  wire [31:0]         SAD_FREQ,
    
    input  wire                sel_phase,   // 0:0°  1:180°
    output reg  [DT_W-1:0]     wave_out     // 选中相位方波
);

// localparam SAD_FREQ = 196850;       
// wire [31:0] SAD_FREQ = (CLK_FREQ>>2) / (amplitude-128);


localparam RAISE = 0;
localparam FALL = 1;
localparam FINISH = 2;


/*-------- 相位累加器 --------*/
reg [1:0] sign_status;

// reg [PH_W-1:0] phase;
reg [DT_W-1 : 0] cycle_cnt;

always @(posedge clk)
    if (!rst_n) cycle_cnt <= 0;
    else       begin
        if(sign_status == FINISH)begin
            cycle_cnt <= 0;
        end else begin
             cycle_cnt <= cycle_cnt + 1;
        end
        
    end

// wire [PH_W-1:0] circle = phase / SAD_FREQ;

always @(posedge clk ) begin
    if (!rst_n) begin
        sign_status <= 0;
    end
    else begin
        case (sign_status)
            RAISE : if(cycle_cnt >= cycle_num ) begin sign_status <= FALL; end
            FALL  : if(cycle_cnt >= (cycle_num<<1) -1) begin sign_status <= FINISH; end
            FINISH : begin sign_status <= RAISE; end
            default : sign_status <= FALL;
        endcase
    end 
end 

// always @(posedge clk)
//     if (!rst_n) phase <= 0;
//     else        phase <= sign_status== RAISE ? phase + freq_word : phase - freq_word;

// wire [PH_W-1:0] circle = phase / SAD_FREQ;

// always @(posedge clk ) begin
//     if (!rst_n) begin
//         sign_status <= 0;
//     end
//     else begin
//         case (sign_status)
//             RAISE : if(circle >= amplitude - freq_word / SAD_FREQ) begin sign_status <= FALL; end
//             FALL  : if(circle <= freq_word / SAD_FREQ) begin sign_status <= RAISE; end
//             default : sign_status <= FALL;
//         endcase
//     end 
// end   
        
        
/*-------- 方波标志 --------*/
wire square_flag_0   = ~sign_status[0];        // 0° 标志
wire square_flag_180 = sign_status[0];       // 180° 标志

/*-------- 选择输出 --------*/
wire flag_sel = sel_phase ? square_flag_180 : square_flag_0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        wave_out <= 0;
    else
        wave_out <= flag_sel ? amplitude : 255-amplitude;
end

endmodule