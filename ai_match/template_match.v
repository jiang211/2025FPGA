//进行模板匹配
//共需要进行两次匹配，总匹配程度高为识别的类型
//模板1为标准波形模板匹配
//模板2为求导后的模板匹配

module template_match #(
    localparam THRESHOLD0 = 20,
    localparam THRESHOLD1 = 2
) (
    input clk,
    input rst_n,

    input wave_valid,
    output type_valid,


    input [7:0] tri_template,
    input [7:0] sqr_template,
    input [7:0] sin_template,
    input [7:0] dtri_template,
    input [7:0] dsin_template,
    input [7:0] wave_in,
    input [7:0] dwave_in,
    output reg [1:0] wave_type
);
    
reg  [8:0] tri_template_cnt0;        //模板1匹配
reg  [8:0] tri_template_cnt1;        //模板2匹配
reg  [8:0] sqr_template_cnt0;
reg  [8:0] sqr_template_cnt1;
wire [8:0] sin_template_cnt0;
reg  [8:0] sin_template_cnt1;

always @(posedge clk )begin
    if(!rst_n)begin
        tri_template_cnt0 <= 256;
        tri_template_cnt1 <= 256;
        sqr_template_cnt0 <= 256;
        sqr_template_cnt1 <= 256;
        sin_template_cnt1 <= 256;

    end
    else begin
        if(wave_valid)begin
            //三角波模板1匹配
            if(tri_template-wave_in <= THRESHOLD0 || wave_in - tri_template <= THRESHOLD0)begin
                tri_template_cnt0 <= tri_template_cnt0 + 1;
            end else tri_template_cnt0 <= tri_template_cnt0 - 1;

            //方波匹配模板1匹配
            if(sqr_template-wave_in <= THRESHOLD0 || wave_in - sqr_template <= THRESHOLD0)begin
                sqr_template_cnt0 <= sqr_template_cnt0 + 1;
            end else sqr_template_cnt0 <= sqr_template_cnt0 - 1;

            //三角波模板2匹配
            if(dtri_template-dwave_in <= THRESHOLD1 || dwave_in - dtri_template <= THRESHOLD1)begin
                tri_template_cnt1 <= tri_template_cnt1 + 1;
            end else tri_template_cnt1 <= tri_template_cnt1 - 1;

            //方波匹配模板2匹配
            if(dwave_in <= 128 + THRESHOLD1 || dwave_in <= 128 - THRESHOLD1)begin
                sqr_template_cnt1 <= sqr_template_cnt1 + 1;
            end else sqr_template_cnt1 <= sqr_template_cnt1 - 1;

            //正弦波模板2匹配
            if(dsin_template-dwave_in <= THRESHOLD1 || dwave_in - dsin_template <= THRESHOLD1)begin
                sin_template_cnt1 <= sin_template_cnt1 + 1;
            end else sin_template_cnt1 <= sin_template_cnt1 - 1;
        end
    end
end

assign sin_template_cnt0 = tri_template_cnt0;


localparam TRI_WAVE = 0;
localparam SQR_WAVE = 1;
localparam SIN_WAVE = 2;

wire [9:0] tri_template_cnt_total = tri_template_cnt0 + tri_template_cnt1;
wire [9:0] sqr_template_cnt_total = sqr_template_cnt0 + sqr_template_cnt1;
wire [9:0] sin_template_cnt_total = sin_template_cnt0 +sin_template_cnt1;

always @(posedge clk )begin
    if(!rst_n)begin
        wave_type <= TRI_WAVE;
    end
    else begin
        if(tri_template_cnt_total >= sqr_template_cnt_total && tri_template_cnt_total >= sin_template_cnt_total)begin
            wave_type <= TRI_WAVE;
        end 
        else if (sqr_template_cnt_total >= tri_template_cnt_total && sqr_template_cnt_total >= sin_template_cnt_total)begin
            wave_type <= SQR_WAVE;
        end
        else if(sin_template_cnt_total >= tri_template_cnt_total && sin_template_cnt_total >= tri_template_cnt_total)begin
            wave_type <= SIN_WAVE;
        end
    end
end

endmodule