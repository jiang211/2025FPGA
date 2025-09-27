module fre_quant(
    input  wire           clk    ,       
    input  wire           rst       ,    
    input wire [9:0] data_in,
	output wire          gate_n,
    output wire [31:0] fre
);

wire fre_data;
assign fre_data = (data_in >= 'd128) ? 1'b1 : 1'b0;
reg [31:0] rfre;

reg 		gate		;				
reg [15:0] 	cnt_gate	;				
reg [31:0] 	cnt_fx		;				
reg [31:0] 	cnt_reg		;				
 
assign	gate_n = ~gate	;				

always @(posedge clk or negedge rst)begin	
	if(!rst)begin
		cnt_gate <=0;
		gate <=0;
	end	
	else if(cnt_gate == 16'd50000)begin
        cnt_gate <= 0;
		gate <= ~gate;
	end
	else
		cnt_gate<=cnt_gate+1;
	end

always @(posedge fre_data or negedge rst)begin	
	if(!rst) begin
		cnt_fx <= 0;
        cnt_reg <= 32'd0;
    end
	else if(gate) begin
		cnt_fx <= cnt_fx + 1;
        cnt_reg <= cnt_fx;
    end
	else
		cnt_fx <= 0;
end
wire [10:0] fre_;
assign fre = (gate_n ) ? cnt_reg + 1'b1 : fre;
//assign fre = (fre_ >= 'd1000) ? fre_ / 1000 : fre_;

endmodule