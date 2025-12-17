`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/09 14:15:11
// Design Name: 
// Module Name: r_memory
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


module Memory(
    input logic clk,
    input logic rst,
    input logic rd_en0, rd_en1, rd_en2,
    input logic [9:0] rd_add0, rd_add1, rd_add2,
    input logic wr_en,
    input logic [9:0] wr_add,
    input logic [15:0] wr_data,
    output logic [15:0] rd_data0, rd_data1, rd_data2
    );

    /*
    读写时地址均以上升沿后的地址为准, 使能信号看上升沿时是否有使能信号"""
    */
    //==r_memory==
    // 32*32 16bits
    reg [15:0] r_memory [1023:0];
    //==assign==
    //==always==
    //--rd_data--
    always_ff @(posedge clk or posedge rst) begin
        if(rst == 1) begin
            rd_data0 <= 0;
            rd_data1 <= 0;
            rd_data2 <= 0;
        end
        else begin
            if (rd_en0 == 1) begin
                rd_data0 <= r_memory[rd_add0];
            end
            else begin
                rd_data0 <= 0;
            end

            if(rd_en1 == 1) begin
                rd_data1 <= r_memory[rd_add1];
            end
            else begin
                rd_data1 <= 0;
            end

            if(rd_en2 == 1) begin
                rd_data2 <= r_memory[rd_add2];
            end
            else begin
                rd_data2 <= 0;
            end
            
        end
    end

    //--wr_data--
    always_ff @( posedge clk or posedge rst ) begin
        if(rst == 1) begin
            foreach(r_memory[i,j]) begin
                r_memory[i][j] <= 0;
            end
        end
        else begin
            if(wr_en == 1) begin
                r_memory[wr_add] <= wr_data;
            end
            else begin
                r_memory[wr_add] <= r_memory[wr_add];
            end
        end
    end
endmodule
