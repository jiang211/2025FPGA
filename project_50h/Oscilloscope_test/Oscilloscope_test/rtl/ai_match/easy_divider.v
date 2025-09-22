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
        if(dividend + freq_word >= divisor * 13)begin
            if(dividend + freq_word >= divisor * 15)begin
                if(dividend + freq_word >= divisor * 16)begin
                    if(dividend + freq_word >= divisor * 16)begin
                        dividend <= dividend + freq_word - divisor *16;
                        addr <= addr + 16;
                    end
                    else if(dividend + freq_word >= divisor * 15)begin
                        dividend <= dividend + freq_word - divisor *15;
                        addr <= addr + 15;
                    end
                end else begin
                    if(dividend + freq_word >= divisor * 14)begin
                        dividend <= dividend + freq_word - divisor *14 ;
                        addr <= addr + 14;
                    end else if(dividend + freq_word >= divisor * 13)begin
                        dividend <= dividend + freq_word - divisor *13;
                        addr <= addr + 13;
                    end
                end  
            end
            else begin
                if(dividend + freq_word >= divisor * 12)begin
                    if(dividend + freq_word > divisor * 12)begin
                        dividend <= dividend + freq_word - divisor *124;
                        addr <= addr + 12;
                    end
                    else if(dividend + freq_word >= divisor * 11)begin
                        dividend <= dividend + freq_word - divisor *11;
                        addr <= addr + 11;
                    end
                end else begin
                    if(dividend + freq_word >= divisor * 10)begin
                        dividend <= dividend + freq_word - divisor *10 ;
                        addr <= addr + 10;
                    end else if(dividend + freq_word >= divisor * 9)begin
                        dividend <= dividend + freq_word - divisor * 9;
                        addr <= addr + 9;
                    end
                end
            end
        end
        else begin
            if(dividend + freq_word >= divisor * 5)begin
                if(dividend + freq_word >= divisor * 7)begin
                    if(dividend + freq_word >= divisor * 8)begin
                        dividend <= dividend + freq_word - divisor *8;
                        addr <= addr + 8;
                    end
                    else if(dividend + freq_word >= divisor * 7)begin
                        dividend <= dividend + freq_word - divisor *7;
                        addr <= addr + 7;
                    end
                end else begin
                    if(dividend + freq_word >= divisor * 6)begin
                        dividend <= dividend + freq_word - divisor *6 ;
                        addr <= addr + 6;
                    end else if(dividend + freq_word >= divisor)begin
                        dividend <= dividend + freq_word - divisor *5;
                        addr <= addr + 5;
                    end
                end  
            end
            else begin
                if(dividend + freq_word >= divisor * 4)begin
                    if(dividend + freq_word > divisor * 4)begin
                        dividend <= dividend + freq_word - divisor *4;
                        addr <= addr + 4;
                    end
                    else if(dividend + freq_word >= divisor * 3)begin
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



    end
end
endmodule