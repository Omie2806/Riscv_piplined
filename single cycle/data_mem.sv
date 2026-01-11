module data_mem (
    input logic clk,
    input logic reset,
    input logic mem_write,
    input logic [4:0] A,
    input logic [31:0] WD,
    output logic [31:0] RD
);
    reg [31:0] DATA_MEMORY[0:31];
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            for(integer i = 5; i < 32; i++) begin
                DATA_MEMORY[i] <= 32'b0;
            end
        end else if(mem_write) begin
            DATA_MEMORY[A] <= WD;
        end
    end

    always @(*) begin
            RD = DATA_MEMORY[A];
    end

initial begin
    DATA_MEMORY[0] = 32'd10;
    DATA_MEMORY[1] = 32'd20;
    DATA_MEMORY[2] = 32'd30;
    DATA_MEMORY[3] = 32'd40;
end


endmodule