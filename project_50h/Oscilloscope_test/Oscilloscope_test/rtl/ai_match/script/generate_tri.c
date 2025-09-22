#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

int main(){

    FILE *fout = fopen("../tri_lut.v", "w");
    if (!fout) { perror("fopen dst");}

    fprintf(fout,"module %s #(\n","tri_lut");
    fprintf(fout,"    parameter DATA_WIDTH = 8\n");
    fprintf(fout,") (\n");
    fprintf(fout,"    input  [DATA_WIDTH-1:0] addr,\n");
    fprintf(fout,"    output [DATA_WIDTH-1:0] data\n");
    fprintf(fout,");\n\n");
    fprintf(fout,"always @(*) begin\n");
    fprintf(fout,"    case (addr)\n");


    for(int i=0;i<255;i++){
        fprintf(fout,"%d : data = %d\n",i,i);
    }
    
    for(int i=255;i>=0;i--){
        fprintf(fout,"%d : data = %d\n",512 - i,i);
    }

    fprintf(fout,"        default: data = 8'h00;\n");
    fprintf(fout,"    endcase\n");
    fprintf(fout,"end\n\n");
    fprintf(fout,"endmodule\n");
    fclose(fout);


    return 0;
}