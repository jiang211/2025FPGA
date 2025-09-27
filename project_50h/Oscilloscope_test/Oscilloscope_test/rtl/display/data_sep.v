module data_sep(
    input [10:0]data,
    output [4:0]first,
    output [4:0]second,
    output [4:0]third
);
reg [4:0] first_reg, second_reg, third_reg;
always@(*) begin
    if(data / 100 != 0)begin
        first_reg = data /100;
    end
    else
        first_reg = 0;
    if((data - 100 * first_reg) / 10 != 0)begin
        second_reg = (data - 100 * first_reg) / 10;
    end
    else 
        second_reg = 0;
    if((data - 100 * first_reg - 10 * second_reg) != 0)begin
        third_reg = (data - 100 * first_reg - 10 * second_reg);
    end
    else 
        third_reg = 0;
end
assign first = first_reg;
assign second = second_reg;
assign third = third_reg;
endmodule