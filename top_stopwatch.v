module top_stopwatch(
    input clk,
    input reset,
    input start,
    input pause,
    output [6:0] seg,
    output [3:0] an,
    output dp
);

wire tick;
wire [5:0] sec, min;

// Debounced signals
wire start_db, pause_db;

// Clock divider
clock_divider cd(
    .clk(clk),
    .reset(reset),
    .tick(tick)
);

// Debounce
debounce db_start(
    .clk(clk),
    .reset(reset),
    .button(start),
    .pulse(start_db)
);

debounce db_pause(
    .clk(clk),
    .reset(reset),
    .button(pause),
    .pulse(pause_db)
);

// Stopwatch
stopwatch sw(
    .clk(clk),
    .reset(reset),
    .tick(tick),
    .start(start_db),
    .pause(pause_db),
    .sec(sec),
    .min(min)
);

// BCD conversion
wire [3:0] sec_ones = sec % 10;
wire [3:0] sec_tens = sec / 10;
wire [3:0] min_ones = min % 10;
wire [3:0] min_tens = min / 10;

wire [15:0] data = {min_tens, min_ones, sec_tens, sec_ones};

// Display driver
seven_seg_driver ssd(
    .clk(clk),
    .reset(reset),
    .data(data),
    .tick(tick),
    .seg(seg),
    .an(an),
    .dp(dp)
);
