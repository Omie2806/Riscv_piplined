`timescale 1ns/1ps

module instruction_mem_tb;

    logic [31:0] A_instr;
    logic [31:0] instr;

    // Instantiate DUT
    instruction_mem dut (
        .A_instr(A_instr),
        .instr(instr)
    );

    // Preload instructions
    initial begin
        // Manually load instructions for testing
        dut.INSTR_MEM[0] = 32'h00000013; // nop (addi x0,x0,0)
        dut.INSTR_MEM[1] = 32'h00100093; // addi x1,x0,1
        dut.INSTR_MEM[2] = 32'h00200113; // addi x2,x0,2
        dut.INSTR_MEM[3] = 32'h00308193; // addi x3,x1,3
    end

    initial begin
        $display("==== INSTRUCTION MEMORY TEST START ====");

        // PC = 0
        A_instr = 32'd0;
        #1;
        $display("PC=%0d Instr=%h", A_instr, instr);

        // PC = 4
        A_instr = 32'd4;
        #1;
        $display("PC=%0d Instr=%h", A_instr, instr);

        // PC = 8
        A_instr = 32'd8;
        #1;
        $display("PC=%0d Instr=%h", A_instr, instr);

        // PC = 12
        A_instr = 32'd12;
        #1;
        $display("PC=%0d Instr=%h", A_instr, instr);

        // Out-of-program fetch (should be X or 0 depending on sim)
        A_instr = 32'd16;
        #1;
        $display("PC=%0d Instr=%h", A_instr, instr);

        $display("==== INSTRUCTION MEMORY TEST END ====");
        $finish;
    end

endmodule
