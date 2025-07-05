`timescale 1ns / 1ps

module top_uart_alu (
    input clk,
    input rst,
    input rx,
    output tx
);

    // Wires to connect internal modules
    wire [7:0] rx_data;
    wire rx_valid;

    wire [7:0] alu_result;
    wire [7:0] tx_data;
    wire tx_start;
    wire tx_busy;

    wire [7:0] alu_A, alu_B;
    wire [2:0] alu_op;

    // UART Receiver
    uart_rx #(
        .CLK_FREQ(50000000),
        .BAUD_RATE(9600)
    ) uart_rx_inst (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .data_out(rx_data),
        .data_valid(rx_valid)
    );

    // ALU Control FSM
    alu_uart_ctrl ctrl_inst (
        .clk(clk),
        .rst(rst),
        .rx_data(rx_data),
        .rx_valid(rx_valid),
        .tx_busy(tx_busy),
        .alu_result(alu_result),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .alu_A(alu_A),
        .alu_B(alu_B),
        .alu_op(alu_op)
    );

    // ALU
    alu alu_inst (
        .A(alu_A),
        .B(alu_B),
        .ALU_SEL(alu_op),
        .RESULT(alu_result),
        .ZERO() // Unused for now
    );

    // UART Transmitter
    uart_tx #(
        .CLK_FREQ(50000000),
        .BAUD_RATE(9600)
    ) uart_tx_inst (
        .clk(clk),
        .rst(rst),
        .data_in(tx_data),
        .tx_start(tx_start),
        .tx(tx),
        .tx_busy(tx_busy)
    );

endmodule
