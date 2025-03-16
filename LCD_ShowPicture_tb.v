`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/15 16:58:21
// Design Name: 
// Module Name: LCD_ShowPicture_tb
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


module LCD_ShowPicture_tb;

    // 输入信号
    reg clk;
    reg rst_n;
    reg start;
    reg [15:0] x;
    reg [15:0] y;
    reg [15:0] length;
    reg [15:0] width;
    reg lcd_wr_done;
    // 输出信号
    wire [7:0] lcd_data;
    wire lcd_wr_en;

    // 实例化被测模块
    LCD_ShowPicture uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .x(x),
        .y(y),
        .length(length),
        .width(width),
        .lcd_wr_done(lcd_wr_done),
        .lcd_data(lcd_data),
        .lcd_wr_en(lcd_wr_en)
    );

    // 时钟生成
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // 50M时钟
    end

    // 测试逻辑
    initial begin
        // 初始化输入信号
        rst_n = 0;  // 复位
        start = 0;
        x = 0;
        y = 0;
        length = 0;
        width = 0;
        lcd_wr_done = 0;

        // 释放复位信号
        #20;
        rst_n = 1;

        // 设置输入参数
        #10;
        x = 16'd0;      // 起始坐标 x = 16
        y = 16'd0;      // 起始坐标 y = 32
        length = 16'd320; // 图片长度 = 64
        width = 16'd480;  // 图片宽度 = 48

        // 启动信号
        #10;
        start = 1;
        #10;
        start = 0;

        // 等待测试完成
        #1000;  // 根据需要调整仿真时间
        lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000
        lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000        
        lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000
        lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000        
        lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
        lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
        lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
        lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
        lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
        lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
        lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
        lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
                lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
                lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
                lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
                lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
                lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
                lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
                lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
                lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
                lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
                lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
                lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
                lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
                lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
                lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
                lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
                lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;
                lcd_wr_done = 1;
        #20;
        lcd_wr_done = 0;
        #1000;


        // 结束仿真

    end

    // 监视信号变化
    initial begin
        $monitor("Time: %0t | rst_n: %b | start: %b | lcd_data: %h | lcd_wr_en: %b",
                 $time, rst_n, start, lcd_data, lcd_wr_en);
    end

endmodule
