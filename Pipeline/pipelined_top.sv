module pipelined_top (
    input logic clk,
    input logic reset
);
// PC
logic [31:0] pc, PC_Next, PC_Target, PC_Plus_4;

//instruction memory
logic [31:0] instr;

//IF_ID
logic IF_ID_stall, IF_ID_flush;
logic[31:0] IF_ID_instr, IF_ID_pc; 

//register file
logic [4:0] rs1, rs2, rd;
logic [31:0] rd1, rd2;

//imm_gen
logic [31:0] imm_ext;

//control unit
logic ID_branch, ID_result_src, ID_alu_src, ID_mem_write, ID_reg_write;
logic [2:0] ID_alu_control;
logic [4:0] ID_rd, ID_rs1, ID_rs2;

//ID_EX
logic ID_EX_flush;
logic EX_branch, EX_result_src, EX_alu_src, EX_mem_write, EX_reg_write;
logic [2:0]  EX_alu_control;

logic [31:0] EX_RD1, EX_RD2, EX_imm_ext, EX_pc;
logic [4:0]  EX_rd, EX_rs1, EX_rs2;

//alu
logic [31:0] ALU_result;
logic zero;

//EX_MEM
logic [31:0] EX_alu_result, EX_write_data;
logic MEM_mem_write, MEM_reg_write, MEM_result_src;
logic [4:0] MEM_rd, MEM_rs1, MEM_rs2;
logic [31:0] MEM_alu_result, MEM_write_data;

//data_mem
logic [31:0] Read_Data;

//MEM_WB
logic [31:0] MEM_read_data, WB_alu_result, WB_read_data, WB_Result;
logic [4:0] WB_rd, WB_rs1, WB_rs2;
logic WB_reg_write, WB_result_src;


//decode
logic [6:0] opcode;
logic [2:0] func3;
logic func75;

pc pc_inst (
    .clk(clk),
    .reset(reset),
    .stall(IF_ID_stall),
    .next_pc(PC_Next),
    .pc(pc)
);

instruction_mem instr_mem (
    .A_instr(pc),
    .instr(instr)
);

IF_ID if_id (
    .clk(clk),
    .reset(reset),
    .pc(pc),
    .flush(IF_ID_flush),
    .stall(IF_ID_stall),
    .instr(instr),
    .IF_ID_instr(IF_ID_instr),
    .IF_ID_pc(IF_ID_pc)
);

imm_gen imm_gen_inst (
    .instr   (IF_ID_instr),
    .imm_ext (imm_ext)
);

assign PC_Plus_4 = pc + 32'd4;
assign PC_Target = EX_pc + EX_imm_ext;
assign PC_Next   = (EX_branch && zero) ? PC_Target : PC_Plus_4;

assign opcode = IF_ID_instr[6:0];
assign rs1    = IF_ID_instr[19:15];
assign rs2    = IF_ID_instr[24:20];
assign rd     = IF_ID_instr[11:7];

//control unit assignment
assign func3  = IF_ID_instr[14:12];
assign func75 = IF_ID_instr[30];

assign IF_ID_flush       = EX_branch && zero;

regfile regfile_inst (
    .clk(clk),
    .reset(reset),
    .write_en(WB_reg_write),
    .A1(rs1),
    .A2(rs2),
    .A3(WB_rd),
    .WD3(WB_result_src ? WB_read_data : WB_alu_result),
    .RD1(rd1),
    .RD2(rd2)
);

//CONTROL UNIT
always_comb begin
    // defaults
    ID_reg_write   = 0;
    ID_mem_write   = 0;
    ID_alu_src     = 0;
    ID_branch  = 0;
    ID_result_src  = 0;
    ID_alu_control = 3'b000;

    case (opcode)

        7'b0110011: begin // R-type
            ID_reg_write = 1;
            case (func3)
                3'b000: begin
                        if (func75) ID_alu_control = 3'b001; // SUB
                        else ID_alu_control        = 3'b000; // ADD
                        end
                3'b010: ID_alu_control = 3'b101;//slt
                
                3'b110: ID_alu_control = 3'b011;//or

                3'b111: ID_alu_control = 3'b010;//and
            endcase
        end

        7'b0010011: begin //addi
            ID_alu_src     = 1;
            ID_reg_write   = 1;
            case (func3)
                3'b000: ID_alu_control  = 3'b000; // ADDI
                3'b111: ID_alu_control  = 3'b010; // ANDI
                3'b110: ID_alu_control  = 3'b011; // ORI
                3'b100: ID_alu_control  = 3'b101; // XORI
                3'b010: ID_alu_control  = 3'b100; // SLTI
                default: ID_alu_control = 3'b000;
            endcase
        end

        7'b0000011: begin // LW
            ID_alu_src     = 1;
            ID_reg_write   = 1;
            ID_result_src  = 1;
            ID_alu_control = 3'b000;
        end

        7'b0100011: begin // SW
            ID_alu_src      = 1;
            ID_mem_write    = 1;
            ID_alu_control  = 3'b000;
        end

        7'b1100011: begin // BEQ
            ID_branch      = 1;
            ID_alu_control = 3'b001; // SUB
        end
    endcase
