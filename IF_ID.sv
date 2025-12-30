module IF_ID (
    input  logic        clk,
    input  logic        reset,
    input  logic        stall,   
    input  logic        flush,   
    input  logic [31:0] instr,
    input  logic [31:0] pc,
    output logic [31:0] IF_ID_instr,
    output logic [31:0] IF_ID_pc
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        IF_ID_instr <= 32'b0;
        IF_ID_pc    <= 32'b0;
    end
    else if (flush) begin
        IF_ID_instr <= 32'b0;
        IF_ID_pc    <= 32'b0;
    end
    else if (!stall) begin
        IF_ID_instr <= instr;
        IF_ID_pc    <= pc;
    end
    else begin
        IF_ID_instr <= IF_ID_instr;
        IF_ID_pc    <= IF_ID_pc;
    end
end
endmodule
