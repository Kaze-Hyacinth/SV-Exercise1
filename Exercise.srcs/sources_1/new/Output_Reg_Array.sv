`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/16 14:39:17
// Design Name: 
// Module Name: Output_Reg_Array
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


module Output_Reg_Array(
    input logic clk, rst, en, 
    input logic [15:0] ans00, ans01, ans02, ans10, ans11, ans12, ans20, ans21, ans22,
    input logic [4:0] next,
    output logic [15:0] wr_data
    );
    logic [15:0] reg00, reg01, reg02, reg10, reg11, reg12, reg20, reg21, reg22;
    logic [3:0] wr_sel = 0;
    //wr_data
    always_comb begin
        case (wr_sel)
            1: wr_data = reg00;
            2: wr_data = reg01;
            3: wr_data = reg10;
            4: wr_data = reg02;
            5: wr_data = reg11;
            6: wr_data = reg20;
            7: wr_data = reg12;
            8: wr_data = reg21; 
            9: wr_data = reg22;
            default: wr_data = 0;
        endcase
    end
    //wr_sel
    always_ff @( posedge clk or posedge rst ) begin
        if(rst == 1) begin
            wr_sel <= 0;
        end
        else begin
            if (en == 1) begin
                if(next[0] == 1) begin
                    if(wr_sel == 0) begin
                        wr_sel <= 1;
                    end
                    else begin
                        wr_sel <= wr_sel;
                    end
                end
                else begin
                    if(wr_sel == 9 | wr_sel == 0) begin
                        wr_sel <= 0;
                    end
                    else begin
                        wr_sel <= wr_sel + 1;
                    end
                end
            end
            else begin
                wr_sel <= 0;
            end
        end
    end
    //-next[0]
    always_ff @( posedge clk or posedge rst ) begin
        if(rst == 1) begin
            reg00 <= 0;
        end
        else begin
            if(en == 1) begin
                if(next[0] == 1) begin
                    reg00 <= ans00;
                end
                else begin
                    reg00 <= reg00;
                end
            end
            else begin
                reg00 <= 0;
            end
        end
    end

    //-next[1]
    always_ff @( posedge clk or posedge rst ) begin
        if(rst == 1) begin
            reg01 <= 0;
        end
        else begin
            if(next[1] == 1) begin
                reg01 <= ans01;
            end
            else begin
                reg01 <= reg01;
            end
        end
    end

    always_ff @( posedge clk or posedge rst ) begin
        if(rst == 1) begin
            reg10 <= 0;
        end
        else begin
            if(next[1] == 1) begin
                reg10 <= ans10;
            end
            else begin
                reg10 <= reg10;
            end
        end
    end

    //-next[2]
    always_ff @( posedge clk or posedge rst ) begin
        if(rst == 1) begin
            reg02 <= 0;
        end
        else begin
            if(next[2] == 1) begin
                reg02 <= ans02;
            end
            else begin
                reg02 <= reg02;
            end
        end
    end

    always_ff @( posedge clk or posedge rst ) begin
        if(rst == 1) begin
            reg11 <= 0;
        end
        else begin
            if(next[2] == 1) begin
                reg11 <= ans11;
            end
            else begin
                reg11 <= reg11;
            end
        end
    end

    always_ff @( posedge clk or posedge rst ) begin
        if(rst == 1) begin
            reg20 <= 0;
        end
        else begin
            if(next[2] == 1) begin
                reg20 <= ans20;
            end
            else begin
                reg20 <= reg20;
            end
        end
    end

    //-next[3]
    always_ff @( posedge clk or posedge rst ) begin
        if(rst == 1) begin
            reg12 <= 0;
        end
        else begin
            if(next[3] == 1) begin
                reg12 <= ans12;
            end
            else begin
                reg12 <= reg12;
            end
        end
    end

    always_ff @( posedge clk or posedge rst ) begin
        if(rst == 1) begin
            reg21 <= 0;
        end
        else begin
            if(next[3] == 1) begin
                reg21 <= ans21;
            end
            else begin
                reg21 <= reg21;
            end
        end
    end

    //-next[4]
    always_ff @( posedge clk or posedge rst ) begin
        if(rst == 1) begin
            reg22 <= 0;
        end
        else begin
            if(next[4] == 1) begin
                reg22 <= ans22;
            end
            else begin
                reg22 <= reg22;
            end
        end
    end
endmodule