end

ID_EX id_ex (
    .clk(clk),
    .reset(reset),
    .flush(ID_EX_flush),
    .ID_RD1(rd1),
    .ID_RD2(rd2),
    .ID_pc(IF_ID_pc),
    .ID_rd(rd),
    .ID_rs1(rs1),
    .ID_rs2(rs2),
    .ID_imm_ext(imm_ext),
    .ID_alu_control(ID_alu_control),
    .ID_alu_src(ID_alu_src),
    .ID_branch(ID_branch),
    .ID_reg_write(ID_reg_write),
    .ID_result_src(ID_result_src),
    .ID_mem_write(ID_mem_write),
    .EX_RD1(EX_RD1),
    .EX_RD2(EX_RD2),
    .EX_pc(EX_pc),
    .EX_imm_ext(EX_imm_ext),
    .EX_rd(EX_rd),
    .EX_rs1(EX_rs1),
    .EX_rs2(EX_rs2),
    .EX_alu_control(EX_alu_control),
    .EX_alu_src(EX_alu_src),
    .EX_branch(EX_branch),
    .EX_mem_write(EX_mem_write),
    .EX_reg_write(EX_reg_write),
    .EX_result_src(EX_result_src)
);

logic[1:0] Forward_ScrA, Forward_ScrB;

forward fwd_inst (
    .EX_rs1(EX_rs1),
    .EX_rs2(EX_rs2),
    .MEM_reg_write(MEM_reg_write),
    .MEM_rd(MEM_rd),
    .WB_reg_write(WB_reg_write),
    .WB_rd(WB_rd),
    .Forward_ScrA(Forward_ScrA),
    .Forward_ScrB(Forward_ScrB)
);

logic[31:0] alu_A, alu_B;

always @(*) begin

case (Forward_ScrA)
    2'b00: alu_A = EX_RD1;
    2'b10: alu_A = MEM_alu_result;
    2'b01: alu_A = WB_Result ;
    default: alu_A = EX_RD1;
endcase

case (Forward_ScrB)
    2'b00: alu_B = EX_RD2;
    2'b10: alu_B = MEM_alu_result;
    2'b01: alu_B = WB_Result;
    default: alu_B = EX_RD2;
endcase

end

alu alu_inst (
    .Control_Line(EX_alu_control),
    .SrcA(alu_A),
    .SrcB(EX_alu_src ? EX_imm_ext : alu_B),
    .zero(zero),
    .ALU_result(EX_alu_result)
);

load_stall stall_inst (
    .ID_rs1(rs1),
    .ID_rs2(rs2),
    .EX_rd(EX_rd),
    .EX_result_src(EX_result_src),
    .stall(IF_ID_stall),
    .flush()
);

assign ID_EX_flush = (EX_branch && zero) || IF_ID_stall;

EX_MEM ex_em (
    .clk(clk),
    .reset(reset),
    .EX_alu_result(EX_alu_result),
    .EX_write_data(EX_write_data),
    .EX_rd(EX_rd),
    .EX_mem_write(EX_mem_write),
    .EX_reg_write(EX_reg_write),
    .EX_result_src(EX_result_src),
    .MEM_alu_result(MEM_alu_result),
    .MEM_write_data(MEM_write_data),
    .MEM_rd(MEM_rd),
    .MEM_mem_write(MEM_mem_write),
    .MEM_reg_write(MEM_reg_write),
    .MEM_result_src(MEM_result_src)
);
assign EX_write_data = alu_B;

data_mem data_mem_inst (
    .clk(clk),
    .reset(reset),
    .mem_write(MEM_mem_write),
    .A(MEM_alu_result[6:2]),
    .WD(MEM_write_data),
    .RD(Read_Data)
);


MEM_WB mem_wb (
    .clk(clk),
    .reset(reset),
    .MEM_alu_result(MEM_alu_result),
    .MEM_read_data(Read_Data),
    .MEM_rd(MEM_rd),
    .MEM_reg_write(MEM_reg_write),
    .MEM_result_src(MEM_result_src),
    .WB_alu_result(WB_alu_result),
    .WB_read_data(WB_read_data),
    .WB_rd(WB_rd),
    .WB_reg_write(WB_reg_write),
    .WB_result_src(WB_result_src)
);

always @(*) begin
    case (WB_result_src)
        1'b0: WB_Result = WB_alu_result;
        1'b1: WB_Result = WB_read_data; 
        default: WB_Result = WB_read_data;
    endcase
end

endmodule