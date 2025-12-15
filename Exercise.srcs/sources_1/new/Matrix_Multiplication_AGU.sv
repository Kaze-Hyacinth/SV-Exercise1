`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/09 16:15:20
// Design Name: 
// Module Name: Matrix_Multiplication_AGU
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


module Matrix_Multiplication_AGU(
    input logic clk,
    input logic rst,
    input logic en,
    // input logic prim, 暂未实现
    input logic [9:0] rd_basic_add_A,
    input logic [9:0] rd_basic_add_B,
    input logic [9:0] wr_basic_add,
    output logic [9:0] rd_add_A_0,
    output logic [9:0] rd_add_A_1,
    output logic [9:0] rd_add_A_2,
    output logic [9:0] rd_add_B_0,
    output logic [9:0] rd_add_B_1,
    output logic [9:0] rd_add_B_2,
    output logic [9:0] wr_add,
    output logic [2:0] en_row,
    output logic [2:0] en_col,
    output logic next = 0
    );

    //==logic==
    //--cnt--
    logic [7:0] l0_cnt = 0;
    logic [3:0] l1_cnt = 0;
    logic [3:0] l2_cnt = 0;
    logic [10:0] l_cnt = 0;     // l2_cnt * (l0_max + 1) * (l1_max + 1) + l1_cnt * (l0_max + 1) + l0_cnt + 1 - 1
    // 需要长两个clk保证数据完整
    logic [3:0] wr_cnt = 0;
    // 分别代表pe对应的元素的地址偏移
    logic [9:0] rd_add_bias_A_0 = 0;
    logic [9:0] rd_add_bias_A_1 = 0;
    logic [9:0] rd_add_bias_A_2 = 0;
    logic [9:0] rd_add_bias_B_0 = 0;
    logic [9:0] rd_add_bias_B_1 = 0;
    logic [9:0] rd_add_bias_B_2 = 0;
    logic [9:0] wr_add_bias_part1 = 0, wr_add_bias_part2 = 0;
    
    //--exe_para--
    //后续可以从原语中进行读取，目前先以固定的 14x16 * 16x19 矩阵测试
    logic [7:0] l0_max = 15;
    logic [3:0] l1_max = 6; // 输出矩阵W方向
    logic [3:0] l2_max = 4; // 输出矩阵H方向
    logic [10:0] l_max = 561; // (l2_max + 1) * (l0_max + 1) * (l1_max + 1) - 1 + 2
    logic [1:0] W_res = 1;
    logic [1:0] H_res = 2;
    

    // 由寻址逻辑其不需要A0_add和B2_add
    logic [9:0] A1_add = -15;   // -l0_max
    logic [9:0] A2_add = 33;    // -l0_max + H_PE*(l0_max + 1)
    logic [9:0] B0_add = 19;    // o_W + 1
    logic [9:0] B1_add = -282;  // -l0_max * (o_W + 1) + W_PE
    logic [9:0] r_add = 16; // l0_max + 1
    logic [9:0] wr_bias_part1_add = 39; // 2 * output_W + W_res
    logic [9:0] wr_bias_part2_add1 = 18; // output_W - 1
    logic [9:0] wr_bias_part2_add2 = -17; // -output_W + 2
    logic [7:0] o_H = 13;
    logic [7:0] o_W = 18;

    //==assign==
    assign rd_add_A_0 = rd_basic_add_A + rd_add_bias_A_0;
    assign rd_add_A_1 = rd_basic_add_A + rd_add_bias_A_1;
    assign rd_add_A_2 = rd_basic_add_A + rd_add_bias_A_2;
    assign rd_add_B_0 = rd_basic_add_B + rd_add_bias_B_0;
    assign rd_add_B_1 = rd_basic_add_B + rd_add_bias_B_1;
    assign rd_add_B_2 = rd_basic_add_B + rd_add_bias_B_2;
    assign wr_add = wr_basic_add + wr_add_bias_part1 + wr_add_bias_part2;

    //==always==
    //rd_add_bias_A_0
    always_ff @( posedge clk or posedge rst) begin
        if(rst == 1 | l_cnt == l_max) begin
            rd_add_bias_A_0 <= 0;
        end
        else begin
            if(en == 1 & l_cnt != l_max & l_cnt != l_max - 1) begin
                if(l2_cnt == l2_max && l1_cnt == l1_max && l0_cnt == l0_max) begin
                    rd_add_bias_A_0 <= 0;
                end
                else begin
                    if(l1_cnt == l1_max && l0_cnt == l0_max) begin
                        rd_add_bias_A_0 <= rd_add_bias_A_0 + A2_add;
                    end
                    else begin
                        if(l0_cnt == l0_max) begin
                            rd_add_bias_A_0 <= rd_add_bias_A_0 + A1_add;
                        end
                        else begin
                            rd_add_bias_A_0 <= rd_add_bias_A_0 + 1;
                        end
                    end
                end
            end
            else begin
                rd_add_bias_A_0 <= 0;
            end
        end
    end

    //rd_add_bias_A_1
    always_ff @( posedge clk or rst ) begin
        if(rst == 1 | l_cnt == l_max) begin
            rd_add_bias_A_1 <= 0;
        end
        else begin
            if(en == 1) begin
                rd_add_bias_A_1 <= rd_add_bias_A_0 + r_add;
            end
        end
    end

    //rd_add_bias_A_2
    always_ff @( posedge clk or rst ) begin
        if(rst == 1 | l_cnt == l_max) begin
            rd_add_bias_A_2 <= 0;
        end
        else begin
            if(en == 1) begin
                if (l_cnt < 1) begin
                    rd_add_bias_A_2 <= 0;
                end
                else begin
                    rd_add_bias_A_2 <= rd_add_bias_A_1 + r_add;
                end
            end
        end
    end

    // rd_add_bias_B_0
    always_ff @( posedge clk or posedge rst ) begin
        if (rst == 1 | l_cnt == l_max) begin
            rd_add_bias_B_0 <= 0;
        end
        else begin
            if(en == 1) begin
                if(l2_cnt == l2_max && l1_cnt == l1_max && l0_cnt == l0_max) begin
                    rd_add_bias_B_0 <= 0;
                end
                else begin
                    if(l1_cnt == l1_max && l0_cnt == l0_max) begin
                        rd_add_bias_B_0 <= 0;
                    end
                    else begin
                        if(l0_cnt == l0_max) begin
                            rd_add_bias_B_0 <= rd_add_bias_B_0 + B1_add;
                        end
                        else begin
                            rd_add_bias_B_0 <= rd_add_bias_B_0 + B0_add;
                        end
                    end
                end
            end
            else begin
                rd_add_bias_B_0 <= rd_add_bias_B_0;
            end
        end
    end

    // rd_add_bias_B_1
    always_ff @( posedge clk or posedge rst ) begin
        if(rst == 1 | l_cnt == l_max) begin
            rd_add_bias_B_1 <= 0;
        end
        else begin
            rd_add_bias_B_1 <= rd_add_bias_B_0 + 1;
        end
    end

    // rd_add_bias_B_2
    always_ff @( posedge clk or posedge rst ) begin
        if(rst == 1 | l_cnt == l_max) begin
            rd_add_bias_B_2 <= 0;
        end
        else begin
            if (l_cnt < 1) begin
                rd_add_bias_B_2 <= 0;
            end
            else begin
                rd_add_bias_B_2 <= rd_add_bias_B_1 + 1;
            end
        end
    end

    // wr_add_bias_part1 -- 由输入计数器决定的主偏置 3*3 矩阵左上角点坐标
    always_ff @( posedge clk or posedge rst ) begin
        if(rst == 1) begin
            wr_add_bias_part1 <= 0;
        end
        else begin
            if(en == 1) begin
                if(l0_cnt == l0_max) begin
                    if(l1_cnt == 0) begin
                        if (l2_cnt == 0) begin
                            // 对应初始化
                            wr_add_bias_part1 <= 0;
                        end
                        else begin
                            // 对应输出换行(三行后)
                            wr_add_bias_part1 <= wr_add_bias_part1 + wr_bias_part1_add;
                        end
                    end
                    else begin
                        // 输出换列(三列后)
                        wr_add_bias_part1 <= wr_add_bias_part1 + 3;
                    end
                end
                else begin
                    wr_add_bias_part1 <= wr_add_bias_part1;
                end
            end
            else begin
                wr_add_bias_part1 <= 0;
            end
        end
    end

    // wr_add_bias_part2 -- 由输出计数器决定的次偏置
    always_ff @( posedge clk or posedge rst ) begin
        if(rst == 1) begin
            wr_add_bias_part2 <= 0;
        end
        else begin
            if(en == 1) begin
                case (wr_cnt)
                    0: wr_add_bias_part2 <= 0;
                    1: wr_add_bias_part2 <= wr_add_bias_part2 + 1;
                    2: wr_add_bias_part2 <= wr_add_bias_part2 + wr_bias_part2_add1;
                    3: wr_add_bias_part2 <= wr_add_bias_part2 + wr_bias_part2_add2;
                    4: wr_add_bias_part2 <= wr_add_bias_part2 + wr_bias_part2_add1;
                    5: wr_add_bias_part2 <= wr_add_bias_part2 + wr_bias_part2_add1;
                    6: wr_add_bias_part2 <= wr_add_bias_part2 + wr_bias_part2_add2;
                    7: wr_add_bias_part2 <= wr_add_bias_part2 + wr_bias_part2_add1;
                    8: wr_add_bias_part2 <= wr_add_bias_part2 + 1;
                    default: wr_add_bias_part2 <= 0;
                endcase
            end
            else begin
                wr_add_bias_part2 <= 0;
            end
        end
    end

    // l_cnt
    always_ff @( posedge clk or posedge rst ) begin
        if (rst == 1) begin
            l_cnt <= 0;
        end
        else begin
            if(en == 1) begin
                if(l_cnt == l_max) begin
                    l_cnt <= 0;
                end
                else begin
                    l_cnt <= l_cnt + 1;
                end
            end
            else begin
                l_cnt <= l_cnt;
            end
        end
    end
    
    //l0_cnt
    always_ff @( posedge clk or posedge rst) begin
        if (rst == 1 | l_cnt == l_max) begin
            l0_cnt <= 0;
        end
        else begin
            if(en == 1) begin
                if(l0_cnt == l0_max) begin
                    if(l_cnt >= l_max - 2) begin
                        l0_cnt <= l0_cnt;
                    end
                    else begin
                        l0_cnt <= 0;
                    end
                end
                else begin
                    l0_cnt <= l0_cnt + 1;
                end
            end
            else begin
                l0_cnt <= l0_cnt;
            end
        end
    end

    //l1_cnt
    always_ff @( posedge clk or posedge rst) begin
        if (rst == 1 | l_cnt == l_max) begin
            l1_cnt <= 0;
        end
        else begin
            if(en == 1) begin
                if(l1_cnt == l1_max && l0_cnt == l0_max) begin
                    if(l_cnt >= l_max - 2) begin
                        l1_cnt <= l1_cnt;
                    end
                    else begin
                        l1_cnt <= 0;
                    end
                end
                else begin
                    if(l0_cnt == l0_max) begin
                        l1_cnt <= l1_cnt + 1;
                    end
                    else begin
                        l1_cnt <= l1_cnt;
                    end
                end
            end
            else begin
                l1_cnt <= l1_cnt;
            end
        end
    end
    //l2_cnt
    always_ff @( posedge clk or posedge rst) begin
        if (rst == 1 | l_cnt == l_max) begin
            l2_cnt <= 0;
        end
        else begin
            if(en == 1) begin
                if(l2_cnt == l2_max && l1_cnt ==l1_max && l0_cnt == l0_max) begin
                    if(l_cnt >= l_max - 2) begin
                        l2_cnt <= l2_cnt;
                    end
                    else begin
                        l2_cnt <= 0;
                    end
                end
                else begin
                    if(l1_cnt == l1_max && l0_cnt == l0_max) begin
                        l2_cnt <= l2_cnt + 1;
                    end
                    else begin
                        l2_cnt <= l2_cnt;
                    end
                end
            end
            else begin
                l2_cnt <= l2_cnt;
            end
        end
    end

    //next
    always_ff @( posedge clk or posedge rst ) begin
        if(rst == 1 | l_cnt == l_max) begin
            next <= 0;
        end
        else begin
            if (en == 1) begin
                if (l0_cnt == l0_max) begin
                    next <= 1;
                end
                else begin
                    next <= 0;
                end
            end
            else begin
                next <= 0;
            end
        end
    end

    //wr_cnt
    always_ff @( posedge clk or posedge rst ) begin
        if(rst == 1) begin
            wr_cnt <= 0;
        end
        else begin
            if(en == 1) begin
                case (wr_cnt)
                    0: if(next == 1) begin
                        wr_cnt <= wr_cnt + 1;
                    end
                    8: wr_cnt <= 0; 
                    default: wr_cnt <= wr_cnt + 1;
                endcase
            end
            else begin
                wr_cnt <= 0;
            end
        end
    end

    //比地址信号晚一个clk到
    //en_row
    always_ff @( posedge clk or posedge rst ) begin
        if(rst == 1 | l_cnt == l_max) begin
            en_row <= 3'b000;
        end
        else begin
            if(en == 1) begin
                if(l_cnt <= l_max - 2) begin
                    en_row[0] <= 1;
                end
                else begin
                    en_row[0] <= 0;
                end

                if(l_cnt >= 1 & l_cnt <= l_max - 1) begin
                    if(l0_cnt == 0) begin
                        en_row[1] <= en_row[1];
                    end
                    else begin
                        if(l2_cnt != l2_max) begin
                            en_row[1] <= 1;
                        end
                        else begin
                            if(H_res == 2'b10 | H_res == 2'b11) begin
                                en_row[1] <= 1;
                            end
                            else begin
                                en_row[1] <= 0;
                            end
                        end
                    end
                end
                else begin
                    en_row[1] <= 0;
                end

                if(l_cnt >= 2 & l_cnt <= l_max) begin
                    if(l0_cnt == 0 | l0_cnt == 1) begin
                        en_row[2] <= en_row[2];
                    end
                    else begin
                        if(l2_cnt != l2_max) begin
                            en_row[2] <= 1;
                        end
                        else begin
                            if(H_res == 2'b11) begin
                                en_row[2] <= 1;
                            end
                            else begin
                                en_row[2] <= 0;
                            end
                        end
                    end
                end
                else begin
                    en_row[2] <= 0;
                end
            end
            else begin
                en_row <= 3'b000;
            end
        end
    end

    //en_col
    always_ff @( posedge clk or posedge rst ) begin
        if(rst == 1) begin
            en_col <= 3'b000;
        end
        else begin
            if(en == 1) begin
                if(l_cnt <= l_max - 2) begin
                    en_col[0] <= 1;
                end
                else begin
                    en_col[0] <= 0;
                end

                if(l_cnt >= 1 & l_cnt <= l_max - 1) begin
                    if(l0_cnt == 0) begin
                        en_col[1] <= en_col[1];
                    end
                    else begin
                        if(l1_cnt != l1_max)begin
                            en_col[1] <= 1;
                        end
                        else begin
                            if(W_res == 2'b10 | W_res == 2'b11) begin
                                en_col[1] <= 1;
                            end
                            else begin
                                en_col[1] <= 0;
                            end
                        end
                    end
                end
                else begin
                    en_col[1] <= 0;
                end

                if(l_cnt >= 2 & l_cnt <= l_max) begin
                    if(l0_cnt == 0 | l0_cnt == 1) begin
                        en_col[2] <= en_col[2];
                    end
                    else begin
                        if(l1_cnt != l1_max)begin
                            en_col[2] <= 1;
                        end
                        else begin
                            if(W_res == 2'b11) begin
                                en_col[2] <= 1;
                            end
                            else begin
                                en_col[2] <= 0;
                            end
                        end
                    end
                end
                else begin
                    en_col[2] <= 0;
                end
            end
            else begin
                en_col <= 3'b000;
            end
        end
    end
endmodule
