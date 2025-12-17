`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/09 15:02:51
// Design Name: 
// Module Name: tb_Memory
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


`timescale 1ns/1ps

module tb_Memory;

// 时钟参数
parameter CLK_PERIOD = 10;  // 100MHz时钟

// 接口信号
logic clk;
logic rst;
logic rd_en0, rd_en1, rd_en2;
logic [9:0] rd_add0, rd_add1, rd_add2;
logic wr_en;
logic [9:0] wr_add;
logic [15:0] wr_data;
logic [15:0] rd_data0, rd_data1, rd_data2;

// 实例化被测试模块
Memory dut (
    .clk(clk),
    .rst(rst),
    .rd_en0(rd_en0),
    .rd_en1(rd_en1),
    .rd_en2(rd_en2),
    .rd_add0(rd_add0),
    .rd_add1(rd_add1),
    .rd_add2(rd_add2),
    .wr_en(wr_en),
    .wr_add(wr_add),
    .wr_data(wr_data),
    .rd_data0(rd_data0),
    .rd_data1(rd_data1),
    .rd_data2(rd_data2)
);

// 时钟生成
initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end

// 测试控制
integer error_count = 0;
integer test_count = 0;
task automatic wr_matrix(
    input int H = 16,
    input int W = 16,
    input int base_add = 0
);
    int matrix[][];
    
    matrix = new[H];
    for (int i = 0; i < H; i++) begin
        matrix[i] = new[W];
    end
    
    for (int i = 0; i < H; i++) begin
        for (int j = 0; j < W; j++) begin
            @(posedge clk);
            wr_en = 1;
            matrix[i][j] = $urandom_range(20, 0);
            wr_add = base_add + i * W + j;
            wr_data = matrix[i][j];
            $write("%d ",matrix[i][j]);
        end
        $write("\n");
    end
    @(posedge clk);
    wr_en = 0;
endtask
task automatic rd_matrix(
    input int H = 16,
    input int W = 16,
    input int base_add = 0
);
    for (int i = 0; i < H; i++) begin
        for (int j = 0; j < W; j++) begin
            @(posedge clk);
            rd_en0 = 1;
            rd_add0 = base_add + i * W + j;
        end
    end
    @(posedge clk);
    rd_en0 = 0;
endtask 
initial begin
    $display("==========================================");
    $display("Memory Module Testbench");
    $display("==========================================");
    
    // 初始化信号
    rst = 0;
    rd_en0 = 0;
    rd_en1 = 0;
    rd_en2 = 0;
    rd_add0 = 0;
    rd_add1 = 0;
    rd_add2 = 0;
    wr_en = 0;
    wr_add = 0;
    wr_data = 0;
    
    //矩阵输入
    wr_matrix(14,16,0);
    @(posedge clk);
    rd_matrix(14,16,0);
    $finish;
end

// 波形记录
initial begin
    $dumpfile("tb_memory.vcd");
    $dumpvars(0, tb_Memory);
end

// 超时保护
initial begin
    #1000000;  // 1ms超时
    $display("ERROR: Simulation timeout!");
    $finish;
end

endmodule
