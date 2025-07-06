# UART-Controlled ALU in Verilog

##  Description
A UART-controlled Arithmetic Logic Unit (ALU) implemented in synthesizable Verilog. Designed for FPGA and RTL-based verification interviews. This project accepts ALU instructions over UART (via a PC) and returns the computed result via UART TX.

##  Features
- 8-bit ALU: ADD, SUB, AND, OR, XOR, NOT, INC, DEC
- UART RX/TX @ 9600 baud
- Finite State Machine (FSM) to receive 3 bytes: OP, A, B
- Returns result via UART TX
- Fully synthesizable and modular

## Files
- `src/`: Contains ALU, UART modules, FSM controller, top module
- `tb/`: Testbench simulates UART input and observes output

## Tools
- Vivado (RTL design + simulation)
- Verilog
- Baud rate: 9600 (for UART)

## Usage
Simulate `top_uart_alu_tb.v` in Vivado and observe UART behavior. Modify inputs to test different operations.

<img width="735" alt="{747036D2-2680-434C-B000-2311AB47CC08}" src="https://github.com/user-attachments/assets/588316b1-46d9-4c6b-9600-854257fb61c6" />

