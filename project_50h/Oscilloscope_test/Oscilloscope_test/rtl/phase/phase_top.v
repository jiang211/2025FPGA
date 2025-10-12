// module phase_top(
//     input clk,
//     input rst_n,

//     input [7 : 0] wave_a,
//     input [7 : 0] wave_b,
//     input [7 : 0] amplitude,
//     output reg [8 : 0] phase_mid
// );

// localparam THRESHOLD = 4;
// wire [7 : 0] low = 256 - amplitude;

// localparam IDLE = 0;
// localparam STATE_LOW = 1;
// localparam STATE_POSEDGE = 2;
// localparam STATE_HIGH = 4;
// localparam STATE_NEGEDGE = 4;
// localparam FINISH = 8;


// reg [7:0] cnt_amp;
// reg [15:0] cnt_angel;
// reg [7:0] cnt_total;
// reg [8:0] phase_mid;
// reg [3:0] wave_a_state; // 0 low 1 high 2finish
// reg [3:0] wave_b_state; // 0 low 1 high 2finish
// reg [3:0] phase_state; // 0 low 1 high 2finish


// always @(posedge clk) begin
//     if (!rst_n) begin
//     cnt_amp <= 0;
//     cnt_total <= 0;
//     cnt_angel <= 0;
//     phase_mid <= 0;
//     wave_a_state <= IDLE;
//     wave_b_state <= IDLE;
//     phase_state <= IDLE;
//     end
//     else begin
//         case (wave_a_state)
//             IDLE:begin
//                 if(wave_a - low <= THRESHOLD || low - wave_a <= THRESHOLD)begin
//                     wave_a_state <= STATE_LOW;
//                 end  

//             end 
//             STATE_LOW:begin
//                 if(wave_a - amplitude <= THRESHOLD || amplitude - wave_a <= THRESHOLD)begin
//                     wave_a_state <= STATE_POSEDGE;
//                 end  
//             end
//             STATE_POSEDGE:begin
//                 if(wave_b_state == STATE_POSEDGE)begin
//                     wave_a_state <= STATE_NEGEDGE;
//                 end  else
//                     cnt_amp <= cnt_amp + 1;
//             end
//             STATE_NEGEDGE :begin
//                cnt_angel <= cnt_amp * 360;
//                 wave_a_state <= FINISH;
//             end
//             FINISH : begin

//             end
//         endcase


//         case (wave_b_state)
//             IDLE:begin
//                 if(wave_a_state == STATE_POSEDGE)begin
//                     if(wave_b - amplitude <= THRESHOLD || amplitude - wave_b <= THRESHOLD)begin
//                     wave_b_state <= STATE_HIGH;
//                     end
//                     else
//                     // else if(wave_b - low <= THRESHOLD || amplitude - low <= THRESHOLD)
//                     wave_b_state <= STATE_LOW;
//                 end  

//             end 
//             STATE_POSEDGE : begin
//                 if(wave_b - low <= THRESHOLD || low - wave_b <= THRESHOLD)begin
//                     wave_b_state <= STATE_LOW;
//                 end
//             end
//             STATE_LOW:begin
//                 if(wave_b - amplitude <= THRESHOLD || amplitude - wave_b <= THRESHOLD)begin
//                     wave_b_state <= STATE_POSEDGE;
//                 end  
//             end

//         endcase


//         case (phase_state)
//             IDLE:begin
//                 if(wave_a - low <= THRESHOLD || low - wave_a <= THRESHOLD)begin
//                     phase_state <= STATE_LOW;
//                 end
//             end 
//             STATE_LOW:begin
//                 if(wave_a - amplitude <= THRESHOLD || amplitude - wave_a <= THRESHOLD)begin
//                     phase_state <= STATE_POSEDGE;

//                 end  
//             end
//             STATE_POSEDGE:begin
//                 if(wave_a - low <= THRESHOLD || low - wave_a <= THRESHOLD)begin
//                     phase_state <= STATE_NEGEDGE;
//                 end
//                 cnt_total <= cnt_total + 1;

//             end
//             STATE_NEGEDGE :begin
//                 if(wave_a - amplitude <= THRESHOLD || amplitude - wave_a <= THRESHOLD)begin
//                     phase_state <= FINISH;
//                 end
//                 cnt_total <= cnt_total + 1;
//             end
//             FINISH : begin
//                 if(cnt_angel >= cnt_total*8)begin
//                     if(cnt_angel >= cnt_total * 64)begin
//                         cnt_angel <= cnt_angel - cnt_total*64;
//                         phase_mid <= phase_mid + 64;
//                     end 
//                     else if(cnt_angel >= cnt_total * 32)begin
//                         cnt_angel <= cnt_angel - cnt_total*32;
//                         phase_mid <= phase_mid + 32;
//                     end else if(cnt_angel >= cnt_total*16)begin
//                         cnt_angel <= cnt_angel - cnt_total*16;
//                         phase_mid <= phase_mid + 16;
//                     end else begin
//                         cnt_angel <= cnt_angel - cnt_total*8;
//                         phase_mid <= phase_mid + 8;
//                     end
//                 end else begin
//                     if(cnt_angel >= cnt_total * 4)begin
//                         cnt_angel <= cnt_angel - cnt_total*4;
//                         phase_mid <= phase_mid + 4;
//                     end else if(cnt_angel >= cnt_total * 2)begin
//                         cnt_angel <= cnt_angel - cnt_total * 2;
//                         phase_mid <= phase_mid + 2;
//                     end else if(cnt_angel >= cnt_total)begin
//                         cnt_angel <= cnt_angel - cnt_total;
//                         phase_mid <= phase_mid + 1;
//                     end else begin
//                         phase_mid <= phase_mid;
//                     end
//                 end
//             end
//         endcase
//     end
// end

    
// endmodule

