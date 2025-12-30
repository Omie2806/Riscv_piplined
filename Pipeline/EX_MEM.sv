module EX_MEM (
    input logic clk,
    input logic reset,
    input logic flush,

    //DATAPATH
    input wire[31:0] EX_alu_result,
    input wire[31:0] EX_write_data,
    input wire[4:0]  EX_rd,

    //CONTROL
    input wire EX_reg_write,
    input wire EX_result_src,
    input wire EX_mem_write,

    //OUTPUT DATAPATH
    output reg[31:0] MEM_alu_result,
    output reg[31:0] MEM_write_data,
    output reg[4:0]  MEM_rd,

    //OUTPUT CONTROL
    output reg MEM_reg_write,
    output reg MEM_result_src,
    output reg MEM_mem_write
);

always @(posedge clk or posedge reset) begin
    if(reset || flush) begin
        MEM_alu_result <= 32'b0;
        MEM_write_data <= 32'b0;
        MEM_rd         <= 5'b0;

        MEM_reg_write  <= 1'b0;
        MEM_result_src <= 1'b0;
        MEM_mem_write  <= 1'b0;
    end
    else begin
        MEM_alu_result <= EX_alu_result;
        MEM_write_data <= EX_write_data;
        MEM_rd         <= EX_rd;

        MEM_reg_write  <= EX_reg_write;
        MEM_result_src <= EX_result_src;
        MEM_mem_write  <= EX_mem_write;
    end
end
endmodule