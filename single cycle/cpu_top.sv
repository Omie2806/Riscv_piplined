module cpu_top (
    input logic clk,
    input logic reset
);
// PC
logic [31:0] pc, PC_Next, PC_Target, PC_Plus_4;

//instruction memory
logic [31:0] instr;

//register file
logic [4:0] rs1, rs2, rd;
logic [31:0] rd1, rd2;

//imm_gen
logic [31:0] imm_ext;

//alu
logic [31:0] ALU_result;
logic zero;

//data_mem
logic [31:0] Read_Data;

//decode
logic [6:0] opcode;
logic [2:0] func3;
logic func75;

//control unit
logic pc_src, result_src, alu_src, mem_write, reg_write;
logic [2:0] alu_control;

assign opcode = instr[6:0];
assign rs1    = instr[19:15];
assign rs2    = instr[24:20];
assign rd     = instr[11:7];

//control unit assignment
assign func3  = instr[14:12];
assign func75 = instr[30];

pc pc_inst (
    .clk(clk),
    .reset(reset),
    .next_pc(PC_Next),
    .pc(pc)
);
assign PC_Plus_4 = pc + 32'd4;
assign PC_Target = pc + imm_ext;
assign PC_Next   = (pc_src && zero) ? PC_Target : PC_Plus_4;

instruction_mem instr_mem (
    .A_instr(pc),
    .instr(instr)
);

imm_gen imm_gen_inst (
    .instr   (instr),
    .imm_ext (imm_ext)
);

regfile regfile_inst (
    .clk(clk),
    .reset(reset),
    .write_en(reg_write),
    .A1(rs1),
    .A2(rs2),
    .A3(rd),
    .WD3(result_src ? Read_Data : ALU_result),
    .RD1(rd1),
    .RD2(rd2)
);

alu alu_inst (
    .Control_Line(alu_control),
    .SrcA(rd1),
    .SrcB(alu_src ? imm_ext : rd2),
    .zero(zero),
    .ALU_result(ALU_result)
);

data_mem data_mem_inst (
    .clk(clk),
    .reset(reset),
    .mem_write(mem_write),
    .A(ALU_result[6:2]),
    .WD(rd2),
    .RD(Read_Data)
);

always_comb begin
    // defaults
    reg_write   = 0;
    mem_write   = 0;
    alu_src     = 0;
    pc_src      = 0;
    result_src  = 0;
    alu_control = 3'b000;

    case (opcode)

        7'b0110011: begin // R-type
            reg_write = 1;
            case (func3)
                3'b000: begin
                        if (func75) alu_control = 3'b001; // SUB
                        else alu_control        = 3'b000; // ADD
                        end
                3'b010: alu_control = 3'b101;//slt
                
                3'b110: alu_control = 3'b011;//or

                3'b111: alu_control = 3'b010;//and
            endcase
        end

        7'b0010011: begin //addi
            alu_src     = 1;
            reg_write   = 1;
            case (func3)
                3'b000: alu_control  = 3'b000; // ADDI
                3'b111: alu_control  = 3'b010; // ANDI
                3'b110: alu_control  = 3'b011; // ORI
                3'b100: alu_control  = 3'b101; // XORI
                3'b010: alu_control  = 3'b100; // SLTI
                default: alu_control = 3'b000;
            endcase
        end

        7'b0000011: begin // LW
            alu_src     = 1;
            reg_write   = 1;
            result_src  = 1;
            alu_control = 3'b000;
        end

        7'b0100011: begin // SW
            alu_src      = 1;
            mem_write    = 1;
            alu_control  = 3'b000;
        end

        7'b1100011: begin // BEQ
            pc_src      = 1;
            alu_control = 3'b001; // SUB
        end
    endcase
end
endmodule