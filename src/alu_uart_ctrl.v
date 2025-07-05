`timescale 1ns / 1ps

module alu_uart_ctrl (
    input clk,
    input rst,
    input [7:0] rx_data,
    input rx_valid,
    input tx_busy,
    input [7:0] alu_result,

    output reg [7:0] tx_data,
    output reg tx_start,

    output reg [7:0] alu_A,
    output reg [7:0] alu_B,
    output reg [2:0] alu_op
);

    // FSM states
    parameter IDLE = 3'b000,
              GET_OP = 3'b001,
              GET_A  = 3'b010,
              GET_B  = 3'b011,
              EXECUTE = 3'b100,
              SEND_RESULT = 3'b101,
              DONE = 3'b110;

    reg [2:0] state, next_state;

    // State register
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // FSM next state logic
    always @(*) begin
        next_state = state;
        tx_start = 0;

        case (state)
            IDLE:       if (rx_valid) next_state = GET_OP;
            GET_OP:     if (rx_valid) next_state = GET_A;
            GET_A:      if (rx_valid) next_state = GET_B;
            GET_B:      if (rx_valid) next_state = EXECUTE;
            EXECUTE:                  next_state = SEND_RESULT;
            SEND_RESULT: if (!tx_busy) next_state = DONE;
            DONE:       next_state = IDLE;
        endcase
    end

    // Data handling
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            alu_A <= 0;
            alu_B <= 0;
            alu_op <= 0;
            tx_data <= 0;
            tx_start <= 0;
        end else begin
            case (state)
                GET_OP: if (rx_valid) alu_op <= rx_data[2:0];
                GET_A:  if (rx_valid) alu_A  <= rx_data;
                GET_B:  if (rx_valid) alu_B  <= rx_data;
                SEND_RESULT: begin
                    if (!tx_busy) begin
                        tx_data <= alu_result;
                        tx_start <= 1;
                    end
                end
                default: tx_start <= 0;
            endcase
        end
    end

endmodule
