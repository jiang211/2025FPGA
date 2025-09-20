module DMA(

    input wire clk,
    input wire rst_n,
    input wire[31:0] addr_i,
    input wire[31:0] data_i,
    input wire we_i,
    input wire req_valid_i,
    output wire req_ready_o,
    output wire rsp_valid_o,
    input wire rsp_ready_i,
    output  wire  cs,
    output  reg    [31:0]   VALUE_REG,
    output  wire   [31:0]   DST_ADDR
);

reg [31:0]  DST_ADDR_REG;
reg [31:0]  Number_REG;
reg [31:0]  STATUS_REG;

wire    write_enable;
wire    write_enable00;
wire    write_enable04;
wire    write_enable08;
wire    write_enable0c;

assign DST_ADDR = DST_ADDR_REG;
assign  write_enable = we_i & req_valid_i;
assign  write_enable00 = write_enable & (addr_i[3:2] == 2'h0);
assign  write_enable04 = write_enable & (addr_i[3:2] == 2'h1);
assign  write_enable08 = write_enable & (addr_i[3:2] == 2'h2);
assign  write_enable0c = write_enable & (addr_i[3:2] == 2'h3);

reg     state;
assign  cs = state;

always @(posedge clk or negedge rst_n)
    begin
    if (!rst_n)
        state <= 1'b0;
    else if(Number_REG == 32'd1)
        state <= 1'b0;
    else if(STATUS_REG[0] == 1'b1)
        state <= 1'b1;
    end

always @(posedge clk or negedge rst_n)
    begin
    if (!rst_n)
        VALUE_REG <= 32'd0;
    else if (write_enable00&&state==1'b0)
        VALUE_REG <= data_i;
    end

always @(posedge clk or negedge rst_n)
    begin
    if (!rst_n)
        DST_ADDR_REG <= 32'd0;
    else if(state)
        DST_ADDR_REG <= DST_ADDR_REG + 1'b1;
    else if (write_enable04&&state==1'b0)
        DST_ADDR_REG <= data_i;
    end

always @(posedge clk or negedge rst_n)
    begin
    if (!rst_n)
        Number_REG <= 32'd0;
    else if(state)
        Number_REG <= Number_REG - 1'b1;
    else if (write_enable08&&state==1'b0)
        Number_REG <= data_i;
    end

always @(posedge clk or negedge rst_n)
    begin
    if (!rst_n)
      STATUS_REG <= 32'd0;
    else if (write_enable0c&&state==1'b0)
      STATUS_REG <= data_i;
    else if(Number_REG == 32'd1)
        STATUS_REG <= 32'd0;
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