module phase_top(
    input clk,
    input rst_n,

    input [7 : 0] wave_a,
    input [7 : 0] wave_b,
    input [7 : 0] amplitude,
    output reg [8 : 0] phase
);

localparam THRESHOLD = 4;
wire [7 : 0] low = 256 - amplitude;

localparam START = 0;
localparam STATE_LOW = 1;
localparam STATE_POSEDGE = 2;
localparam STATE_NEGEDGE = 4;
localparam FINISH = 8;

reg [4:0]state_a;
reg [4:0]state_b;

reg [15:0]cnt_a;
reg [15:0]cnt_b;
reg [15:0] cnt_total;

reg flag_a;
reg flag_b;

always @(posedge clk)begin
    if(!rst_n)begin
        state_a <= START;
        cnt_a <= 0;
        flag_a  <= 0;

        cnt_total <= 0;
    end
    else begin
        case (state_a)
            START :begin
                if(wave_a - low <= THRESHOLD || low - wave_a <= THRESHOLD)begin
                    state_a <= STATE_LOW;
                end
            end 
            STATE_LOW:begin
                if(wave_a - amplitude <= THRESHOLD || amplitude - wave_a <= THRESHOLD)begin
                    state_a <= STATE_POSEDGE;
                end  
            end
            STATE_POSEDGE : begin
                if(wave_a - low <= THRESHOLD || low - wave_a <= THRESHOLD)begin
                    state_a <= STATE_NEGEDGE;
                end
                cnt_total <= cnt_total + 1;
            end
            STATE_NEGEDGE : begin
                if(wave_a - amplitude <= THRESHOLD || amplitude - wave_a <= THRESHOLD)begin
                    state_a <= FINISH;
                end  
                cnt_total <= cnt_total + 1;
            end
            FINISH : begin
                if(flag)begin
                    flag_a <= 0;
                    cnt_a <= 0;
                end else begin 
                    if(state_b != FINISH) begin
                        flag_a <= 1;
                        cnt_a <= cnt_a + 1;
                    end
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if(!rst_n) begin
        state_b <= START;
        cnt_b <= 0;
        flag_b  <= 0;
    end
    else begin
        case (state_b)
            START :begin
                if(wave_b - low <= THRESHOLD || low - wave_b <= THRESHOLD)begin
                    state_b <= STATE_LOW;
                end
            end 
            STATE_LOW:begin
                if(wave_b - amplitude <= THRESHOLD || amplitude - wave_b <= THRESHOLD)begin
                    state_b <= STATE_POSEDGE;
                end  
            end
            STATE_POSEDGE : begin
                if(wave_b - low <= THRESHOLD || low - wave_b <= THRESHOLD)begin
                    state_b <= STATE_NEGEDGE;
                end
            end
            STATE_NEGEDGE : begin
                if(wave_b - amplitude <= THRESHOLD || amplitude - wave_b <= THRESHOLD)begin
                    state_b <= FINISH;
                end  
            end
            FINISH : begin
                if(flag)begin
                    flag_b <= 0;
                    cnt_b <= 0;
                end else begin
                    if(state_a != FINISH) begin
                        flag_b <= 1;
                        cnt_b <= cnt_b + 1;
                    end
                end
            end
        endcase
    end
end
reg flag;
reg [15:0] cnt_angel;
reg [8:0] phase_mid;

reg update;
always @(posedge clk) begin
    if(!rst_n)begin
        cnt_total <= 0;
        flag <= 0;
        cnt_angel <= 0;

        phase_mid <= 0;
    end
    else begin
        if(state_a==FINISH && state_b==FINISH) begin
            if(flag_a)begin
                flag <= 1;
                cnt_angel <= cnt_a * 360;
            end else if(flag_b)begin
                flag <= 1;
                cnt_angel <= (cnt_total-cnt_b) * 360;
            end
        end

        if(flag)begin
            if(cnt_angel >= cnt_total*8)begin
                if(cnt_angel >= cnt_total * 64)begin
                    cnt_angel <= cnt_angel - cnt_total*64;
                    phase_mid <= phase_mid + 64;
                end 
                else if(cnt_angel >= cnt_total * 32)begin
                    cnt_angel <= cnt_angel - cnt_total*32;
                    phase_mid <= phase_mid + 32;
                end else if(cnt_angel >= cnt_total*16)begin
                    cnt_angel <= cnt_angel - cnt_total*16;
                    phase_mid <= phase_mid + 16;
                end else begin
                    cnt_angel <= cnt_angel - cnt_total*8;
                    phase_mid <= phase_mid + 8;
                end
            end else begin
                if(cnt_angel >= cnt_total * 4)begin
                    cnt_angel <= cnt_angel - cnt_total*4;
                    phase_mid <= phase_mid + 4;
                end else if(cnt_angel >= cnt_total * 2)begin
                    cnt_angel <= cnt_angel - cnt_total * 2;
                    phase_mid <= phase_mid + 2;
                end else if(cnt_angel >= cnt_total)begin
                    cnt_angel <= cnt_angel - cnt_total;
                    phase_mid <= phase_mid + 1;
                end else begin
                    flag <=0;
                    update <= 1;
                end
            end
        end
        else begin
            if(update) begin
                phase <= phase_mid;
                update <= 0;
            end
        end
    end
end
endmodule