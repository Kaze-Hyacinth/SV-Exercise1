`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/08 18:34:28
// Design Name: 
// Module Name: PE
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


module PE(
    input logic [15:0] i_A,
    input logic [15:0] i_B,
    input logic clk,
    input logic rst,
    input logic en,
    input logic next,
    output logic [15:0] o_sum,
    output logic [15:0] right,
    output logic [15:0] down
    );
    //==logic==
    logic [15:0] w_c;
    logic [15:0] d_part_sum;
    logic [15:0] r_part_sum = 8'b0000_0000;
    logic [15:0] r_right = 8'b0, r_down = 8'b0;
    //==assign==
    assign o_sum = r_part_sum;
    assign right = r_right;
    assign down = r_down;
    //==always==
    //--part_sum--
    always_ff @( posedge clk or posedge rst ) begin
        if (rst == 1) begin
            r_part_sum <= 8'b0000_0000;
        end
        else begin
            if (next == 1) begin
                // 得出计算结果和数据流入之间有一个clk间隔
                r_part_sum <= w_c;
            end
            else begin
                if (en == 1) begin
                    r_part_sum <= d_part_sum;
                end
                else begin
                    r_part_sum <= r_part_sum;
                end
            end
        end
    end
    //--passdown the data--
    always_ff @(posedge clk or posedge rst) begin
        if (rst == 1) begin
            r_right <= 15'b0000_0000;
            r_down <= 15'b0000_0000;
        end
        else begin
            if (en == 1) begin
            r_right <= i_A;
            r_down <= i_B;
        end
        else begin
            r_right <= r_right;
            r_down <= r_down;
        end
        end
    end
    //==instance==
    Adder u_adder(
        .i_A(w_c),
        .i_B(r_part_sum),
        .o_C(d_part_sum)
    );
    Multiplier u_multiplier(
        .i_A(i_A),
        .i_B(i_B),
        .o_C(w_c)
    );
endmodule

module Adder(
    input logic [15:0] i_A,
    input logic [15:0] i_B,
    output logic [15:0] o_C
);
    assign o_C = i_A + i_B;
endmodule

module Multiplier (
    input logic [15:0] i_A,
    input logic [15:0] i_B,
    output logic [15:0] o_C
);
    logic [31:0] C;
    assign C = (i_A * i_B);
    assign o_C = C[15:0];
endmodule
