module dds(
   input    wire  clk_50M        ,
   input    wire  [7:0]key,
   output   wire  da_clk         ,
   output   wire  [7:0]da_data   
   );

wire rst_n ;
wire clk_125M ;
wire [7:0] da_data_;
reg   [10:0]rom_addr ;
wire  [7:0]rom_data_out1;
wire  [7:0]rom_data_out2;
wire  [7:0]rom_data_out3;
wire  [7:0]rom_data_out4;
wire  [7:0]rom_data_out5;
wire [9:0] fre;
wire [1:0] select,select_;
wire [1:0] amp;
assign da_clk = clk_125M  ;
 

ad_clock_125m u_pll1 (
  .clkin1(clk_50M),          // input
  .pll_lock(rst_n),          // output
  .clkout0(clk_125M)         // output
);

choice u_choice(
    .clk(clk_125M),
    .rst_n(rst_n),
    .key(key),
    .select_(select),
    .amp_(amp),
    .fre_(fre)
);

always @(negedge clk_125M or negedge rst_n) begin
   if (!rst_n)
      rom_addr <= 11'd0 ;
   else if (rom_addr >= 11'd1023)
      rom_addr <= 11'd0 ;
   else
      rom_addr <= rom_addr + fre     ;                //The output wave frequency is 122Khz
//    rom_addr <= rom_addr + 10'd2     ;                //The output wave frequency is 244Khz
//    rom_addr <= rom_addr + 10'd4     ;                //The output wave frequency is 488Khz
//    rom_addr <= rom_addr + 10'd32    ;                //The output wave frequency is 3.9Mhz
//    rom_addr <= rom_addr + 10'd128   ;                //The output wave frequency is 15.6Mhz
end

assign da_data = da_data_/amp;//(da_data_ >= 'd128) ? (da_data_ - (da_data_ - 'd128)*amp/10) : da_data_ + ('d128 - da_data_)*amp/10;

assign da_data_ = (select == 2'd0)? rom_data_out1 :
                  (select == 2'd1)? rom_data_out2 :
                  (select == 2'd2)? rom_data_out3 :
                  (select == 2'd3)? rom_data_out4 :
                 rom_data_out2;

//assign da_data_ =  rom_data_out1;
rom_saw_wave u_rom1 (
  .addr(rom_addr[9:0]),      
  .clk(clk_125M),            
  .rst(1'b0),                
  .rd_data(rom_data_out1)    
);
rom_sin_wave u_rom2 (
  .addr(rom_addr[9:0]),      
  .clk(clk_125M),            
  .rst(1'b0),                
  .rd_data(rom_data_out2)    
);
rom_squ_wave u_rom3 (
  .addr(rom_addr[9:0]),      
  .clk(clk_125M),            
  .rst(1'b0),                
  .rd_data(rom_data_out3)    
);
rom_tri_wave u_rom4 (
  .addr(rom_addr[9:0]),      
  .clk(clk_125M),            
  .rst(1'b0),                
  .rd_data(rom_data_out4)    
);

endmodule