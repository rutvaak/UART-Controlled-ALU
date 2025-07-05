`timescale 1ns / 1ps

module top_uart_alu_tb;

    reg clk;
    reg rst;
    reg rx;
    wire tx;

    top_uart_alu uut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .tx(tx)
    );

    // Clock: 20ns period = 50MHz
    always #10 clk = ~clk;

    // UART send task (8N1 frame)
    task uart_send_byte;
        input [7:0] data;
        integer i;
        begin
            rx = 0; // Start bit
            #(104160); // 1 baud delay (9600bps ~ 104.16us)

            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #(104160); // Data bits
            end

            rx = 1; // Stop bit
            #(104160);
        end
    endtask

    initial begin
        clk = 0;
        rx = 1; // idle
        rst = 1;
        #50;
        rst = 0;

        // Send: Opcode (000 = ADD), A = 15, B = 10
        #1000;
        uart_send_byte(8'b000_00000); // opcode
        uart_send_byte(8'd15);        // A
        uart_send_byte(8'd10);        // B

        // Wait for result
        #2000000;  // wait enough for TX

        $finish;
    end

endmodule
