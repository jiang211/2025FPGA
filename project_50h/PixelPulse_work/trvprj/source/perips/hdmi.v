`define UD #1

module hdmi(
    input wire        sys_clk       ,//50MHz    
    output            rstn_out      ,
	output wire [9:0]  GRAM_ADDR,
	output wire [3:0]  GROM_ADDR,
	output wire [4:0]  x_low,
	output wire [4:0]  y_low,
	input wire [3:0]   GRAM_DATA,
	input wire [23:0]  pixel_data,
//hdmi_out 
    input             pix_clk       ,//148.5MHz  
	input			  cfg_clk		,//10MHz
    output            vs_out        , 
    output            hs_out        , 
    output            de_out        ,
    output     [7:0]  r_out         , 
    output     [7:0]  g_out         , 
    output     [7:0]  b_out         
);

parameter   X_WIDTH = 4'd11;
parameter   Y_WIDTH = 4'd11;    

//MODE_1024*600
    parameter V_TOTAL = 12'd635;
    parameter V_FP = 12'd15;
    parameter V_BP = 12'd14;
    parameter V_SYNC = 12'd6;
    parameter V_ACT = 12'd600;
    //
    parameter H_TOTAL = 12'd1344;
    parameter H_FP = 12'd168;
    parameter H_BP = 12'd120;
    parameter H_SYNC = 12'd32;
    parameter H_ACT = 12'd1024;
    parameter HV_OFFSET = 12'd0;

    wire                        cfg_clk    ;
    wire                        rstn       ;
    wire                        init_over  ;
    reg  [15:0]                 rstn_1ms   ;
    wire [X_WIDTH - 1'b1:0]     act_x      ;
    wire [Y_WIDTH - 1'b1:0]     act_y      ;    
    wire                        hs         ;
    wire                        vs         ;
    wire                        de         ;
    reg  [3:0]                  reset_delay_cnt;
    
    always @(posedge cfg_clk)
    begin
    	if(!locked)
    	    rstn_1ms <= 16'd0;
    	else
    	begin
    		if(rstn_1ms == 16'h2710)
    		    rstn_1ms <= rstn_1ms;
    		else
    		    rstn_1ms <= rstn_1ms + 1'b1;
    	end
    end
    
    assign rstn_out = (rstn_1ms == 16'h2710);
	assign b_out = pixel_data[7:0];
	assign g_out = pixel_data[15:8];
	assign r_out = pixel_data[23:16];

    sync_vg #(
        .X_BITS               (  X_WIDTH              ), 
        .Y_BITS               (  Y_WIDTH              ),
        .V_TOTAL              (  V_TOTAL              ),//                        
        .V_FP                 (  V_FP                 ),//                        
        .V_BP                 (  V_BP                 ),//                        
        .V_SYNC               (  V_SYNC               ),//                        
        .V_ACT                (  V_ACT                ),//                        
        .H_TOTAL              (  H_TOTAL              ),//                        
        .H_FP                 (  H_FP                 ),//                        
        .H_BP                 (  H_BP                 ),//                        
        .H_SYNC               (  H_SYNC               ),//                        
        .H_ACT                (  H_ACT                ) //                        
 
    ) sync_vg                                         
    (                                                 
        .clk                  (  pix_clk               ),//input                   clk,                                 
        .rstn                 (  rstn_out                 ),//input                   rstn,                            
        .vs_out               (  vs                   ),//output reg              vs_out,                                                                                                                                      
        .hs_out               (  hs                   ),//output reg              hs_out,            
        .de_out               (  de                   ),//output reg              de_out,             
        .x_act                (  act_x                ),//output reg [X_BITS-1:0] x_out,             
        .y_act                (  act_y                ) //output reg [Y_BITS:0]   y_out,             
    );
	
	hdmi_ctrl
	(
		.clk					(pix_clk),
		.rst_n					(rstn_out),
		.vs						(vs),
		.hs						(hs),
		.de						(de),
		.vs_out					(vs_out),
		.hs_out					(hs_out),
		.de_out					(de_out),
		.GRAM_ADDR				(GRAM_ADDR),
		.GROM_ADDR				(GROM_ADDR),
		.pixel_xpos				(act_x),
		.pixel_ypos				(act_y),
		.GRAM_DATA				(GRAM_DATA),
		.x_low					(x_low),
		.y_low					(y_low)
	);
	
    /*
    pattern_vg #(
        .COCLOR_DEPP          (  8                    ), // Bits per channel
        .X_BITS               (  X_WIDTH              ),
        .Y_BITS               (  Y_WIDTH              ),
        .H_ACT                (  H_ACT                ),
        .V_ACT                (  V_ACT                )
    ) // Number of fractional bits for ramp pattern
    pattern_vg (
        .rstn                 (  rstn_out                 ),//input                         rstn,                                                     
        .pix_clk              (  pix_clk               ),//input                         clk_in,  
        .act_x                (  act_x                ),//input      [X_BITS-1:0]       x,   
        // input video timing
        .vs_in                (  vs                   ),//input                         vn_in                        
        .hs_in                (  hs                   ),//input                         hn_in,                           
        .de_in                (  de                   ),//input                         dn_in,
        // test pattern image output                                                    
        .vs_out               (  vs_out               ),//output reg                    vn_out,                       
        .hs_out               (  hs_out               ),//output reg                    hn_out,                       
        .de_out               (  de_out               ),//output reg                    den_out,                      
        .r_out                (  r_out                ),//output reg [COCLOR_DEPP-1:0]  r_out,                      
        .g_out                (  g_out                ),//output reg [COCLOR_DEPP-1:0]  g_out,                       
        .b_out                (  b_out                ) //output reg [COCLOR_DEPP-1:0]  b_out   
    );
	*/
	
endmodule