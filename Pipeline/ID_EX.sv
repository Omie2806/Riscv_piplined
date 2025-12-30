module ID_EX (
    input logic clk,
    input logic reset,
    input logic flush,

//DATAPATH
    input wire[31:0] ID_RD1,
    input wire[31:0] ID_RD2,
    input wire[31:0] ID_pc,
    input wire[31:0] ID_imm_ext,
    input wire[4:0]  ID_rd, 
    input wire[4:0]  ID_rs1,
    input wire[4:0]  ID_rs2,  

//CONTROL
    input wire ID_reg_write,
    input wire ID_result_src,
    input wire ID_alu_src,
    input wire ID_mem_write,
    input wire ID_branch,
    input wire[2:0] ID_alu_control,

//OUTPUT DATAPATH
    output reg[31:0] EX_RD1,
    output reg[31:0] EX_RD2,
    output reg[31:0] EX_pc,
    output reg[31:0] EX_imm_ext,
    output reg[4:0]  EX_rd,
    output reg[4:0]  EX_rs1,
    output reg[4:0]  EX_rs2,

//OUTPUT CONTROL
    output reg EX_reg_write,
    output reg EX_result_src,
    output reg EX_alu_src,
    output reg EX_mem_write,
    output reg EX_branch,
    output reg[2:0] EX_alu_control
);

always @(posedge clk or posedge reset) begin
    if(reset || flush) begin
        //DATAPATH
        EX_RD1         <= 32'b0;
        EX_RD2         <= 32'b0;
        EX_pc          <= 32'b0;
        EX_imm_ext     <= 32'b0;
        EX_rd          <= 5'b0;
        EX_rs1         <= 5'b0;
        EX_rs2         <= 5'b0;

        //CONTROL
        EX_reg_write   <= 1'b0;
        EX_result_src  <= 1'b0;
        EX_alu_src     <= 1'b0;
        EX_mem_write   <= 1'b0;
        EX_branch      <= 1'b0;
        EX_alu_control <= 3'b0;
    end
    else begin
        //DATAPATH
        EX_RD1         <= ID_RD1;
        EX_RD2         <= ID_RD2;
        EX_pc          <= ID_pc;
        EX_imm_ext     <= ID_imm_ext;
        EX_rd          <= ID_rd;
        EX_rs1         <= ID_rs1;
        EX_rs2         <= ID_rs2;

        //CONTROL
        EX_reg_write   <= ID_reg_write;
        EX_result_src  <= ID_result_src;
        EX_alu_src     <= ID_alu_src;
        EX_mem_write   <= ID_mem_write;
        EX_branch      <= ID_branch;
        EX_alu_control <= ID_alu_control;
    end
end
endmodule