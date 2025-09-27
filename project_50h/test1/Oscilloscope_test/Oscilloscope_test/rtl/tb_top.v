`timescale 1ns / 1ps

module top_tb;

// Inputs
reg sys_clk;
reg [7:0] key;

// Outputs
wire rstn_out;
wire iic_tx_scl;
wire iic_tx_sda;
wire led_int;
wire pix_clk;
wire vs_out;
wire hs_out;
wire de_out;
wire [7:0] r_out;
wire [7:0] g_out;
wire [7:0] b_out;
wire GRS_N;

GTP_GRS GRS_INST (

.GRS_N(1'b1)

);
// Instantiate the Unit Under Test (UUT)
top uut (
    .sys_clk(sys_clk), 
    .rstn_out(rstn_out),
    .iic_tx_scl(iic_tx_scl),
    .iic_tx_sda(iic_tx_sda),
    .key(key),
    .led_int(led_int),
    .pix_clk(pix_clk),
    .vs_out(vs_out),
    .hs_out(hs_out),
    .de_out(de_out),
    .r_out(r_out),
    .g_out(g_out),
    .b_out(b_out)
);

initial begin
    // Initialize Inputs
    sys_clk = 0;
    key = 0;

    // Wait for global reset
    #100;
    
    // Add stimulus here
    key = 8'b1; // Example key press
    #10;
    
    key = 8'b0; // Release key
    #10;
    
    // Run simulation for some time
    #1000;
    
    $finish; // End simulation
end

// Clock generation
always #10 sys_clk = ~sys_clk; // Generate a clock with 50MHz

endmodule