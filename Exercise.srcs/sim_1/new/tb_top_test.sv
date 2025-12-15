`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/10 16:06:02
// Design Name: 
// Module Name: tb_top_test
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


module tb_top_test;
    logic clk = 0;
    logic rst = 0;
    logic en = 0;
    logic wr_en_A = 0, wr_en_B = 0;
    logic [9:0] wr_add_A = 0, wr_add_B = 0;
    logic [15:0] wr_data_A = 0 , wr_data_B = 0 ;
    logic [4:0] next;
    logic [15:0] out00, out01, out02, out10, out11, out12, out20, out21, out22;
    logic [15:0] rd_A = 0, rd_B = 0;
    logic [15:0] i_A_0, i_B_0;
    logic [15:0] i_A_1, i_B_1;
    logic [15:0] i_A_2, i_B_2;
    logic [9:0] rd_add_A_0, rd_add_B_0;
    logic [9:0] rd_add_A_1, rd_add_B_1;
    logic [9:0] rd_add_A_2, rd_add_B_2;
    logic [15:0] rd_data_A_0, rd_data_B_0;
    logic [15:0] rd_data_A_1, rd_data_B_1;
    logic [15:0] rd_data_A_2, rd_data_B_2;
    logic en00, en01, en02, en10, en11, en12, en20, en21, en22;
    logic [2:0] en_row, en_col;
    assign next = u_top_test.next;
    assign i_A_0 = u_top_test.u_pe_array.i_A_0;
    assign i_A_1 = u_top_test.u_pe_array.i_A_1;
    assign i_A_2 = u_top_test.u_pe_array.i_A_2;
    assign i_B_0 = u_top_test.u_pe_array.i_B_0;
    assign i_B_1 = u_top_test.u_pe_array.i_B_1;
    assign i_B_2 = u_top_test.u_pe_array.i_B_2;
    assign rd_add_A_0 = u_top_test.rd_add_A_0;
    assign rd_add_A_1 = u_top_test.rd_add_A_1;
    assign rd_add_A_2 = u_top_test.rd_add_A_2;
    assign rd_add_B_0 = u_top_test.rd_add_B_0;
    assign rd_add_B_1 = u_top_test.rd_add_B_1;
    assign rd_add_B_2 = u_top_test.rd_add_B_2;
    assign rd_data_A_0 = u_top_test.rd_data_A_0;
    assign rd_data_A_1 = u_top_test.rd_data_A_1;
    assign rd_data_A_2 = u_top_test.rd_data_A_2;
    assign rd_data_B_0 = u_top_test.rd_data_B_0;
    assign rd_data_B_1 = u_top_test.rd_data_B_1;
    assign rd_data_B_2 = u_top_test.rd_data_B_2;
    assign en00 = u_top_test.u_pe_array.en00;
    assign en01 = u_top_test.u_pe_array.en01;
    assign en02 = u_top_test.u_pe_array.en02;
    assign en10 = u_top_test.u_pe_array.en10;
    assign en11 = u_top_test.u_pe_array.en11;
    assign en12 = u_top_test.u_pe_array.en12;
    assign en20 = u_top_test.u_pe_array.en20;
    assign en21 = u_top_test.u_pe_array.en21;
    assign en22 = u_top_test.u_pe_array.en22;
    assign en_row = u_top_test.u_pe_array.en_row;
    assign en_col = u_top_test.u_pe_array.en_col;
    //==task==
    task automatic wr_matrix_A(
        input int H = 16,
        input int W = 16,
        input int base_add = 0
    );
        int matrix[][];
        matrix = new[H];
        for (int i = 0; i < H; i++) begin
            matrix[i] = new[W];
        end
        $display("Write to matrix A");
        for (int i = 0; i < H; i++) begin
            for (int j = 0; j < W; j++) begin
                @(posedge clk);
                wr_en_A = 1;
                matrix[i][j] = $urandom_range(20, 0);
                wr_add_A = base_add + i * W + j;
                wr_data_A = matrix[i][j];
                $write("%d ",matrix[i][j]);
            end
            $write("\n");
        end
        @(posedge clk);
        wr_en_A = 0;
        wr_add_A = 0;
        wr_data_A = 0;
    endtask

    task automatic wr_matrix_A_1(
        input int H = 16,
        input int W = 16,
        input int base_add = 0
    );
        int matrix[][];
        matrix = new[H];
        for (int i = 0; i < H; i++) begin
            matrix[i] = new[W];
        end
        $display("Write to matrix A");
        for (int i = 0; i < H; i++) begin
            for (int j = 0; j < W; j++) begin
                @(posedge clk);
                wr_en_A = 1;
                matrix[i][j] = 1;
                wr_add_A = base_add + i * W + j;
                wr_data_A = matrix[i][j];
                $write("%d ",matrix[i][j]);
            end
            $write("\n");
        end
        @(posedge clk);
        wr_en_A = 0;
        wr_add_A = 0;
        wr_data_A = 0;
    endtask

    task automatic rd_matrix_A(
        input int H = 16,
        input int W = 16,
        input int base_add = 0
    );
        for (int i = 0; i < H; i++) begin
            for (int j = 0; j < W; j++) begin
                @(posedge clk);
                rd_A = u_top_test.u_memory_A.r_memory[base_add + i * W + j];
            end
        end
        rd_A = 0;
    endtask

    task automatic wr_matrix_B(
        input int H = 16,
        input int W = 16,
        input int base_add = 0
    );
        int matrix[][];
        matrix = new[H];
        for (int i = 0; i < H; i++) begin
            matrix[i] = new[W];
        end
        $display("Write to matrix B");
        for (int i = 0; i < H; i++) begin
            for (int j = 0; j < W; j++) begin
                @(posedge clk);
                wr_en_B = 1;
                matrix[i][j] = $urandom_range(20, 0);
                wr_add_B = base_add + i * W + j;
                wr_data_B = matrix[i][j];
                $write("%d ",matrix[i][j]);
            end
            $write("\n");
        end
        @(posedge clk);
        wr_en_B = 0;
        wr_add_B = 0;
        wr_data_B = 0;
    endtask

    task automatic wr_matrix_B_1(
        input int H = 16,
        input int W = 16,
        input int base_add = 0
    );
        int matrix[][];
        matrix = new[H];
        for (int i = 0; i < H; i++) begin
            matrix[i] = new[W];
        end
        $display("Write to matrix B");
        for (int i = 0; i < H; i++) begin
            for (int j = 0; j < W; j++) begin
                @(posedge clk);
                wr_en_B = 1;
                matrix[i][j] = 1;
                wr_add_B = base_add + i * W + j;
                wr_data_B = matrix[i][j];
                $write("%d ",matrix[i][j]);
            end
            $write("\n");
        end
        @(posedge clk);
        wr_en_B = 0;
        wr_add_B = 0;
        wr_data_B = 0;
    endtask

    task automatic rd_matrix_B(
        input int H = 16,
        input int W = 16,
        input int base_add = 0
    );
        for (int i = 0; i < H; i++) begin
            for (int j = 0; j < W; j++) begin
                @(posedge clk);
                rd_B = u_top_test.u_memory_B.r_memory[base_add + i * W + j];
            end
        end
        rd_B = 0;
    endtask 
    top_test u_top_test(
        .clk(clk),
        .rst(rst),
        .en(en),
        .wr_en_A(wr_en_A),
        .wr_en_B(wr_en_B),
        .wr_add_A(wr_add_A),
        .wr_add_B(wr_add_B),
        .wr_data_A(wr_data_A),
        .wr_data_B(wr_data_B),
        .out00(out00),
        .out01(out01),
        .out02(out02),
        .out10(out10),
        .out11(out11),
        .out12(out12),
        .out20(out20),
        .out21(out21),
        .out22(out22)
    );
    logic [7:0] l;
    assign l = u_top_test.u_matrix_multiplication_agu.l0_cnt;
    assign next_agu = u_top_test.next_agu;
    always # 5 clk = ~clk;
    initial begin
        @(posedge clk);
        rst = 1;
        @(posedge clk);
        rst = 0;
        wr_matrix_A(14,16,0);
        wr_matrix_B(16,19,0);
        rd_matrix_A(14,16);
        rd_matrix_B(16,19);
        @(posedge clk);
        en <= 1;
    end
endmodule
