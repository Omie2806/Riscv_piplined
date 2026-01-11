module imm_gen (
    input logic [31:0] instr,
    output logic [31:0] imm_ext
);

    always @(*) begin
        case (instr[6:0]) //opcode
            7'b000_0011, 7'b0010011: imm_ext = {{20{instr[31]}}, instr[31:20]};//i type
            7'b010_0011: imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]};// s type
            7'b110_0011: imm_ext = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // B-type
            default: imm_ext     = 32'b0;
        endcase
    end
endmodule