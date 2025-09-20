module  hdmi_ctrl
(
    input   wire            clk,
    input   wire            rst_n,
	input	wire			vs,
	input	wire			hs,
	input	wire			de,
	output	reg 			vs_out,
	output	reg				hs_out,
	output	reg				de_out,
    output  wire    [9:0]   GRAM_ADDR,
    output  wire    [3:0]   GROM_ADDR,
    input   wire    [10:0]  pixel_xpos,  //当前像素点横坐标
    input   wire    [10:0]  pixel_ypos,  //当前像素点纵坐标
    input   wire    [3:0]   GRAM_DATA,
    output  wire    [4:0]   x_low,
    output  wire    [4:0]   y_low
);

always @(posedge clk)
	begin
	    vs_out <= vs;
	    hs_out <= hs;
	    de_out <= de;
	end

wire    [5:0]   x_hign;
wire    [5:0]   y_hign;
wire    [10:0]  pixel_xpos1;
wire    [10:0]  pixel_ypos1;

assign pixel_xpos1 = pixel_xpos;
assign pixel_ypos1 = pixel_ypos - 1'b1;

assign  x_hign = pixel_xpos1[10:5];
assign  y_hign = pixel_ypos1[10:5];
assign  x_low  = pixel_xpos1[4:0];
assign  y_low  = pixel_ypos1[4:0];

assign GRAM_ADDR = x_hign + (y_hign<<5);
assign GROM_ADDR = GRAM_DATA;

endmodule
