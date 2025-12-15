`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/10 16:05:37
// Design Name: 
// Module Name: top_test
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


module top_test(
    input logic clk,
    input logic rst,
    input logic en,
    input logic wr_en_A, wr_en_B,
    input logic [9:0] wr_add_A, wr_add_B,
    input logic [15:0] wr_data_A, wr_data_B,
    output logic [15:0] out00, out01, out02, out10, out11, out12, out20, out21, out22
);  
    //==logic==
    logic [9:0] rd_add_A_0, rd_add_B_0;
    logic [9:0] rd_add_A_1, rd_add_B_1;
    logic [9:0] rd_add_A_2, rd_add_B_2;
    logic [15:0] rd_data_A_0, rd_data_B_0;
    logic [15:0] rd_data_A_1, rd_data_B_1;
    logic [15:0] rd_data_A_2, rd_data_B_2;
    logic next_agu;
    logic [4:0] next;
    logic [2:0] en_row, en_col;
    //==always==
    // 比agu提供的next信号晚一拍
    always_ff @( posedge clk or posedge rst ) begin 
        if(rst == 1) begin
            next <= 5'b00000;
        end
        else begin
            next[0] <= next_agu;
            next[1] <= next[0];
            next[2] <= next[1];
            next[3] <= next[2];
            next[4] <= next[3];
        end
    end
    //==instance==
    Memory u_memory_A(
        .clk(clk),
        .rst(rst),
        .rd_en0(en),
        .rd_en1(en),
        .rd_en2(en),
        .rd_add0(rd_add_A_0),
        .rd_add1(rd_add_A_1),
        .rd_add2(rd_add_A_2),
        .rd_data0(rd_data_A_0),
        .rd_data1(rd_data_A_1),
        .rd_data2(rd_data_A_2),
        .wr_en(wr_en_A),
        .wr_add(wr_add_A),
        .wr_data(wr_data_A)
    );
    Memory u_memory_B(
        .clk(clk),
        .rst(rst),
        .rd_en0(en),
        .rd_en1(en),
        .rd_en2(en),
        .rd_add0(rd_add_B_0),
        .rd_add1(rd_add_B_1),
        .rd_add2(rd_add_B_2),
        .rd_data0(rd_data_B_0),
        .rd_data1(rd_data_B_1),
        .rd_data2(rd_data_B_2),
        .wr_en(wr_en_B),
        .wr_add(wr_add_B),
        .wr_data(wr_data_B)
    );
    PE_Array u_pe_array(
        .clk(clk),
        .rst(rst),
        .en(en),
        .en_col(en_col),
        .en_row(en_row),
        .i_A_0(rd_data_A_0),
        .i_A_1(rd_data_A_1),
        .i_A_2(rd_data_A_2),
        .i_B_0(rd_data_B_0),
        .i_B_1(rd_data_B_1),
        .i_B_2(rd_data_B_2),
        .out00(out00),
        .out01(out01),
        .out02(out02),
        .out10(out10),
        .out11(out11),
        .out12(out12),
        .out20(out20),
        .out21(out21),
        .out22(out22),
        .next(next)
    );
    Matrix_Multiplication_AGU u_matrix_multiplication_agu(
        .clk(clk),
        .rst(rst),
        .en(en),
        .en_col(en_col),
        .en_row(en_row),
        .rd_basic_add_A(10'b0),
        .rd_basic_add_B(10'b0),
        .rd_add_A_0(rd_add_A_0),
        .rd_add_A_1(rd_add_A_1),
        .rd_add_A_2(rd_add_A_2),
        .rd_add_B_0(rd_add_B_0),
        .rd_add_B_1(rd_add_B_1),
        .rd_add_B_2(rd_add_B_2),
        .next(next_agu)
    );
endmodule
