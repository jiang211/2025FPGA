`timescale 1ns/1ps
module tb_sine;

parameter DW   = 16;                 // 数据位宽
parameter NP   = 1024;               // 一个周期点数


reg          clk   = 0;
reg          rst_n = 0;
always #10 clk = ~clk;               // 20 ns → 50 MHz


reg  [DW-1:0] rom [0:NP-1];
integer i;
initial begin
    $readmemh("D:/Competition/2025FPGA/src/2025FPGA/project_50h/Oscilloscope_test/Oscilloscope_test/rtl/ai_match/sin_1024.hex", rom);
    for (i=0; i<256; i=i+1) $display("mem[%0d] = %h\n", i, rom[i]);
end



reg  [9:0]   addr = 0;
wire [DW-1:0] dout;


// 地址发生器
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)          addr <= 0;
    else begin
        addr <= addr + 1;
    end
end

assign dout = rom[addr];


initial begin
    rst_n = 0;
    repeat(20) @(posedge clk);
    rst_n = 1;
    // 跑 5 个周期后结束
    repeat(5*NP) @(posedge clk);

    $finish;
end


endmodule