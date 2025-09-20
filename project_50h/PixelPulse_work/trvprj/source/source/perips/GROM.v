module  GROM
(
    input   wire            clk,
    input   wire            rstn,
    input   wire    [4:0]   x_low,
    input   wire    [4:0]   y_low,
    input   wire    [3:0]   GROM_ADDR,
    output  reg     [23:0]  pixel_data
);

reg     [31:0]GROM0[0:31];
reg     [31:0]GROM1[0:31];
reg     [31:0]GROM2[0:31];
reg     [31:0]GROM3[0:31];
reg     [31:0]GROM4[0:31];
reg     [31:0]GROM5[0:31];
reg     [31:0]GROM6[0:31];
reg     [31:0]GROM7[0:31];
reg     [31:0]GROM8[0:31];
reg     [31:0]GROM9[0:31];
reg     [31:0]GROM10[0:31];
reg     [31:0]GROM11[0:31];
reg     [31:0]GROM12[0:31];
reg     [31:0]GROM13[0:31];
reg     [31:0]GROM14[0:31];
reg     [31:0]GROM15[0:31];

initial begin	
        $readmemh("D:/BaiduNetdiskDownload/PixelPulse_work/PixelPulse_work/trvprj/WordsLib/grom0.txt",GROM0);
        $readmemh("D:/BaiduNetdiskDownload/PixelPulse_work/PixelPulse_work/trvprj/WordsLib/grom1.txt",GROM1);
        $readmemh("D:/BaiduNetdiskDownload/PixelPulse_work/PixelPulse_work/trvprj/WordsLib/grom2.txt",GROM2);
        $readmemh("D:/BaiduNetdiskDownload/PixelPulse_work/PixelPulse_work/trvprj/WordsLib/grom3.txt",GROM3);
        $readmemh("D:/BaiduNetdiskDownload/PixelPulse_work/PixelPulse_work/trvprj/WordsLib/grom4.txt",GROM4);
        $readmemh("D:/BaiduNetdiskDownload/PixelPulse_work/PixelPulse_work/trvprj/WordsLib/grom5.txt",GROM5);
        $readmemh("D:/BaiduNetdiskDownload/PixelPulse_work/PixelPulse_work/trvprj/WordsLib/grom6.txt",GROM6);
        $readmemh("D:/BaiduNetdiskDownload/PixelPulse_work/PixelPulse_work/trvprj/WordsLib/grom7.txt",GROM7);
        $readmemh("D:/BaiduNetdiskDownload/PixelPulse_work/PixelPulse_work/trvprj/WordsLib/grom8.txt",GROM8);
        $readmemh("D:/BaiduNetdiskDownload/PixelPulse_work/PixelPulse_work/trvprj/WordsLib/grom9.txt",GROM9);
        $readmemh("D:/BaiduNetdiskDownload/PixelPulse_work/PixelPulse_work/trvprj/WordsLib/grom10.txt",GROM10);
        $readmemh("D:/BaiduNetdiskDownload/PixelPulse_work/PixelPulse_work/trvprj/WordsLib/grom11.txt",GROM11);
        $readmemh("D:/BaiduNetdiskDownload/PixelPulse_work/PixelPulse_work/trvprj/WordsLib/grom12.txt",GROM12);
        $readmemh("D:/BaiduNetdiskDownload/PixelPulse_work/PixelPulse_work/trvprj/WordsLib/grom13.txt",GROM13);
        $readmemh("D:/BaiduNetdiskDownload/PixelPulse_work/PixelPulse_work/trvprj/WordsLib/grom14.txt",GROM14);
        $readmemh("D:/BaiduNetdiskDownload/PixelPulse_work/PixelPulse_work/trvprj/WordsLib/grom15.txt",GROM15);
    end


//读取字库
always @(posedge clk or negedge rstn)
    if(!rstn)
        pixel_data <= {24{1'd0}};
    else
        case(GROM_ADDR)
        4'd0:   pixel_data <= {24{GROM0[y_low][x_low]}};
        4'd1:   pixel_data <= {24{GROM1[y_low][x_low]}};
        4'd2:   pixel_data <= {24{GROM2[y_low][x_low]}};
        4'd3:   pixel_data <= {24{GROM3[y_low][x_low]}};
        4'd4:   pixel_data <= {24{GROM4[y_low][x_low]}};
        4'd5:   pixel_data <= {24{GROM5[y_low][x_low]}};
        4'd6:   pixel_data <= {24{GROM6[y_low][x_low]}};
        4'd7:   pixel_data <= {24{GROM7[y_low][x_low]}};
        4'd8:   pixel_data <= {24{GROM8[y_low][x_low]}};
        4'd9:   pixel_data <= {24{GROM9[y_low][x_low]}};
        4'd10:   pixel_data <= {24{GROM10[y_low][x_low]}};
        4'd11:   pixel_data <= {24{GROM11[y_low][x_low]}};
        4'd12:   pixel_data <= {24{GROM12[y_low][x_low]}};
        4'd13:   pixel_data <= {24{GROM13[y_low][x_low]}};
        4'd14:   pixel_data <= {24{GROM14[y_low][x_low]}};
        4'd15:   pixel_data <= {24{GROM15[y_low][x_low]}};
        default:pixel_data <= {24{1'd0}};
        endcase

endmodule