module regfile (
    input logic         clk,reset,
    input logic         write_en,
    input logic [4:0]   A1,
    input logic [4:0]   A2,
    input logic [4:0]   A3,
    input logic [31:0]  WD3,
    output logic [31:0] RD1,
    output logic [31:0] RD2
);
    reg [31:0] REGISTER_FILE[0:31];

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            for(integer i = 0; i < 32; i++) begin
                REGISTER_FILE[i] <= 0;
            end
        end
        else if(write_en == 1 && A3 != 5'b0) begin
            REGISTER_FILE[A3] <= WD3;
        end
    end

    always @(*) begin
        if(A1 != 5'b0) begin
            RD1 = REGISTER_FILE[A1];
        end else if(A1 == 5'b0) begin
            RD1 = 32'b0;
        end
        if(A2 != 5'b0)begin
            RD2 = REGISTER_FILE[A2];
        end else if(A2 == 5'b0) begin
            RD2 = 32'b0;
        end
    end
endmodule