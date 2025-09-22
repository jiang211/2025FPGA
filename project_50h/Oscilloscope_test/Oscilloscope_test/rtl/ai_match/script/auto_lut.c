#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

void printf_verilog(const char *dst, const char *src)
{
    FILE *fin  = NULL;
    FILE *fout = NULL;
    uint8_t *bin_buf = NULL;   /* 存转换后的字节 */
    char    *txt_buf = NULL;   /* 存格式化文本 */
    size_t   bin_cnt = 0;
    size_t   txt_max = 0;
    char     line[32];
    int      ret = -1;

    /* 1. 打开源文件 */
    fin = fopen(src, "r");
    if (!fin) { perror("fopen src"); goto END; }

    /* 2. 预先给 bin_buf 一点空间 */
    int bin_max = 256;
    bin_buf = malloc(bin_max);
    if (!bin_buf) { perror("malloc bin_buf"); goto END; }

    /* 3. 逐行读，只拿数字 */
    while (fgets(line, sizeof(line), fin)) {
        unsigned int val;
        /* 去掉换行符 */
        line[strcspn(line, "\r\n")] = 0;
        if (line[0] == '\0') continue;          /* 空行跳过 */
        if (sscanf(line, "%x", &val) != 1) {
            fprintf(stderr, "skip bad line: %s\n", line);
            continue;
        }
        /* 动态扩容 */
        if (bin_cnt == bin_max) {
            bin_max *= 2;
            bin_buf = realloc(bin_buf, bin_max);
            if (!bin_buf) { perror("realloc"); goto END; }
        }
        bin_buf[bin_cnt++] = (uint8_t)(val & 0xFF);
    }

    /* 4. 给文本缓冲区留足空间（每字节最大 20 字符保险） */
    txt_max = bin_cnt * 20 + 1;
    txt_buf = malloc(txt_max);
    if (!txt_buf) { perror("malloc txt_buf"); goto END; }

    /* 5. sprintf 生成文本 */
    size_t pos = 0;
    for (size_t i = 0; i < bin_cnt; ++i) {
        if((i %2 == 0 && i>=2) || i==0 )
        pos += snprintf(txt_buf + pos, txt_max - pos,
                        "%zu : data = 8'h%02X;\n", i/2, bin_buf[i]);
    }

    /* 6. 写入目标文件 */
    fout = fopen(dst, "a");
    if (!fout) { perror("fopen dst"); goto END; }
    if (fwrite(txt_buf, 1, pos, fout) != pos) { perror("fwrite"); goto END; }

    ret = 0;        /* 成功 */
END:
    if (fin)  fclose(fin);
    if (fout) fclose(fout);
    free(bin_buf);
    free(txt_buf);
}

void printf_file(const char *dst, const char *src,char *module_name){


    FILE *fout = fopen(dst, "w");
    if (!fout) { perror("fopen dst");}

    fprintf(fout,"module %s #(\n",module_name);
    fprintf(fout,"    parameter DATA_WIDTH = 8\n");
    fprintf(fout,") (\n");
    fprintf(fout,"    input  [DATA_WIDTH:0] addr,\n");
    fprintf(fout,"    output reg [DATA_WIDTH-1:0] data\n");
    fprintf(fout,");\n\n");
    fprintf(fout,"always @(*) begin\n");
    fprintf(fout,"    case (addr)\n");
    fclose(fout);

    printf_verilog(dst,src);

    fout = fopen(dst, "a");
    if (!fout) { perror("fopen dst");}
    
    fprintf(fout,"        default: data = 8'h00;\n");
    fprintf(fout,"    endcase\n");
    fprintf(fout,"end\n\n");
    fprintf(fout,"endmodule\n");
    fclose(fout);

}
int main(void)
{
    printf_file("../lut/sin_lut.v","sin_1024.txt","sin_lut");
    return 0;
}