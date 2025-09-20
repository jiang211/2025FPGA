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

module led_test(
    input          clk,
    input          rstn,
    input          en,
    output         beef  
);

    reg [26:0] led_light_cnt    = 27'd0         ;


//en拉高叫0.25秒，一直高一直叫
//beef使能
wire en;
reg [2:0] state=3'd1;
wire high;
reg high_ff;
assign high=high_ff;
always @(posedge clk or negedge rstn)
begin
   if (!rstn) begin
       state<=3'd1;
       led_light_cnt <= `UD 27'd0;
       high_ff<=1'b0;
       end
   else begin      
    case (state)
       3'd1: 
       begin
       if(en) begin
            state <= 3'd2;
            end             
       end
       3'd2: 
       begin
       if(led_light_cnt == 27'd12_500_000)begin
            led_light_cnt <= `UD 27'd0;
            high_ff<=1'b0;
            state <= 3'd1;
            end
       else begin
            led_light_cnt <= `UD led_light_cnt + 27'd1;
            high_ff<=1'b1; 
            end               
       end             
      default: 
       begin
      	state <= 3'd1;
       end
    endcase     
   end
end 


//beef叫
reg [17:0]cnt;
always @(posedge clk)
    begin
        if(!rstn)
            cnt <= `UD 18'd0;
        else if(cnt == 18'd25_000)
            cnt <= `UD 18'd0;
        else if(high)
            cnt <= `UD cnt + 18'd1; 
    end
    
reg  beef_ff=1'b0;

always @(posedge clk)
    begin
        if(!rstn)
            beef_ff <= 1'b0;
        else if(cnt == 18'd12_500)
            beef_ff <=beef_ff+1'b1;
    end
wire beef;
assign beef=beef_ff;


    
endmodule
