`timescale 1ns/1ps

module regfile_tb;

    // DUT signals
    logic        clk;
    logic        reset;
    logic        write_en;
    logic [4:0]  A1, A2, A3;
    logic [31:0] WD3;
    logic [31:0] RD1, RD2;

    // Instantiate the regfile
    regfile dut (
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD3(WD3),
        .RD1(RD1),
        .RD2(RD2)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 10ns period

    // Task for checking read data
    task check_rd(input [31:0] expected1, input [31:0] expected2);
        begin
            #1; // wait for combinational read
            if (RD1 !== expected1)
                $display("❌ RD1 FAIL: got=%0d expected=%0d", RD1, expected1);
            else
                $display("✅ RD1 PASS: %0d", RD1);

            if (RD2 !== expected2)
                $display("❌ RD2 FAIL: got=%0d expected=%0d", RD2, expected2);
            else
                $display("✅ RD2 PASS: %0d", RD2);
        end
    endtask

    // Test sequence
    initial begin
        $display("==== REGFILE TEST START ====");

        // Reset
        reset = 1;
        write_en = 0;
        A1 = 5'd0; A2 = 5'd0; A3 = 5'd0; WD3 = 32'd0;
        #10;
        reset = 0;

        // Test 1: Write x1 = 42
        write_en = 1; A3 = 5'd1; WD3 = 32'd42;
        #10; // wait one clock
        write_en = 0; A1 = 5'd1; A2 = 5'd0;
        check_rd(32'd42, 32'd0);

        // Test 2: Write x2 = 100, x3 = 200
        write_en = 1; A3 = 5'd2; WD3 = 32'd100; #10;
        write_en = 1; A3 = 5'd3; WD3 = 32'd200; #10;
        write_en = 0; A1 = 5'd2; A2 = 5'd3;
        check_rd(32'd100, 32'd200);

        // Test 3: Try writing x0 = 999 (should stay 0)
        write_en = 1; A3 = 5'd0; WD3 = 32'd999; #10;
        write_en = 0; A1 = 5'd0; A2 = 5'd0;
        check_rd(32'd0, 32'd0);

        // Test 4: Read both ports with valid registers
        A1 = 5'd1; A2 = 5'd2;
        check_rd(32'd42, 32'd100);

        // Test 5: Reset again
        reset = 1; #10; reset = 0;
        A1 = 5'd1; A2 = 5'd2;
        check_rd(32'd0, 32'd0);

        $display("==== REGFILE TEST END ====");
        $finish;
    end

endmodule
