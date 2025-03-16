module LCD_ShowPicture (
    input wire clk,
    input wire rst_n,

    input wire start,
    input wire [15:0] x,
    input wire [15:0] y,
    input wire [15:0] length,
    input wire [15:0] width,
    input wire lcd_wr_done,


    output reg [7:0] lcd_data,      // 每个像素点的颜色，发送给spi
    output reg lcd_wr_en,        // 写使能信号
    output reg add_dc
    );

    reg [17:0] ram_addr;  // RAM 地址
    wire [23:0] ram_data;   // RAM 数据

    // 状态编码
    localparam IDLE        = 3'b000;
    localparam SET_ADDRESS = 3'b001;
    localparam READ_PIXEL  = 3'b010;
    localparam WRITE_PIXEL = 3'b011;
    localparam DONE        = 3'b100;

    reg lcd_wr_done_delay;  // 延迟标志位
    reg lcd_wr_done_delay_r;  // 延迟标志位
    reg [2:0] state;  // 当前状态
    reg [2:0] next_state;   // 下一个状态

    // 指令发送计数器
    reg [3:0] cmd_counter;  // 用于计数发送的指令数量
    // 像素数据发送计数器
    reg [1:0] byte_counter;  // 用于计数发送的字节数量（0-2）
    reg cmd_sent;  // 标志当前指令是否已发送
    // 在模块中添加一个标志位

 always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cmd_counter <= 0;
            cmd_sent <= 0;
        end else begin
            if (state == SET_ADDRESS) begin
                if (lcd_wr_done_delay_r && !cmd_sent) begin
                    if (cmd_counter == 4'd11) 
                        begin
                            cmd_counter <= 0;  // 指令发送完成，计数器清零
                        end else begin
                            cmd_counter <= cmd_counter + 1;  // 指令发送完成，计数器加 1
                            cmd_sent <= 1;  // 标记当前指令已发送
                        end
                end else if (!lcd_wr_done) begin
                    cmd_sent <= 0;  // 等待下一个指令发送
                end
            end else begin
                cmd_counter <= 0;  // 非 SET_ADDRESS 状态时，计数器清零
                cmd_sent <= 0;
            end
        end
    end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lcd_wr_done_delay <= 0;
        lcd_wr_done_delay_r <= 0;
    end else begin
        lcd_wr_done_delay <= lcd_wr_done;  // 延迟一个时钟周期
        lcd_wr_done_delay_r <= lcd_wr_done_delay;  // 再延迟一个时钟周期
    end
end

    // 像素数据发送逻辑（单独列为一个块）
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            byte_counter <= 0;
        end else begin
            if (state == WRITE_PIXEL) begin
                if (lcd_wr_done_delay) begin
                    byte_counter <= byte_counter + 1;  // 字节发送完成，计数器加 1
                end 
            end else begin
                byte_counter <= 0;  // 非 WRITE_PIXEL 状态时，计数器清零
            end
        end
    end

    // 状态机逻辑
      always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // 状态转移逻辑
    always @(*) begin
        next_state = state;  // 默认保持当前状态
        case (state)
            IDLE: begin
                if (start) begin
                    next_state = SET_ADDRESS;
                end
            end

            SET_ADDRESS: begin
                if (cmd_counter == 4'd10 && lcd_wr_done_delay) begin
                    next_state = WRITE_PIXEL;
                end
            end

            READ_PIXEL: begin
                next_state = WRITE_PIXEL;
            end

            WRITE_PIXEL: begin
                if ((ram_addr == (x + length - 1) * (y + width - 1))&&(lcd_wr_done == 'd1)) begin
                    // 如果当前像素点是最后一个像素点，则进入 DONE 状态
                    next_state = DONE;
                end else begin
                    if (lcd_wr_done_delay == 'd1 && byte_counter == 2'd2 ) begin
                        next_state = READ_PIXEL;
                    end
                    // 如果当前像素点不是最后一个像素点，则继续读取下一个像素点

                end
                end

            DONE: begin
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

wire [15:0] result_x;
wire [15:0] result_y;
assign result_x=  x + length - 1;
assign result_y =  y + width - 1;

    // 输出逻辑
    always @(posedge clk or negedge rst_n) begin
        // 默认值
        if (!rst_n) begin
            lcd_wr_en = 0;
            ram_addr = 0;
            lcd_data = 0;
        end else begin
            case (state)
                IDLE: begin
                    lcd_wr_en = 0;
                    ram_addr = 0;
                    lcd_data = 0;
                    add_dc = 0;
                end
                SET_ADDRESS: begin
                if (!cmd_sent) begin
                        if (cmd_counter == 4'd10 && lcd_wr_done_delay == 'd1 ) begin
                            lcd_wr_en <= 'd0;
                        end else begin
                            lcd_wr_en <= 'd1;  // 使能写信号
                        end
                        case (cmd_counter)
                            4'd0: begin
                                lcd_data <= 8'h2a;  // 设置 X 地址
                                add_dc <= 0;  // 设置为命令模式
                            end
                            4'd1: begin
                                lcd_data <= x[15:8];  // 设置 X 起始地址低 8 位
                                add_dc <= 1;  // 设置为数据模式
                            end
                            4'd2: lcd_data <= x[7:0];  // 设置 X 起始地址高 8 位
                            4'd3: lcd_data <= result_x[15:8];  // 设置 X 结束地址低 8 位
                            4'd4: lcd_data <= result_x[7:0];  // 设置 X 结束地址高 8 位
                            4'd5: begin
                                lcd_data <= 8'h2b;  // 设置 Y 地址
                                add_dc <= 0;  // 设置为命令模式
                            end 
                            4'd6: begin
                                lcd_data <= y[15:8];  // 设置 Y 起始地址低 8 位
                                add_dc <= 1;  // 设置为数据模式
                            end
                            4'd7: lcd_data <= y[7:0];  // 设置 Y 起始地址高 8 位
                            4'd8: lcd_data <= result_y[15:8];  // 设置 Y 结束地址高 8 位
                            4'd9: lcd_data <= result_y[7:0];  // 设置 Y 结束地址低 8 位
                            4'd10: begin
                                lcd_data <= 8'h2c;  // 写内存开始
                                add_dc <= 0;  // 设置为命令模式
                            end
                            default: lcd_data <= 0;
                        endcase
                    end else begin
                        lcd_wr_en <= 0;  // 等待 lcd_wr_done
                    end
                end

                READ_PIXEL: begin
                    ram_addr = ram_addr + 'd1;
                    lcd_wr_en = 'd0;
                end

                WRITE_PIXEL: begin
                     if ( lcd_wr_done_delay == 'd1 ) begin
                            lcd_wr_en <= 'd0;
                        end else begin
                            lcd_wr_en <= 'd1;  // 使能写信号
                            add_dc <= 1;  // 设置为数据模式
                        end
                    case (byte_counter)
                        2'b00: lcd_data <= ram_data[23:16];  // 发送第一个字节（R）
                        2'b01: lcd_data <= ram_data[15:8];   // 发送第二个字节（G）
                        2'b10: lcd_data <= ram_data[7:0];    // 发送第三个字节（B）
                        default: lcd_data <= 0;
                    endcase
                end

                DONE: begin
                    lcd_wr_en = 0;
                    ram_addr = 0;
                    lcd_data = 0;
                    add_dc = 0;
                end
            endcase 
        end
    end


rom_image_320x480 image_1 (
  .clka(clk),    // input wire clka
  .addra(ram_addr),  // input wire [17 : 0] addra
  .douta(ram_data)  // output wire [23 : 0] douta
);

reg [95:0]              Min_State_MACHINE_2;

always @(*) begin
		case(state)
			IDLE		:     Min_State_MACHINE_2 = "IDLE ";
			SET_ADDRESS		:     Min_State_MACHINE_2 = "SET_ADDRESS";
			READ_PIXEL		:     Min_State_MACHINE_2 = "READ_PIXEL";
			WRITE_PIXEL		:     Min_State_MACHINE_2 = "WRITE_PIXEL";
            DONE		:     Min_State_MACHINE_2 = "DONE";			
			default:Min_State_MACHINE_2 = "IDLE ";
		endcase
	end

endmodule