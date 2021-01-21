

module clock_divider (clk_div, clk);
    parameter n = 15;
    input clk;
    output clk_div;
    reg [n-1:0] num;
    wire [n-1:0] next_num;

    always @(posedge clk) begin
        num = next_num;
    end

    assign next_num = num + 1;
    assign clk_div = num[n-1];
endmodule

module lab5(clk, rst, money_5, money_10, cancel, check,
count_down, LED, DIGIT, DISPLAY);
    input clk;
    input rst;
    input money_5;
    input money_10;
    input cancel;
    input check;
    input count_down;
    output [15:0] LED;
    output [3:0] DIGIT;
    output [6:0] DISPLAY;

    wire clk_div13;
    wire clk_div16;
    wire clk_div27;

    clock_divider #(13) m11(clk_div13, clk);
    clock_divider #(16) m12(clk_div16, clk);
    clock_divider #(27) m13(clk_div27, clk);

    wire money_5_;
    wire money_10_;
    wire cancel_;
    wire count_down_;
    wire check_;
    wire money_5_temp;
    wire money_10_temp;
    wire cancel_temp;
    wire count_down_temp;
    wire check_temp;

    debounce m1(.pb_debounced(money_5_), .pb(money_5), .clk(clk_div16));
    debounce m2(.pb_debounced(money_10_), .pb(money_10), .clk(clk_div16));
    debounce m3(.pb_debounced(cancel_), .pb(cancel), .clk(clk_div16));
    debounce m4(.pb_debounced(count_down_), .pb(count_down), .clk(clk_div16));
    debounce m5(.pb_debounced(check_), .pb(check), .clk(clk_div16));
    onepulse m6(.rst(rst), .clk(clk_div16), .pb_debounced(money_5_), .pb_1pulse(money_5_temp));
    onepulse m7(.rst(rst), .clk(clk_div16), .pb_debounced(money_10_), .pb_1pulse(money_10_temp));
    onepulse m8(.rst(rst), .clk(clk_div16), .pb_debounced(cancel_), .pb_1pulse(cancel_temp));
    onepulse m9(.rst(rst), .clk(clk_div16), .pb_debounced(count_down_), .pb_1pulse(count_down_temp));
    onepulse m10(.rst(rst), .clk(clk_div16), .pb_debounced(check_), .pb_1pulse(check_temp));

    reg [3:0] value;
    reg [3:0] value1;
    reg [3:0] value2;
    reg [3:0] value3;
    reg [3:0] value4;
    reg [6:0] DISPLAY_temp;
    reg [3:0] DIGIT_temp;

    always @(posedge clk_div16) begin
        case (DIGIT_temp)
            4'b0111: begin
                value = value1;
                DIGIT_temp = 4'b1110;
            end
            4'b1110: begin
                value = value2;
                DIGIT_temp = 4'b1101;
            end
            4'b1101: begin
                value = value3;
                DIGIT_temp = 4'b1011;
            end
            4'b1011: begin
                value = value4;
                DIGIT_temp = 4'b0111;
            end
            default: begin
                DIGIT_temp = 4'b0111;
            end
        endcase
    end

    always @* begin
        case (value)
            4'd0: DISPLAY_temp = 7'b1000000;
            4'd1: DISPLAY_temp = 7'b1111001;
            4'd2: DISPLAY_temp = 7'b0100100;
            4'd3: DISPLAY_temp = 7'b0110000;
            4'd4: DISPLAY_temp = 7'b0011001;
            4'd5: DISPLAY_temp = 7'b0010010;
            4'd6: DISPLAY_temp = 7'b0000010;
            4'd7: DISPLAY_temp = 7'b1111000;
            4'd8: DISPLAY_temp = 7'b0000000;
            4'd9: DISPLAY_temp = 7'b0010000;
            4'd10: DISPLAY_temp = 7'b0100000;
            4'd11: DISPLAY_temp = 7'b0101011;
            4'd12: DISPLAY_temp = 7'b0100001;
            4'd13: DISPLAY_temp = 7'b0010001; 
        endcase
    end

    reg clk_temp;
    reg [2:0] state;
    integer flag1 = 0;
    reg [3:0] value1_temp;
    reg [3:0] value2_temp;
    reg [3:0] value3_temp;
    reg [3:0] value4_temp;
    reg [7:0] temp;

    always @* begin
        if(state == 3'd0 || state == 3'd1 || state == 3'd2)begin
            clk_temp = clk_div16;
        end
        else if(state == 3'd3 || state == 3'd4)begin
            clk_temp = clk_div27;
        end
        else begin
            clk_temp = clk_div27;
        end
    end

    reg [15:0] led = 16'b0000000000000000;
    reg [7:0] max;
    reg [15:0] bonus;

    always @(posedge clk_temp or posedge rst)begin
        //INITIAL = 0
        if(rst == 1)begin
            value1 = 4'd0;
            value2 = 4'd0;
            value3 = 4'd0;
            value4 = 4'd0;
            led = 16'b0000000000000000;
            state = 3'd0;
        end
        else if(state == 3'd0)begin
            value1 = 4'd0;
            value2 = 4'd0;
            value3 = 4'd0;
            value4 = 4'd0;
            led = 16'b0000000000000000;
            state = 3'd1;
            max = 4'd0;
        end
        else if(state == 3'd1)begin
            if(money_5_temp == 1)begin
                if(value1 == 4'd0 && value2 == 4'd5)begin
                    value1 = value1;
                    value2 = value2;
                    value3 = value3;
                    value4 = value4;
                end
                else if(value1 == 4'd5)begin
                    value1 = 4'd0;
                    value2 = value2 + 4'd1;
                    if(value3 < 4'd9)begin
                        value3 = value3 + 4'd1;
                    end
                    else begin
                        value3 = value3;
                    end
                    
                    value4 = value4;
                end
                else if(value1 == 4'd0)begin
                    value1 = 4'd5;
                    if(value3 < 4'd9)begin
                        value3 = value3 + 4'd1;
                    end
                    else begin
                        value3 = value3;
                    end
                end
                else begin
                    value3 = value3;
                end
            end
            else if(money_10_temp == 1)begin
                if((value1 == 4'd5 && value2 == 4'd4) || (value1 == 4'd0 && value2 == 4'd5))begin
                    value1 = 4'd0;
                    value2 = 4'd5;
                end
                else begin
                    value2 = value2 + 4'd1;
                    if(value3 == 4'd9)begin
                        value3 = value3;
                    end
                    else if(value3 == 4'd8)begin
                        value3 = value3 + 4'd1;
                    end
                    else if(value3 < 4'd8)begin
                        value3 = value3 + 4'd2;
                    end
                    else begin
                        value3 = value3;
                    end
                end
            end
            if(cancel_temp == 1 && (value1 > 4'd0 || value2 > 4'd0))begin
                state = 3'd4;
                value3 = 4'd0;
                value4 = 4'd0;
            end
            else if(check_temp == 1 && (value1 > 4'd0 || value2 > 4'd0))begin
                state = 3'd2;
                max = value3;
                bonus = 16'd0;
            end
            else begin
                state = 3'd1;
            end
        end
        //AMOUNT = 2
        else if(state == 3'd2)begin
            if(count_down_temp == 1)begin
                value3 = value3 - 4'd1;
                if(value3 == 4'd0)begin
                    value3 = max;
                end
                bonus = 16'd0;
            end
            else if(cancel_temp)begin
                state = 3'd4;
                value3 = 4'd0;
                value4 = 4'd0;
            end
            else if(check_temp)begin
                state = 3'd3;
                if(value2 == 4'd5)begin
                    max = 50;
                end
                else begin
                    max = max * 5;
                end
                temp = value3 * 5;
                temp = max - temp;
                value1_temp = temp % 10;
                value2_temp = temp / 10;
                value3_temp = value3;
                value4_temp = value4;
            end
            else begin
                if(bonus < 8192)begin
                    bonus = bonus + 16'd1;
                end
                else begin
                    state = 3'd4;
                    value3 = 4'd0;
                    value4 = 4'd0;
                end
            end
        end
        //RELEASE = 3
        else if(state == 3'd3)begin
            if(led == 16'b0000000000000000 && flag1 < 4)begin
                led = 16'b1111111111111111;
                flag1 = flag1 + 1;
            end
            else if(led == 16'b1111111111111111 && flag1 < 4)begin
                led = 16'b0000000000000000;
            end
            else begin
                flag1 = flag1;
            end
            if(flag1 < 4)begin
                value4 = 4'd10;
                value3 = 4'd11;
                value2 = 4'd12;
                value1 = 4'd13;
            end
            else if(flag1 == 4)begin
                led = 16'b0000000000000000;
                flag1 = 0;
                state = 3'd4;
                value1 = value1_temp;
                value2 = value2_temp;
                value3 = 4'd0;
                value4 = 4'd0;
            end
            else begin
                state = state;
            end
        end
        //CHANGE = 4
        else if(state == 3'd4)begin
            value3 = 4'd0;
            value4 = 4'd0;
            if(value2 >= 4'd1)begin
                value2 = value2 - 4'd1;
            end
            else if(value2 == 4'd0 && value1 == 4'd5)begin
                value1 = 4'd0;
            end
            else if(value1 == 4'd0 && value2 == 4'd0)begin
                state = 3'd0;
            end
            else begin
                value2 = value2;
            end
        end
        else begin
            state = state;
        end
    end

    assign DISPLAY = DISPLAY_temp;
    assign DIGIT = DIGIT_temp;
    assign LED = led;

    //29 1 28 2 27 4 26 8 25 16 24 32 23 64 22 128 21 256 20 512 19 1024 18 2048 17 4096 16 8192

endmodule
