`timescale 1ns/1ps

module tb_pipelined_top;

    logic clk;
    logic reset;

    // Probe signals
    logic [31:0] pc;
    logic [31:0] IF_ID_instr;
    logic        stall;

    // WB
    logic        WB_WE;
    logic [4:0]  WB_RD;
    logic [31:0] WB_DATA;

    // Registers
    logic [31:0] x1, x2, x3;

    pipelined_top uut (
        .clk(clk),
        .reset(reset)
    );

    // Probes
    assign pc          = uut.pc;
    assign IF_ID_instr = uut.IF_ID_instr;
    assign stall       = uut.IF_ID_stall;

    assign WB_WE   = uut.WB_reg_write;
    assign WB_RD   = uut.WB_rd;
    assign WB_DATA = uut.WB_result_src ? uut.WB_read_data
                                       : uut.WB_alu_result;

    // Register file probing
    assign x1 = uut.regfile_inst.REGISTER_FILE[1];
    assign x2 = uut.regfile_inst.REGISTER_FILE[2];
    assign x3 = uut.regfile_inst.REGISTER_FILE[3];
    assign x4 = uut.regfile_inst.REGISTER_FILE[4];
    assign x5 = uut.regfile_inst.REGISTER_FILE[5];

    // Clock
    initial clk = 0;
    always #5 clk = ~clk;

    // Reset
    initial begin
        reset = 1;
        #20 reset = 0;
    end

    // Dump
    initial begin
        $dumpfile("pipelined_cpu.vcd");
        $dumpvars(0, tb_pipelined_top);
    end

    // Header
    initial begin
        $display("Time | PC  | IF/ID Instr | Stall | WB");
        $display("------------------------------------------");
    end

    // Cycle-by-cycle monitor
    always @(posedge clk) begin
        if (!reset) begin
            $display("%0t | %h | %h |  %b   | x%0d=%h",
                     $time, pc, IF_ID_instr, stall,
                     WB_RD, WB_DATA);
        end
    end

    // Finish
    initial begin
        #300;
        $display("\n=== FINAL REGISTER STATE ===");
        $display("x1 = %0d", x1);
        $display("x2 = %0d", x2);
        $display("x3 = %0d", x3);
        $display("x4 = %0d", x4);
        $display("x5 = %0d", x5);
        $finish;
    end

endmodule
