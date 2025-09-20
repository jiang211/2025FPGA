module  GRAM
(
    input   wire            clk,
	input 	wire 			rst_n,
    input   wire            we_i,
    input   wire   [31:0]   data_i,
    input   wire   [31:0]   addr_i,
    input   wire   [31:0]   DMA_ADDR,
    input   wire   [31:0]   DMA_DATA,
    input   wire            cs,
    input   wire   [8:0]    GRAM_ADDR,
    output  reg    [3:0]    GRAM_DATA,
    input wire req_valid_i,
    output wire req_ready_o,
    output wire rsp_valid_o,
    input wire rsp_ready_i
);

reg     [3:0]GRAM[0:374];
wire    wen;

assign  PRDATA = 32'd0;
assign  PREADY = 1'b1;
assign  PSLVERR = 1'b0;

assign  wen = we_i & req_valid_i;

always @(posedge clk)
    begin
    if(wen)
        GRAM[addr_i[11:2]] <= data_i[3:0];
    else if(cs)
        GRAM[DMA_ADDR[9:0]] <= DMA_DATA;
    end

always @(posedge clk or negedge rst_n)
    begin
    if (!rst_n)
        GRAM_DATA <= 4'd0;
    else
        GRAM_DATA <= GRAM[GRAM_ADDR];
    end

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
