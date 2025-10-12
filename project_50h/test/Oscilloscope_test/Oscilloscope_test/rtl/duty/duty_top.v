module duty_top (
    input clk,
    input rst_n,

    input [7 : 0] wave_in,
    input [7 : 0] amplitude,
    output reg [7 : 0] duty
);
    

localparam THRESHOLD = 4;
wire [7 : 0] low = 256 - amplitude;


localparam START = 0;
localparam STATE_LOW = 1;
localparam STATE_POSEDGE = 2;
localparam STATE_NEGEDGE = 4;
localparam FINISH = 8;

reg [4:0]state;
reg [9 : 0] higt_cnt;
reg [9 : 0] totol_cnt;
reg [15 : 0] totol_percnt;
reg [7:0] duty_mid;
always @(posedge clk)begin
    if(!rst_n)begin
        state <= START;
        totol_cnt <= 0;
        higt_cnt <= 0;
        duty_mid <= 0;
        totol_percnt <= 0;
    end
    else begin
        case (state)
            START :begin
                if(wave_in - low <= THRESHOLD || low - wave_in <= THRESHOLD)begin
                    state <= STATE_LOW;
                end
            end 
            STATE_LOW:begin
                if(wave_in - amplitude <= THRESHOLD || amplitude - wave_in <= THRESHOLD)begin
                    state <= STATE_POSEDGE;
                    higt_cnt <= higt_cnt+1;
                    totol_cnt <= totol_cnt + 1;
                end  
            end
            STATE_POSEDGE : begin
                if(wave_in - low <= THRESHOLD || low - wave_in <= THRESHOLD)begin
                    state <= STATE_NEGEDGE;
                end
                    higt_cnt <= higt_cnt+1;
                    totol_cnt <= totol_cnt + 1;
            end
            STATE_NEGEDGE : begin
                if(wave_in - amplitude <= THRESHOLD || amplitude - wave_in <= THRESHOLD)begin
                    state <= FINISH;
                end  
                    totol_percnt <= higt_cnt * 100;
                    totol_cnt <= totol_cnt + 1;

            end
            FINISH : begin
                if(totol_percnt >= totol_cnt*8)begin
                    if(totol_percnt >= totol_cnt * 32)begin
                        totol_percnt <= totol_percnt - totol_cnt*32;
                        duty_mid <= duty_mid + 32;
                    end else if(totol_percnt >= totol_cnt*16)begin
                        totol_percnt <= totol_percnt - totol_cnt*16;
                        duty_mid <= duty_mid + 16;
                    end else begin
                        totol_percnt <= totol_percnt - totol_cnt*8;
                        duty_mid <= duty_mid + 8;
                    end
                end else begin
                    if(totol_percnt >= totol_cnt * 4)begin
                        totol_percnt <= totol_percnt - totol_cnt*4;
                        duty_mid <= duty_mid + 4;
                    end else if(totol_percnt >= totol_cnt * 2)begin
                        totol_percnt <= totol_percnt - totol_cnt * 2;
                        duty_mid <= duty_mid + 2;
                    end else if(totol_percnt >= totol_cnt)begin
                        totol_percnt <= totol_percnt - totol_cnt;
                        duty_mid <= duty_mid + 1;
                    end else begin
                        duty <= duty_mid;
                    end
                end
            end

            default: duty <= 0;
        endcase
    end
end


endmodule