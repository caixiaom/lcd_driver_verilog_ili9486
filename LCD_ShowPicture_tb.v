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

    // �����ź�
    reg clk;
    reg rst_n;
    reg start;
    reg [15:0] x;
    reg [15:0] y;
    reg [15:0] length;
    reg [15:0] width;
    reg lcd_wr_done;
    // ����ź�
    wire [7:0] lcd_data;
    wire lcd_wr_en;

    // ʵ��������ģ��
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

    // ʱ������
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // 50Mʱ��
    end

    // �����߼�
    initial begin
        // ��ʼ�������ź�
        rst_n = 0;  // ��λ
        start = 0;
        x = 0;
        y = 0;
        length = 0;
        width = 0;
        lcd_wr_done = 0;

        // �ͷŸ�λ�ź�
        #20;
        rst_n = 1;

        // �����������
        #10;
        x = 16'd0;      // ��ʼ���� x = 16
        y = 16'd0;      // ��ʼ���� y = 32
        length = 16'd320; // ͼƬ���� = 64
        width = 16'd480;  // ͼƬ��� = 48

        // �����ź�
        #10;
        start = 1;
        #10;
        start = 0;

        // �ȴ��������
        #1000;  // ������Ҫ��������ʱ��
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


        // ��������

    end

    // �����źű仯
    initial begin
        $monitor("Time: %0t | rst_n: %b | start: %b | lcd_data: %h | lcd_wr_en: %b",
                 $time, rst_n, start, lcd_data, lcd_wr_en);
    end

endmodule
