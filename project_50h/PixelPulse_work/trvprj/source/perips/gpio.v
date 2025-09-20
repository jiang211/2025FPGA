 /*                                                                      
 Copyright 2020 Blue Liang, liangkangnan@163.com
                                                                         
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
                                                                         
     http://www.apache.org/licenses/LICENSE-2.0                          
                                                                         
 Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
 */

// GPIO模块
module gpio(

    input wire clk,
    input wire rst_n,
    input wire[31:0] addr_i,
    input wire[31:0] data_i,
    //input wire[3:0] sel_i,
    input wire we_i,
	output wire[31:0] data_o,

    input wire req_valid_i,
    output wire req_ready_o,
    output wire rsp_valid_o,
    input wire rsp_ready_i,

    input wire [15:0] GPI,
    output wire [15:0] GPO,
    output reg [15:0] GPIO_CR    // 0x00
    );

    reg [15:0] GPO_DATA;         // 0x04
    reg [15:0] GPI_DATA;         // 0x08
    reg [15:0] data_r;

    wire write_enable00;
    wire write_enable04;
    wire wen;
    wire ren;

    assign wen = we_i & req_valid_i;
    assign ren = (~we_i) & req_valid_i;
    assign data_o = {16'd0, data_r};
    assign write_enable00 = wen & (addr_i[3:2] == 2'h0);
    assign write_enable04 = wen & (addr_i[3:2] == 2'h1);
    assign GPO = GPO_DATA;

    always @ (posedge clk or negedge rst_n)
        if (!rst_n)
            GPIO_CR <= 16'd0;
        else if(write_enable00)
            GPIO_CR <= data_i[15:0];
        else
            GPIO_CR <= GPIO_CR;

    always @ (posedge clk or negedge rst_n)
        if (!rst_n)
            GPO_DATA <= 16'd0;
        else if(write_enable04)
            GPO_DATA <= data_i[15:0];
        else
            GPO_DATA <= GPO_DATA;

    always @ (posedge clk or negedge rst_n)
        if (!rst_n)
            GPI_DATA <= 16'd0;
        else
            GPI_DATA <= GPI;

    always @ (posedge clk or negedge rst_n)
        if (!rst_n)
            data_r <= 16'd0;
        else if(ren)   begin
            case(addr_i[3:2])
                2'h0 : data_r <= GPIO_CR;
                2'h1 : data_r <= GPO_DATA;
                2'h2 : data_r <= GPI_DATA;
                default:data_r <= 16'd0;
            endcase
        end        
        else
            data_r <= 16'd0;
        
    vld_rdy #(
        .CUT_READY(0)
    ) u_vld_rdy(
        .clk(clk),
        .rst_n(rst_n),
        .vld_i(req_valid_i),
        .rdy_o(req_ready_o),
        .rdy_i(rsp_ready_i),
        .vld_o(rsp_valid_o)
    );

endmodule
