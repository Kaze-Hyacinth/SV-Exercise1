`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/08 20:14:21
// Design Name: 
// Module Name: PE_Array
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

/*
next信号与新的首数据一同到来, pe输出比输入延迟一个时钟
9个pe按对角线分为5组, 其计算完成的时间较前一组延迟一个时钟 -> 对应next被分为5bits信号（可由移位寄存器实现）
*/
module PE_Array(
    input logic [15:0] i_A_0, i_A_1, i_A_2,
    input logic [15:0] i_B_0, i_B_1, i_B_2,
    input logic [2:0] en_rd_row, en_rd_col,
    input logic clk,
    input logic rst,
    input logic [4:0] next,
    input logic en,
    output logic [15:0] out00, out01, out02, out10, out11, out12, out20, out21, out22
    );
    //==logic==
    logic [15:0] w_row_0_01, w_row_0_12;
    logic [15:0] w_row_1_01, w_row_1_12;
    logic [15:0] w_row_2_01, w_row_2_12;
    logic [15:0] w_col_0_01, w_col_0_12;
    logic [15:0] w_col_1_01, w_col_1_12;
    logic [15:0] w_col_2_01, w_col_2_12;
    logic en00, en01, en02, en10, en11 = 0, en12 = 0, en20, en21 = 0, en22 = 0;
    //==assign==
    assign en00 = en & en_rd_row[0] & en_rd_col[0];
    assign en01 = en & en_rd_row[0] & en_rd_col[1];
    assign en02 = en & en_rd_row[0] & en_rd_col[2];
    assign en10 = en & en_rd_row[1] & en_rd_col[0];
    assign en20 = en & en_rd_row[2] & en_rd_col[0];
    //==always==
    always_ff @( posedge clk or posedge rst) begin
        if(rst == 1) begin
            en11 <= 0;
            en12 <= 0;
            en21 <= 0;
            en22 <= 0;
        end
        else begin
            en11 <= en & en10 & en01;
            en12 <= en & en11 & en02;
            en21 <= en & en20 & en11;
            en22 <= en & en21 & en12;
        end
    end
        
    //==instance==
    PE u_pe00(
        .clk(clk),
        .rst(rst),
        .en(en00),
        .next(next[0]),
        .i_A(i_A_0),
        .i_B(i_B_0),
        .o_sum(out00),
        .right(w_row_0_01),
        .down(w_col_0_01)
    );
    PE u_pe01(
        .clk(clk),
        .rst(rst),
        .en(en01),
        .next(next[1]),
        .i_A(w_row_0_01),
        .i_B(i_B_1),
        .o_sum(out01),
        .right(w_row_0_12),
        .down(w_col_1_01)
    );
    PE u_pe02(
        .clk(clk),
        .rst(rst),
        .en(en02),
        .next(next[2]),
        .i_A(w_row_0_12),
        .i_B(i_B_2),
        .o_sum(out02),
        .down(w_col_2_01)
    );
    PE u_pe10(
        .clk(clk),
        .rst(rst),
        .en(en10),
        .next(next[1]),
        .i_A(i_A_1),
        .i_B(w_col_0_01),
        .o_sum(out10),
        .right(w_row_1_01),
        .down(w_col_0_12)
    );
    PE u_pe11(
        .clk(clk),
        .rst(rst),
        .en(en11),
        .next(next[2]),
        .i_A(w_row_1_01),
        .i_B(w_col_1_01),
        .o_sum(out11),
        .right(w_row_1_12),
        .down(w_col_1_12)
    );
    PE u_pe12(
        .clk(clk),
        .rst(rst),
        .en(en12),
        .next(next[3]),
        .i_A(w_row_1_12),
        .i_B(w_col_2_01),
        .o_sum(out12),
        .down(w_col_2_12)
    );
    PE u_pe20(
        .clk(clk),
        .rst(rst),
        .en(en20),
        .next(next[2]),
        .i_A(i_A_2),
        .i_B(w_col_0_12),
        .o_sum(out20),
        .right(w_row_2_01)
    );
    PE u_pe21(
        .clk(clk),
        .rst(rst),
        .en(en21),
        .next(next[3]),
        .i_A(w_row_2_01),
        .i_B(w_col_1_12),
        .o_sum(out21),
        .right(w_row_2_12)
    );
    PE u_pe22(
        .clk(clk),
        .rst(rst),
        .en(en22),
        .next(next[4]),
        .i_A(w_row_2_12),
        .i_B(w_col_2_12),
        .o_sum(out22)
    );
endmodule
