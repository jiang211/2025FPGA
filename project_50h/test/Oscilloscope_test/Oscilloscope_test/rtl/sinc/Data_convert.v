module Data_convert (
input clk,
input rst_n,
input i_DV,
input [79:0] i_data,
output o_DV,
output reg [15:0] o_data
);

localparam RST = 3'b001;
localparam DCING = 3'b010;
localparam PUT = 3'b011;
localparam WAIT = 3'b100;

reg [2:0] c_state = WAIT;
reg [2:0] n_state;

reg [15:0] data_reg [0:4];
reg r_DV = 0;
reg [2:0] put_cnt = 0;

assign o_DV = r_DV;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        c_state <= RST;
    end
    else begin
        c_state <= n_state;
    end
end

always @(*) begin
    case (c_state)
        RST: begin
            n_state = WAIT;
        end
        WAIT: begin
            if (i_DV) begin
                n_state = DCING;
            end
            else begin
                n_state = WAIT;
            end
        end
        DCING: begin
            n_state = PUT;
        end
        PUT: begin
            if (put_cnt >= 5) begin
                n_state = WAIT;
            end
            else begin
                n_state = PUT;
            end
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        r_DV <= 0;
        o_data <= 0;
        put_cnt <= 0;
    end
    else begin
        case (n_state)
            WAIT: begin
                r_DV <= 0;
                o_data <= 0;
                put_cnt <= 0;
                data_reg[0] <= 0;
                data_reg[1] <= 0;
                data_reg[2] <= 0;
                data_reg[3] <= 0;
                data_reg[4] <= 0;
            end
            DCING: begin
                data_reg[0] <= i_data[15:0];
                data_reg[1] <= i_data[31:16];
                data_reg[2] <= i_data[47:32];
                data_reg[3] <= i_data[63:48];
                data_reg[4] <= i_data[79:64];
            end
            PUT: begin
                r_DV <= 1;
                put_cnt <= put_cnt + 1;
                case (put_cnt)
                    0: begin
                        o_data <= data_reg[0];
                    end
                    1: begin
                        o_data <= data_reg[1];
                    end
                    2: begin
                        o_data <= data_reg[2];
                    end
                    3: begin
                        o_data <= data_reg[3];
                    end
                    4: begin
                        o_data <= data_reg[4];
                    end
                endcase
            end
        endcase
    end
end
endmodule