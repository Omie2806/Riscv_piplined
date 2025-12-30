`timescale 1ns/1ps

module alu_tb;

    // DUT signals
    logic [2:0]  Control_Line;
    logic [31:0] SrcA;
    logic [31:0] SrcB;
    logic        zero;
    logic [31:0] ALU_result;

    // Instantiate DUT
    alu dut (
        .Control_Line(Control_Line),
        .SrcA(SrcA),
        .SrcB(SrcB),
        .zero(zero),
        .ALU_result(ALU_result)
    );

    // Task to apply stimulus
    task apply_test(
        input [2:0]  ctrl,
        input [31:0] a,
        input [31:0] b,
        input [31:0] expected
    );
    begin
        Control_Line = ctrl;
        SrcA = a;
        SrcB = b;
        #1; // allow combinational settle

        if (ALU_result !== expected) begin
            $display("❌ FAIL: ctrl=%b A=%0d B=%0d | got=%0d exp=%0d",
                     ctrl, a, b, ALU_result, expected);
        end else begin
            $display("✅ PASS: ctrl=%b A=%0d B=%0d | result=%0d",
                     ctrl, a, b, ALU_result);
        end
    end
    endtask

    initial begin
        $display("==== ALU TEST START ====");

        // ADD
        apply_test(3'b000, 10, 5, 15);

        // SUB
        apply_test(3'b001, 10, 5, 5);

        // AND
        apply_test(3'b010, 32'hF0F0, 32'h0FF0, 32'h00F0);

        // OR
        apply_test(3'b011, 32'hF0F0, 32'h0FF0, 32'hFFF0);

        // SLT (true)
        apply_test(3'b100, -5, 10, 1);

        // SLT (false)
        apply_test(3'b100, 10, -5, 0);

        // XOR
        apply_test(3'b101, 32'hAA55, 32'hFF00, 32'h5555);

        // ZERO flag check
        apply_test(3'b001, 5, 5, 0);
        if (zero !== 1'b1)
            $display("❌ ZERO FLAG FAIL");
        else
            $display("✅ ZERO FLAG PASS");

        $display("==== ALU TEST END ====");
        $finish;
    end

endmodule
