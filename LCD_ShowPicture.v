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
    output reg [23:0] lcd_data,
    output reg lcd_wr_en
);

    // 状态编码
    localparam IDLE        = 3'b000;
    localparam SET_ADDRESS = 3'b001;
    localparam READ_PIXEL  = 3'b010;
    localparam WRITE_PIXEL = 3'b011;
    localparam DONE        = 3'b100;

    reg [2:0] state;  // 当前状态
    reg [15:0] i, j;  // 循环计数器
    reg [15:0] k;     // 像素索引

    // 状态机逻辑
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            ram_rd_en <= 0;
            lcd_wr_en <= 0;
            ram_addr <= 0;
            lcd_data <= 0;
            i <= 0;
            j <= 0;
            k <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= SET_ADDRESS;
                        i <= 0;
                        j <= 0;
                        k <= 0;
                    end
                end

                SET_ADDRESS: begin
                    // 设置 LCD 显示区域
                    state <= READ_PIXEL;
                end

                READ_PIXEL: begin
                    ram_addr <= k;
                    ram_rd_en <= 1;
                    state <= WRITE_PIXEL;
                end

                WRITE_PIXEL: begin
                    lcd_data <= ram_data;
                    lcd_wr_en <= 1;
                    ram_rd_en <= 0;

                    k <= k + 1;
                    j <= j + 1;
                    if (j == width - 1) begin
                        j <= 0;
                        i <= i + 1;
                        if (i == length - 1) begin
                            state <= DONE;
                        end else begin
                            state <= READ_PIXEL;
                        end
                    end else begin
                        state <= READ_PIXEL;
                    end
                end

                DONE: begin
                    lcd_wr_en <= 0;
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule