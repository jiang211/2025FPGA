module easy_divider (
    input rst_n,
    input clk,

    output reg [8:0] addr,
    input [31:0] freq_word,

    input [16 : 0]divisor
);
    reg [16 : 0] dividend;
always @(posedge clk)begin
    if(!rst_n)begin
        addr <= 256;
        dividend <= 0;
    end else begin
        if(dividend + freq_word >= divisor * 2 + divisor)begin
            if(dividend + freq_word > divisor * 4)begin
                dividend <= dividend + freq_word - divisor *4;
                addr <= addr + 4;
            end
            else if(dividend + freq_word >= divisor * 2 + divisor)begin
                dividend <= dividend + freq_word - divisor *2 -  divisor;
                addr <= addr + 3;
            end
        end else begin
            if(dividend + freq_word >= divisor * 2)begin
                dividend <= dividend + freq_word - divisor *2 ;
                addr <= addr + 2;
            end else if(dividend + freq_word >= divisor)begin
                dividend <= dividend + freq_word - divisor;
                addr <= addr + 1;
            end
        end

    end
end
endmodule