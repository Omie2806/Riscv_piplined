module forward (
    //DATAPATH
    input wire [4:0] EX_rs1,
    input wire [4:0] EX_rs2,
    input wire [4:0] MEM_rd,
    input wire [4:0] WB_rd,

    //CONTROL
    input wire MEM_reg_write,
    input wire WB_reg_write,

    output reg [1:0] Forward_ScrA,
    output reg [1:0] Forward_ScrB
);

always @(*) begin
    Forward_ScrA = 2'b0;
    Forward_ScrB = 2'b0;

    //scrA
    if ((EX_rs1 == MEM_rd) && MEM_reg_write && (EX_rs1 != 0)) begin
        Forward_ScrA = 2'b10; //From MEM Stage
    end
    else if ((EX_rs1 == WB_rd) && WB_reg_write && (EX_rs1 != 0)) begin
        Forward_ScrA = 2'b01; // from WB stage
    end
    else begin
        Forward_ScrA = 2'b00; // no forwarding
    end

    //ScrB
    if ((EX_rs2 == MEM_rd) && MEM_reg_write && (EX_rs2 != 0)) begin
        Forward_ScrB = 2'b10; //From MEM Stage
    end
    else if ((EX_rs2 == WB_rd) && WB_reg_write && (EX_rs2 != 0)) begin
        Forward_ScrB = 2'b01; // from WB stage
    end
    else begin
        Forward_ScrB = 2'b00; // no forwarding
    end
end
endmodule