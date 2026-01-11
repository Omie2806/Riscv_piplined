`timescale 1ns/1ps

module tb_cpu;

    logic clk;
    logic reset;

    cpu_top cpu_inst (
        .clk(clk),
        .reset(reset)
    );

    // Clock: 10ns period
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        // ---------------------------------------
        // RESET
        // ---------------------------------------
        #20;
        reset = 0;

        // ---------------------------------------
        // LOAD INSTRUCTIONS
        // ---------------------------------------
        // x1 = 7
        cpu_inst.instr_mem.INSTR_MEM[0]  = 32'h00700093; // addi x1,x0,7
        // x2 = 8
        cpu_inst.instr_mem.INSTR_MEM[1]  = 32'h00800113; // addi x2,x0,8

        // R-type tests
        cpu_inst.instr_mem.INSTR_MEM[2]  = 32'h002081b3; // add x3,x1,x2  -> 15
        cpu_inst.instr_mem.INSTR_MEM[3]  = 32'h40110233; // sub x4,x2,x1  -> 1

        // Immediate ALU tests
        cpu_inst.instr_mem.INSTR_MEM[4]  = 32'h0030f293; // andi x5,x1,3  -> 7 & 3 = 3
        cpu_inst.instr_mem.INSTR_MEM[5]  = 32'h0040e313; // ori  x6,x1,4  -> 7 | 4 = 7
        cpu_inst.instr_mem.INSTR_MEM[6]  = 32'h0020c393; // xori x7,x1,2  -> 7 ^ 2 = 5
        cpu_inst.instr_mem.INSTR_MEM[7]  = 32'h0080a413; // slti x8,x1,8  -> 1

        // Memory tests
        cpu_inst.instr_mem.INSTR_MEM[8]  = 32'h00302023; // sw x3,0(x0)
        cpu_inst.instr_mem.INSTR_MEM[9]  = 32'h00002483; // lw x9,0(x0)

        // Branch test
        cpu_inst.instr_mem.INSTR_MEM[10] = 32'h00918463; // beq x3,x9,+8
        cpu_inst.instr_mem.INSTR_MEM[11] = 32'h00000013; // nop (skipped)
        cpu_inst.instr_mem.INSTR_MEM[12] = 32'h00000013; // nop

        // ---------------------------------------
        // RUN SIMULATION
        // ---------------------------------------
        repeat (25) begin
            @(posedge clk);
            $display(
                "PC=%0d Instr=%h | x1=%0d x2=%0d x3=%0d x4=%0d x5=%0d x6=%0d x7=%0d x8=%0d x9=%0d | MEM[0]=%0d",
                cpu_inst.pc,
                cpu_inst.instr,
                cpu_inst.regfile_inst.REGISTER_FILE[1],
                cpu_inst.regfile_inst.REGISTER_FILE[2],
                cpu_inst.regfile_inst.REGISTER_FILE[3],
                cpu_inst.regfile_inst.REGISTER_FILE[4],
                cpu_inst.regfile_inst.REGISTER_FILE[5],
                cpu_inst.regfile_inst.REGISTER_FILE[6],
                cpu_inst.regfile_inst.REGISTER_FILE[7],
                cpu_inst.regfile_inst.REGISTER_FILE[8],
                cpu_inst.regfile_inst.REGISTER_FILE[9],
                cpu_inst.data_mem_inst.DATA_MEMORY[0]
            );
        end

        $display("==== CPU IMMEDIATE + MEMORY + BRANCH TEST COMPLETE ====");
        $finish;
    end

endmodule
