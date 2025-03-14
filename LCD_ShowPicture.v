module LCD_ShowPicture (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] x,
    input wire [15:0] y,
    input wire [15:0] length,
    input wire [15:0] width,
    output reg [17:0] ram_addr,
    input wire [23:0] ram_data,
    output reg ram_rd_en,
    output reg [7:0] lcd_data, // 每个像素点的颜色，发送给spi
    output reg lcd_wr_en,
    output reg [7:0] lcd_cmd
    
);

    // 状态编码
    localparam IDLE        = 3'b000;
    localparam SET_ADDRESS = 3'b001;
    localparam READ_PIXEL  = 3'b010;
    localparam WRITE_PIXEL = 3'b011;
    localparam DONE        = 3'b100;

    reg [2:0] state;  // 当前状态
     reg [2:0] next_state;   // 下一个状态
    // 状态机逻辑
      always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;  // 默认保持当前状态
        case (state)
            IDLE: begin
                if (start) begin
                    next_state = SET_ADDRESS;
                end
            end

            SET_ADDRESS: begin
                next_state = READ_PIXEL;
            end

            READ_PIXEL: begin
                next_state = WRITE_PIXEL;
            end

            WRITE_PIXEL: begin
                if (j == width - 1 && i == length - 1) begin
                    next_state = DONE;
                end else begin
                    next_state = READ_PIXEL;
                end
            end

            DONE: begin
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // 输出逻辑（组合逻辑）
    always @(*) begin
        // 默认值
        ram_rd_en = 0;
        lcd_wr_en = 0;
        ram_addr = 0;
        lcd_data = 0;

        case (state)
            IDLE: begin
                // 无操作
            end

            SET_ADDRESS: begin
                // 设置 LCD 显示区域（假设由外部模块完成）
            end

            READ_PIXEL: begin
                ram_addr = k;  // 设置 RAM 地址
                ram_rd_en = 1; // 使能 RAM 读
            end

            WRITE_PIXEL: begin
                lcd_data = ram_data; // 将 RAM 数据写入 LCD 数据线
                lcd_wr_en = 1;       // 使能 LCD 写
            end

            DONE: begin
                // 无操作
            end
        endcase
    end

 always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 0;
            j <= 0;
            k <= 0;
        end else begin
            case (state)
                IDLE: begin
                    i <= 0;
                    j <= 0;
                    k <= 0;
                end

                WRITE_PIXEL: begin
                    k <= k + 1;
                    j <= j + 1;
                    if (j == width - 1) begin
                        j <= 0;
                        i <= i + 1;
                    end
                end

                default: begin
                    // 保持当前值
                end
            endcase
        end
    end

endmodule