module debounce(
    input clk,
    input reset,
    input button,
    output reg pulse
);

reg [19:0] count;
reg btn_sync_0, btn_sync_1;
reg btn_stable;
reg btn_prev;

// Synchronizer
always @(posedge clk) begin
    btn_sync_0 <= button;
    btn_sync_1 <= btn_sync_0;
end

// Debounce
always @(posedge clk or posedge reset) begin
    if(reset) begin
        count <= 0;
        btn_stable <= 0;
    end
    else if(btn_sync_1 != btn_stable) begin
        count <= count + 1;
        if(count == 1_000_000) begin
            btn_stable <= btn_sync_1;
            count <= 0;
        end
    end
    else begin
        count <= 0;
    end
end

// Edge detect (1 pulse)
always @(posedge clk or posedge reset) begin
    if(reset) begin
        btn_prev <= 0;
        pulse <= 0;
    end
    else begin
        pulse <= btn_stable & ~btn_prev;
        btn_prev <= btn_stable;
    end
end

endmodule
