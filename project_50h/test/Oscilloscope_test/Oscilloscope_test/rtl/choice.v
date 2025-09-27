module choice(
    input wire [7:0] key,
    input wire clk,
    input wire rst_n, 
    output wire [2:0]select_,
    output wire [2:0]amp_,
    output wire [9:0]fre_
);

reg [2:0] select;
reg [2:0] amp = 11'd1;
reg [9:0] fre = 10'd1;
wire key0_pos_edge;
wire key1_pos_edge;
wire key2_pos_edge;
wire key3_pos_edge;
wire key4_pos_edge;
wire key5_pos_edge;
wire key6_pos_edge;
wire key7_pos_edge;
reg key0_pulse_r1,key0_pulse_r2,key0_pulse_r3;
reg key1_pulse_r1,key1_pulse_r2,key1_pulse_r3;
reg key2_pulse_r1,key2_pulse_r2,key2_pulse_r3;
reg key3_pulse_r1,key3_pulse_r2,key3_pulse_r3;
reg key4_pulse_r1,key4_pulse_r2,key4_pulse_r3;
reg key5_pulse_r1,key5_pulse_r2,key5_pulse_r3;
reg key6_pulse_r1,key6_pulse_r2,key6_pulse_r3;
reg key7_pulse_r1,key7_pulse_r2,key7_pulse_r3;
always @ (posedge clk or negedge rst_n) //异步
 if(!rst_n) 
    begin
	    key0_pulse_r1 <= 1'b0; key0_pulse_r2 <= 1'b0; key0_pulse_r3 <= 1'b0;
	    key1_pulse_r1 <= 1'b0; key1_pulse_r2 <= 1'b0; key1_pulse_r3 <= 1'b0;
        key2_pulse_r1 <= 1'b0; key2_pulse_r2 <= 1'b0; key2_pulse_r3 <= 1'b0;
        key3_pulse_r1 <= 1'b0; key3_pulse_r2 <= 1'b0; key3_pulse_r3 <= 1'b0;
        key4_pulse_r1 <= 1'b0; key4_pulse_r2 <= 1'b0; key4_pulse_r3 <= 1'b0;
        key5_pulse_r1 <= 1'b0; key5_pulse_r2 <= 1'b0; key5_pulse_r3 <= 1'b0;
        key6_pulse_r1 <= 1'b0; key6_pulse_r2 <= 1'b0; key6_pulse_r3 <= 1'b0;
        key7_pulse_r1 <= 1'b0; key7_pulse_r2 <= 1'b0; key7_pulse_r3 <= 1'b0;
    end
 else 
    begin
	    key0_pulse_r1 <= key[0]; key0_pulse_r2 <= key0_pulse_r1; key0_pulse_r3 <= key0_pulse_r2;
        key1_pulse_r1 <= key[1]; key1_pulse_r2 <= key1_pulse_r1; key1_pulse_r3 <= key1_pulse_r2;
        key2_pulse_r1 <= key[2]; key2_pulse_r2 <= key2_pulse_r1; key2_pulse_r3 <= key2_pulse_r2;
        key3_pulse_r1 <= key[3]; key3_pulse_r2 <= key3_pulse_r1; key3_pulse_r3 <= key3_pulse_r2;
        key4_pulse_r1 <= key[4]; key4_pulse_r2 <= key4_pulse_r1; key4_pulse_r3 <= key4_pulse_r2;
        key5_pulse_r1 <= key[5]; key5_pulse_r2 <= key5_pulse_r1; key5_pulse_r3 <= key5_pulse_r2;
        key6_pulse_r1 <= key[6]; key6_pulse_r2 <= key6_pulse_r1; key6_pulse_r3 <= key6_pulse_r2;
        key7_pulse_r1 <= key[7]; key7_pulse_r2 <= key7_pulse_r1; key7_pulse_r3 <= key7_pulse_r2;
    end
	 
//上升沿检测
    
assign key0_pos_edge = key0_pulse_r2  & ~key0_pulse_r3;
assign key1_pos_edge = key1_pulse_r2  & ~key1_pulse_r3;
assign key2_pos_edge = key2_pulse_r2  & ~key2_pulse_r3;
assign key3_pos_edge = key3_pulse_r2  & ~key3_pulse_r3;
assign key4_pos_edge = key4_pulse_r2  & ~key4_pulse_r3;
assign key5_pos_edge = key5_pulse_r2  & ~key5_pulse_r3;
assign key6_pos_edge = key6_pulse_r2  & ~key6_pulse_r3;
assign key7_pos_edge = key7_pulse_r2  & ~key7_pulse_r3;

always @(posedge clk)begin
    if(key0_pos_edge)begin
        select <= 3'd0;
        fre <= 10'd1;
        amp <= 10'd1;
    end   
    else if(key1_pos_edge)begin
        select <= select + 2'd1;
    end
    else if(key2_pos_edge)begin
        fre <= fre + 10'd1;
    end
    else if(key3_pos_edge)begin
        fre <= fre + 10'd10;
    end
    else if(key4_pos_edge)begin
         amp <= amp + 10'd1;
    end
    else begin
        select <= select;
        fre <= fre;
        amp <= amp;
    end
end
assign select_ = select;
assign fre_ = fre;
assign amp_ = amp;
endmodule