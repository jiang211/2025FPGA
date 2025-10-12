module tb;
reg clk = 0, rst_n = 0;
reg [31:0] freq_word ;  // 1 kHz @ 50 MHz
reg [15:0] amplitude ;
wire [7:0] wave_out;

triangle_dds dut (
    .clk(clk),
    .rst_n(rst_n),
    .freq_word(freq_word),
    .amplitude(amplitude),
    .wave_out(wave_out)
);

always #10 clk = ~clk;
initial begin
    // $dumpfile("triangle.vcd");
    // $dumpvars(0, tb);
    freq_word = 32'd2000000;
    amplitude = 16'd255;
    #25 rst_n = 1;
end
endmodule