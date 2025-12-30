module load_stall (
    //DATAPATH
    input wire[4:0] ID_rs1,
    input wire[4:0] ID_rs2,
    input wire[4:0] EX_rd,

    //CONTROL
    input wire EX_result_src,

    output reg stall,
    output reg flush
);
    always @(*) begin
        stall = 1'b0;
        flush = 1'b0;
        if((ID_rs1 == EX_rd || ID_rs2 == EX_rd) && EX_result_src == 1 && EX_rd != 0) begin
            stall = 1'b1;
            flush = 1'b1;
        end
    end
endmodule