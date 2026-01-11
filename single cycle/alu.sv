module alu (
    input  logic [2:0]  Control_Line,
    input  logic [31:0] SrcA,
    input  logic [31:0] SrcB,
    output logic        zero,
    output logic [31:0] ALU_result
);

    always_comb begin
        ALU_result = 32'b0;   

        case (Control_Line)
            3'b000: ALU_result = SrcA + SrcB;  // ADD
            3'b001: ALU_result = SrcA - SrcB;  // SUB
            3'b010: ALU_result = SrcA & SrcB;  // AND
            3'b011: ALU_result = SrcA | SrcB;  // OR
            3'b100: ALU_result = ($signed(SrcA) < $signed(SrcB)) ? 32'd1 : 32'd0; // SLT
            3'b101: ALU_result = SrcA ^ SrcB;  // XOR
            default: ALU_result = 32'b0;
        endcase
    end

    assign zero = (ALU_result == 32'b0);

endmodule
