module clock_divider(
    input clk,
    input reset,
    output reg tick
);

reg [26:0] count;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        count <= 0;
        tick <= 0;
    end
    else if(count == 100_000_000 - 1) begin
        count <= 0;
        tick <= 1;   // 1-cycle pulse
    end
    else begin
        count <= count + 1;
        tick <= 0;
    end
end

endmodule
