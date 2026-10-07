module stopwatch(
    input clk,
    input reset,
    input tick,
    input start,
    input pause,
    output reg [5:0] sec,
    output reg [5:0] min
);

parameter IDLE = 2'b00;
parameter RUN  = 2'b01;
parameter PAUSED = 2'b10;

reg [1:0] present_state, next_state;

// State register
always @(posedge clk or posedge reset) begin
    if(reset)
        present_state <= IDLE;
    else
        present_state <= next_state;
end

// Next state logic
always @(*) begin
    case(present_state)
        IDLE:    next_state = (start) ? RUN : IDLE;
        RUN:     next_state = (pause) ? PAUSED : RUN;
        PAUSED:  next_state = (start) ? RUN : PAUSED;
        default: next_state = IDLE;
    endcase
end

// Counter
always @(posedge clk or posedge reset) begin
    if(reset) begin
        sec <= 0;
        min <= 0;
    end
    else if(present_state == RUN && tick) begin
        if(sec == 59) begin
            sec <= 0;
            if(min == 59)
                min <= 0;
            else
                min <= min + 1;
        end
        else begin
            sec <= sec + 1;
        end
    end
end

endmodule
