`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/09 17:17:04
// Design Name: 
// Module Name: tb_Matrix_Multiplication_AGU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_Matrix_Multiplication_AGU;
    logic clk = 0;
    logic rst = 0;
    logic en = 0;
    logic [9:0] rd_basic_add_A = 10'b0001001101;
    logic [9:0] rd_basic_add_B = 0;
    logic [9:0] wr_basic_add = 0;
    logic [9:0] rd_add_A_0;
    logic [9:0] rd_add_A_1;
    logic [9:0] rd_add_A_2;
    logic [9:0] rd_add_B_0;
    logic [9:0] rd_add_B_1;
    logic [9:0] rd_add_B_2;
    logic [9:0] wr_add;
    logic next;
    logic [2:0] en_row;
    logic [2:0] en_col;
    logic [7:0] l0,l1,l2;
    logic [10:0] l;
    always_comb begin
        l0 = matrix_multiplication_agu_dut.l0_cnt;
        l1 = matrix_multiplication_agu_dut.l1_cnt;
        l2 = matrix_multiplication_agu_dut.l2_cnt;
        l = matrix_multiplication_agu_dut.l_cnt;
    end
    Matrix_Multiplication_AGU matrix_multiplication_agu_dut(
        .clk(clk),
        .rst(rst),
        .en(en),
        .rd_basic_add_A(rd_basic_add_A),
        .rd_basic_add_B(rd_basic_add_B),
        .wr_basic_add(wr_basic_add),
        .rd_add_A_0(rd_add_A_0),
        .rd_add_A_1(rd_add_A_1),
        .rd_add_A_2(rd_add_A_2),
        .rd_add_B_0(rd_add_B_0),
        .rd_add_B_1(rd_add_B_1),
        .rd_add_B_2(rd_add_B_2),
        .en_row(en_row),
        .en_col(en_col),
        .next(next)
    );
    always #5 clk = ~clk;
    initial begin
        # 30;
        @(posedge clk)
        en <= 1;
        # 10000;
        $stop;
    end
endmodule
