`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/08 18:57:05
// Design Name: 
// Module Name: tb_PE
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


module tb_PE;
    logic clk = 0;
    logic rst = 0;
    reg [15:0] A = 8'b0;
    reg [15:0] B = 8'b0;
    logic [15:0] right;
    logic [15:0] down;
    logic [15:0] out;
    logic en = 1;
    logic next = 0;
    always #5 clk = ~clk;
    initial begin
        en = 1;
        # 5;
        for(int i = 1; i <= 5; i++) begin
            #10;
            A = A + 1;
            B = B + 1;
        end
        #10;
        A = 1;
        B = 2;
        next = 1;
        for(int i = 1; i <= 5; i++) begin
            #10;
            next = 0;
            A = A + 1;
            B = B + 1;
        end
        #10;
        en = 0;
        #10;
        rst = 1;
        #3;
        rst = 0;
    end
    PE u_pe(
        .clk(clk),
        .rst(rst),
        .i_A(A),
        .i_B(B),
        .right(right),
        .down(down),
        .o_sum(out),
        .en(en),
        .next(next)
    );
endmodule
