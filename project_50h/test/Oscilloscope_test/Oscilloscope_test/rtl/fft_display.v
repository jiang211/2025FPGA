`timescale 1ns / 1ps

`define UD #1

module fft_display # (
    parameter                            COCLOR_DEPP=8, // number of bits per channel
    parameter                            X_BITS=13,
    parameter                            Y_BITS=13,
    parameter                            H_ACT = 12'd1280,
    parameter                            V_ACT = 12'd720
)(                                       
    input                                rstn, 
    input                                pix_clk,
    input [X_BITS-1:0]                   act_x,    
    input [Y_BITS-1:0]                   act_y,
    
    input                                vs_in, 
    input                                hs_in, 
    input                                de_in,
    
    output reg                           vs_out, 
    output reg                           hs_out, 
    output reg                           de_out,
    output reg [15:0]                    rgb_data,
    input                fifo_rd_empty1,  
    input                fifo_rd_req1,    
    input        [8:0]   fft_point_cnt1,  
    input        [31:0]  fft_data1,       
    output               fft_point_done1, 
    output               data_req1       
);
    reg [7:0]     fft_point_cnt;
    reg [15:0]    fft_data_reg;
    always @(posedge pix_clk)
    begin
        vs_out <= `UD vs_in;
        hs_out <= `UD hs_in;
        de_out <= `UD de_in;
    end
wire [11:0] char_x, char_y;
wire ren;
reg	signed [31:0] r_fft_data1 [127:0];
wire [31:0] ram_data;
wire [95:0] rom_data;
integer i,ii;
//assign rgb_data = ((act_x > ii * 8) && (act_x <= (ii + 1) * 8) && (act_y <= V_ACT)
                   //  && (V_ACT - act_y <= ram_data/2) && (act_x <= H_ACT - 'd8)) ? 16'h5ff : 24'h000000 ;

assign data_req1 = ((act_x == (fft_point_cnt1 + 1) * 2 - 1) 
                    && (act_y == 1)) ? 1'b1 : 1'b0;

assign fft_point_done1  = ((act_x == ((fft_point_cnt1 + 1) * 2)) 
                    && (act_y == 1)) ? 1'b1 : 1'b0; 

always @(posedge pix_clk or negedge rstn) begin
    if(!rstn) begin
        ii <= 1'b0;
    end
    else if(act_x == (ii + 1) * 2) begin
        ii <= ii + 1'b1;
    end
    else if(act_x == 1024) begin
        ii <= 1'b0;
    end
end

always @(posedge pix_clk or negedge rstn) begin
    if(!rstn) begin
        i <= 1'b0;
    end
    else if(fifo_rd_req1) begin
        if(i < 511) begin
            i <= i + 1'b1;
        end
        else begin
            i <= 1'b0;
        end
    end
end

ram_fft u_ram(
    .wr_data(fft_data1),
    .wr_addr(i),
    .wr_en(fifo_rd_req1),
    .wr_clk(pix_clk),
    .wr_rst(~rstn),
    .rd_data(ram_data),
    .rd_addr(ii),
    .rd_clk(pix_clk),
    .rd_rst(~rstn)
    );

assign char_x = ((act_x >= (H_ACT - H_ACT/5 + 'd55)) && (act_x <= (H_ACT - 'd55)) && (act_y >= 'd28	   ) && (act_y <= V_ACT/6 - 28))? act_x - H_ACT/5 - H_ACT/5 - H_ACT/5 - H_ACT/5 - 55: 10'd0;
assign char_y = ((act_x >= (H_ACT - H_ACT/5 + 'd55)) && (act_x <= (H_ACT - 'd55)) && (act_y >= 'd28	   ) && (act_y <= V_ACT/6 - 28))? act_y - 28: 10'd0;
assign ren    = ((act_x >= (H_ACT - H_ACT/5 + 'd55)) && (act_x <= (H_ACT - 'd55)) && (act_y >= 'd28	   ) && (act_y <= V_ACT/6 - 28))? 1'b0 : 1'b1;

always@(posedge pix_clk)
begin
    if((act_x > ii * 2) && (act_x <= (ii + 1) * 2) && (act_y <= V_ACT) && (V_ACT - act_y <= ram_data/2) && (act_x <= H_ACT - 'd2)) begin
        rgb_data <= 16'h5ff;
    end
    else begin
	if(ren == 1'b0)
		if(rom_data['d96 - char_x] == 1)
			rgb_data <= 16'hffff;
		else
			rgb_data <= 16'h0000;
    else 
        rgb_data <= 16'h0000; // Background color (black)
    end
end



fh_rom fh_rom_m0(
	.addr(char_y),
	.clk(pix_clk),
	.rst(ren),
	.rd_data(rom_data)
	);



endmodule
