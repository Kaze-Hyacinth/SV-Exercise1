`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/08 21:42:45
// Design Name: 
// Module Name: tb_PE_Array
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


module tb_PE_Array;
    logic clk = 0;
    logic en = 1;
    logic rst = 0;
    logic [15:0] out00, out01, out02, out10, out11, out12, out20, out21, out22;
    logic [15:0] i_A_0 = 0, i_A_1 = 0, i_A_2 = 0;
    logic [15:0] i_B_0 = 0, i_B_1 = 0, i_B_2 = 0;
    logic [15:0] i_A;
    logic [4:0] next = 5'b0_0000;
    logic en00, en01, en02;
    logic en10, en11, en12;
    logic en20, en21, en22;
    always_comb begin
        en00 = u_pe_array.en00;
        en01 = u_pe_array.en01;
        en02 = u_pe_array.en02;
        en10 = u_pe_array.en10;
        en11 = u_pe_array.en11;
        en12 = u_pe_array.en12;
        en20 = u_pe_array.en20;
        en21 = u_pe_array.en21;
        en22 = u_pe_array.en22;
    end
    always #5 clk = ~clk;
    initial begin
        @(posedge clk);
        i_A_0 <= 1;
        i_A_1 <= 0;
        i_A_2 <= 0;

        i_B_0 <= 1;
        i_B_1 <= 0;
        i_B_2 <= 0;
        @(posedge clk);;

        i_A_0 <= 3;
        i_A_1 <= 4;
        i_A_2 <= 0;

        i_B_0 <= 4;
        i_B_1 <= 2;
        i_B_2 <= 0;
        @(posedge clk);;

        i_A_0 <= 2;
        i_A_1 <= 8;
        i_A_2 <= 9;

        i_B_0 <= 3;
        i_B_1 <= 7;
        i_B_2 <= 6;
        @(posedge clk);;

        i_A_0 <= 0;
        i_A_1 <= 6;
        i_A_2 <= 7;

        i_B_0 <= 0;
        i_B_1 <= 9;
        i_B_2 <= 5;
        next[0] = 1;
        @(posedge clk);;
        

        i_A_0 <= 0;
        i_A_1 <= 0;
        i_A_2 <= 5;

        i_B_0 <= 0;
        i_B_1 <= 0;
        i_B_2 <= 8;
        next[0] = 0;
        next[1] = 1;
        @(posedge clk);;
        

        i_A_0 <= 0;
        i_A_1 <= 0;
        i_A_2 <= 0;

        i_B_0 <= 0;
        i_B_1 <= 0;
        i_B_2 <= 0;
        next[1] = 0;
        next[2] = 1;
        @(posedge clk);;

        next[2] = 0;
        next[3] = 1;
        @(posedge clk);

        next[3] = 0;
        next[4] = 1;
        @(posedge clk);
        next[4] = 0;
        en = 0;
        # 100;
        $stop;
    end
    //==instance==
    PE_Array u_pe_array(
        .i_A_0(i_A_0),
        .i_A_1(i_A_1),
        .i_A_2(i_A_2),
        .i_B_0(i_B_0),
        .i_B_1(i_B_1),
        .i_B_2(i_B_2),
        .clk(clk),
        .en(en),
        .rst(rst),
        .next(next),
        .en_row(3'b111),
        .en_col(3'b111),
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
    assign i_A = u_pe_array.i_A_0;
    assign next_ = u_pe_array.u_pe00.r_next;
endmodule
