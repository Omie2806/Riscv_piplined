module pc_tb;

    logic clk, reset;
    logic [31:0] next_pc;
    logic [31:0] pc;

    pc dut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        next_pc = 0;
        #10 reset = 0;

        next_pc = 32'd4;  #10;
        next_pc = 32'd8;  #10;
        next_pc = 32'd12; #10;

        $finish;
    end
endmodule
