module instruction_mem (
    input logic  [31:0] A_instr,
    output logic [31:0] instr
);
    reg [31:0] IMEM [0 : 31];

    initial begin
        $readmemh("program.hex", IMEM);
    end

  always @(*) begin
    if (A_instr[6:2] < 32)
        instr = IMEM[A_instr[6:2]];
    else
        instr = 32'h00000013; // NOP instruction for RISC-V
end

endmodule
