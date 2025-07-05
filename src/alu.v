`timescale 1ns / 1ps

module alu (
    input  [15:0] A,
    input  [15:0] B,
    input  [2:0]  ALU_SEL,
    output reg [15:0] RESULT,
    output ZERO
);

    always @(*) begin
        case (ALU_SEL)
            3'b000: RESULT = A + B;
            3'b001: RESULT = A - B;
            3'b010: RESULT = A & B;
            3'b011: RESULT = A | B;
            3'b100: RESULT = A ^ B;
            3'b101: RESULT = A;
            3'b110: RESULT = A + 1;
            3'b111: RESULT = A - 1;
            default: RESULT = 16'b0;
        endcase
    end

    assign ZERO = (RESULT == 16'b0);

endmodule

