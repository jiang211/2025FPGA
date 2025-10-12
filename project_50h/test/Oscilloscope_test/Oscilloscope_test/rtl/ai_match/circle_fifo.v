/*使用一个Fifo计算相邻两个峰值，即为单个周期*/
/*接收到单个周期之后便输出*/


module divirative #(
    parameter FIFO_WIDTH = 8
) (
    input clk_50M,
    input rst_n,
    input valid,

    input [FIFO_WIDTH -1 : 0] wave_data,
    output reg [FIFO_WIDTH -1 : 0] fifo_dout,
    output reg output_valid

    );
    localparam IDLE = 0;
    localparam LOAD_WAVE = 1;
    localparam OUTPUT_WAVE = 2;

    reg [2 : 0]fifo_state;
    reg [FIFO_WIDTH -1 : 0]temp_wave_data;

    always @(posedge clk_50M)begin
        if(!rst_n)begin

            temp_wave_data <= 0;
            fifo_dout <= 0 ;


            fifo_state <= IDLE;
            output_valid <= 0; 

        end
        else begin
            case (fifo_state)
                IDLE:begin
                    if(valid)begin
                        temp_wave_data <= wave_data;

                        fifo_state <= LOAD_WAVE;
                        output_valid <= 0; 

                    end
                end 
                LOAD_WAVE:begin
                    if(~valid)begin
                        fifo_state <= IDLE;
                    end
                    temp_wave_data <= wave_data;
                    fifo_dout <=temp_wave_data - wave_data +128;
                    output_valid <= 1; 



                end

                default: begin
                    fifo_state<=IDLE;
                    output_valid <= 0; 

                end
            endcase
        end
    end


endmodule