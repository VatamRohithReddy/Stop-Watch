module seven_seg_driver(
    input clk,
    input reset,
    input [15:0] data,
    input tick,
    output reg [6:0] seg,
    output reg [3:0] an,
    output reg dp
);

reg [1:0] digit;
reg [3:0] current_digit;
reg [19:0] refresh_counter;
reg colon;

// Refresh
always @(posedge clk or posedge reset) begin
    if(reset) begin
        refresh_counter <= 0;
        digit <= 0;
    end
    else begin
        refresh_counter <= refresh_counter + 1;
        digit <= refresh_counter[19:18];
    end
end

// Colon blink
always @(posedge clk or posedge reset) begin
    if(reset)
        colon <= 0;
    else if(tick)
        colon <= ~colon;
end

// Digit select
always @(*) begin
    an = 4'b1111;
    current_digit = 0;
    dp = 1;

    case(digit)
        2'b00: begin an = 4'b1110; current_digit = data[3:0]; end
        2'b01: begin an = 4'b1101; current_digit = data[7:4]; dp = colon ? 0 : 1; end
        2'b10: begin an = 4'b1011; current_digit = data[11:8]; dp = colon ? 0 : 1; end
        2'b11: begin an = 4'b0111; current_digit = data[15:12]; end
    endcase
end

// Decoder
always @(*) begin
    case(current_digit)
        4'd0: seg = 7'b1000000;
        4'd1: seg = 7'b1111001;
        4'd2: seg = 7'b0100100;
        4'd3: seg = 7'b0110000;
        4'd4: seg = 7'b0011001;
        4'd5: seg = 7'b0010010;
        4'd6: seg = 7'b0000010;
        4'd7: seg = 7'b1111000;
        4'd8: seg = 7'b0000000;
        4'd9: seg = 7'b0010000;
        default: seg = 7'b1111111;
    endcase
end

endmodule
