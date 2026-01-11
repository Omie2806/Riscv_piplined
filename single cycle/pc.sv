module pc (
    input  logic        clk,
    input  logic        reset,
    input  logic        stall,  
    input  logic [31:0] next_pc,
    output logic [31:0] pc
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'b0;
        else if(stall) 
            pc <= pc;
        else 
            pc <= next_pc;
    end

endmodule
