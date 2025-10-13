`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:Meyesemi 
// Engineer: Will
// 
// Create Date: 2023-01-29 20:31  
// Design Name:  
// Module Name: 
// Project Name: 
// Target Devices: Pango
// Tool Versions: 
// Description: 
//      
// Dependencies: 
// 
// Revision:
// Revision 1.0 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define UD #1
module pattern_vg # (
    parameter                            COCLOR_DEPP=8, // number of bits per channel
    parameter                            X_BITS=13,
    parameter                            Y_BITS=13,
    parameter                            H_ACT = 12'd1920,
    parameter                            V_ACT = 12'd1080
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
    output reg[15:0]                        rgb_data
);
    
    always @(posedge pix_clk)
    begin
        vs_out <= `UD vs_in;
        hs_out <= `UD hs_in;
        de_out <= `UD de_in;
    end
    
   

    always @(posedge pix_clk)
    begin
        if (de_in)
        begin
            if(act_x >= (H_ACT/5) && act_x <= (H_ACT - H_ACT/5) && act_y >= (V_ACT/6) && act_y <=(V_ACT - V_ACT/6)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_y >= (V_ACT/6) && act_y <=('d2 + V_ACT/6) && act_x <= (H_ACT/5)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_y >= (V_ACT/3) && act_y <=('d2 + V_ACT/3) && act_x <= (H_ACT/5)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_y >= (V_ACT/2) && act_y <=('d2 + V_ACT/2) && act_x <= (H_ACT/5)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_y >= (V_ACT - V_ACT/3) && act_y <=('d2 + V_ACT - V_ACT/3) && act_x <= (H_ACT/5)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_y >= (V_ACT - V_ACT/6) && act_y <=('d2 + V_ACT - V_ACT/6) && act_x <= (H_ACT/5)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_y >= (V_ACT/6) && act_y <=('d2 + V_ACT/6) && act_x >= (H_ACT - H_ACT/5)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_y >= (V_ACT/3) && act_y <=('d2 + V_ACT/3) && act_x >= (H_ACT - H_ACT/5)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_y >= (V_ACT/2) && act_y <=('d2 + V_ACT/2) && act_x >= (H_ACT - H_ACT/5)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_y >= (V_ACT - V_ACT/3) && act_y <=('d2 + V_ACT - V_ACT/3) && act_x <= (H_ACT/5)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_y >= (V_ACT - V_ACT/3) && act_y <=('d2 + V_ACT - V_ACT/3) && act_x >= (H_ACT - H_ACT/5)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_y >= (V_ACT - V_ACT/6) && act_y <=('d2 + V_ACT - V_ACT/6) && act_x >= (H_ACT - H_ACT/5)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_x >= (H_ACT/5) && act_x <=('d2 + H_ACT/5) && act_y <= (V_ACT/6)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_x >= (H_ACT/5 + H_ACT/5) && act_x <=('d2 + H_ACT/5 + H_ACT/5) && act_y <= (V_ACT/6)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5) && act_x <=('d2 + H_ACT/5 + H_ACT/5 + H_ACT/5) && act_y <= (V_ACT/6)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_x >= (H_ACT - H_ACT/5) && act_x <=('d2 + H_ACT - H_ACT/5) && act_y <= (V_ACT/6)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_x >= (H_ACT/5) && act_x <=('d2 + H_ACT/5) && act_y >= (V_ACT - V_ACT/6)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_x >= (H_ACT/5 + H_ACT/5) && act_x <=('d2 + H_ACT/5 + H_ACT/5) && act_y >= (V_ACT - V_ACT/6)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/5) && act_x <=('d2 + H_ACT/5 + H_ACT/5 + H_ACT/5) && act_y >= (V_ACT - V_ACT/6)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_x >= (H_ACT - H_ACT/5) && act_x <=('d2 + H_ACT - H_ACT/5) && act_y >= (V_ACT - V_ACT/6)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_x >= 77 && act_x <=79 && act_y >= (V_ACT/3 + V_ACT/3 + 65) && act_y <= (V_ACT/3 + V_ACT/3 + 68)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_x >= (H_ACT/5 + H_ACT/5 + H_ACT/10 - 1) && act_x <=(H_ACT/5 + H_ACT/5 + H_ACT/10 + 1) && act_y >= (V_ACT - V_ACT/6)) begin
                rgb_data <= 16'h0000;
            end
            else if(act_x >= 77 + 819 && act_x <=79 + 819 && act_y >= (V_ACT/3 + V_ACT/3 + 65) && act_y <= (V_ACT/3 + V_ACT/3 + 68)) begin
                rgb_data <= 24'hffd700;
            end
            else begin
                rgb_data <= 16'hffff;
            end
        end 
        
    end

endmodule
