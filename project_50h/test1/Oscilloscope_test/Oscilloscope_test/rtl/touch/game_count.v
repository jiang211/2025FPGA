module game_count(
    input rst_n, 
    input clk, 
    input [9:0]money,
    input set,
    input [1:0]boost,
    output [9:0]remain,
    output yellow,
    output red
);
parameter idle = 'd1;
parameter normal = 'd2;
parameter cw = 'd3;
parameter ty = 'd4;
reg [9:0] count;
reg en;
reg [2:0]cur_state,next_state;
always @ (posedge clk or negedge rst_n) begin
    if(!rst_n)
        cur_state <= idle;
    else
        cur_state <= next_state;
end

always @(*) begin
    case(cur_state)
        idle : begin
            if(boost == 2'b01)
                next_state = normal;
            else if(boost == 2'b10)
                next_state = cw;
            else if(boost == 2'b11)
                next_state = ty;
            else
                next_state = idle;
        end
        normal : begin
            if(boost == 2'b10)
                next_state = cw;
            else if(boost == 2'b11)
                next_state = ty;
            else
                next_state = normal;
        end
        cw : begin
            if(boost == 2'b01)
                next_state = normal;
            else if(boost == 2'b11)
                next_state = ty;
            else
                next_state = cw;
        end
        ty : begin
            if(boost == 2'b01)
                next_state = normal;
            else if(boost == 2'b10)
                next_state = cw;
            else begin
                if(en)
                next_state = normal;
            else
                next_state = ty;
            end
        end
        default: next_state = idle;
    endcase
end
reg [2:0] time_count;
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        en <= 0;
    else begin
        case(next_state)
            normal : begin
                count <= 'd1;
            end
            cw :begin
                count <= 'd2;
            end
            ty : begin
                count <= 0;
                if((!en) && time_count < 'd5)
                    time_count <= time_count + 1'd1;
                else if(time_count == 'd5)
                    en <= 1'b1;
            end
        endcase
    end
end
    wire [9:0] sum;
    assign sum = (set == 1'b1)? sum + money : sum;
    reg [9:0] r_remain = 0;
reg set_0,set_1,set_flag;
    always @(posedge clk) begin
    set_0 <= set;
    set_1 <= set_0;
    if (set_0 == 1 && set == 0) begin
        set_flag <= 1;
    end
    else begin
        set_flag <= 0;
    end
end


always @(posedge clk) begin 
    if (set_flag && r_remain >= 0) begin
        r_remain <= r_remain + money - count;
    end
    else if(!set_flag && r_remain >= 0)begin
        r_remain <= r_remain - count; 
    end
    else if(r_remain < 0)
        r_remain <= 0;
    else 
        r_remain <= 0;
end

    assign yellow = (r_remain < 'd10) ? 1'b1 : 1'b0;
    assign red = (r_remain <= 0) ? 1'b1 : 1'b0;
    assign remain = r_remain;
endmodule