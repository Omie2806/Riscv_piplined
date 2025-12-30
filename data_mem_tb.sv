`timescale 1ns/1ps

module data_mem_tb;

    // DUT signals
    logic        clk;
    logic        reset;
    logic        mem_write;
    logic [4:0]  A;
    logic [31:0] WD;
    logic [31:0] RD;

    // Instantiate the data memory
    data_mem dut (
        .clk(clk),
        .reset(reset),
        .mem_write(mem_write),
        .A(A),
        .WD(WD),
        .RD(RD)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 10ns period

    // Task for checking read value
    task check_rd(input [31:0] expected);
        begin
            #1; // wait for combinational read
            if (RD !== expected)
                $display("❌ RD FAIL: Address=%0d, got=%0d expected=%0d", A, RD, expected);
            else
                $display("✅ RD PASS: Address=%0d, value=%0d", A, RD);
        end
    endtask

    // Test sequence
    initial begin
        $display("==== DATA MEMORY TEST START ====");

        // Reset memory
        reset = 1; mem_write = 0; A = 0; WD = 0;
        #10;
        reset = 0;

        // Test 1: Write to address 0
        mem_write = 1; A = 5'd0; WD = 32'd123;
        #10; mem_write = 0;
        check_rd(32'd123);

        // Test 2: Write to address 1
        mem_write = 1; A = 5'd1; WD = 32'd456;
        #10; mem_write = 0;
        A = 5'd1;
        check_rd(32'd456);

        // Test 3: Read from address 0 (check previous write)
        A = 5'd0;
        check_rd(32'd123);

        // Test 4: Write and read at same cycle
        mem_write = 1; A = 5'd2; WD = 32'd789;
        #10; mem_write = 0;
        A = 5'd2;
        check_rd(32'd789);

        // Test 5: Reset memory
        reset = 1; #10; reset = 0;
        A = 5'd0; check_rd(32'd0);
        A = 5'd1; check_rd(32'd0);
        A = 5'd2; check_rd(32'd0);

        $display("==== DATA MEMORY TEST END ====");
        $finish;
    end

endmodule
