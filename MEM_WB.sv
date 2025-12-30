module MEM_WB (
    input logic clk,
    input logic reset,

    // DATAPATH
    input  wire [31:0] MEM_alu_result,
    input  wire [31:0] MEM_read_data,
    input  wire [4:0]  MEM_rd,

    // CONTROL
    input  wire MEM_reg_write,
    input  wire MEM_result_src,

    // OUTPUT DATAPATH
    output reg  [31:0] WB_alu_result,
    output reg  [31:0] WB_read_data,
    output reg  [4:0]  WB_rd,

    // OUTPUT CONTROL
    output reg  WB_reg_write,
    output reg  WB_result_src
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        WB_alu_result <= 32'b0;
        WB_read_data  <= 32'b0;
        WB_rd         <= 5'b0;

        WB_reg_write  <= 1'b0;
        WB_result_src <= 1'b0;
    end
    else begin
        WB_alu_result <= MEM_alu_result;
        WB_read_data  <= MEM_read_data;
        WB_rd         <= MEM_rd;

        WB_reg_write  <= MEM_reg_write;
        WB_result_src <= MEM_result_src;
    end
end

endmodule
