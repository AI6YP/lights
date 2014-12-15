module t1 (clk, led);

input clk /* synthesis chip_pin = "R8" */;
output logic led /* synthesis chip_pin = "B5" */ ; // JP1.10 GPIO_07

logic [31:0] run;
logic tick; // run bit

always_ff @(posedge clk)
    run <= run + 1;

logic [23:0] mem [0:49];
logic [23:0] data;
logic dat;

logic [4:0] ptr0; // bit pointer
logic [5:0] ptr1, ptr2; // word pointer

initial begin
    $readmemh("ram.txt", mem);
end

always_ff @(posedge clk)
    if (~run[17])
        ptr0 <= 23;
    else
        if (tick) begin
            if (ptr0 == 0) ptr0 <= 23;
            else           ptr0 <= ptr0 - 'b1;
        end

always_ff @(posedge clk)
    if (~run[17])
        ptr1 <= 0;
    else
        if (tick) begin
            if (ptr0 == 0) begin
                if (ptr1 > 48) ptr1 <= 0;
                else           ptr1 <= ptr1 + 'b1;
            end
        end

always_comb ptr2 = (ptr1 + run[31:23]) % 48;
always_comb data = mem[ptr2];
always_comb dat = data[ptr0];

logic [15:0] timer0, nxt_timer0;

always_ff @(posedge clk) timer0 <= nxt_timer0;

logic timer0_zero;

always_comb timer0_zero = ~|timer0;

logic state, nxt_state;

always_ff @(posedge clk) state <= nxt_state;

always_comb begin
    nxt_state = state;
    tick = 1'b0;
    nxt_timer0 = (timer0 - 1);
    if (run[17])
        if (~state) begin
            if (timer0_zero) begin
                nxt_state = ~state;
                if (dat) nxt_timer0 = 34;
                else     nxt_timer0 = 17;
            end
        end else begin
            if (timer0_zero) begin
                tick = 1'b1;
                nxt_state = ~state;
                if (dat) nxt_timer0 = 29;
                else     nxt_timer0 = 39;
            end
        end
    else begin
        nxt_state = 1'b0;
        nxt_timer0 = 2499; // 100us reset
    end
end

assign led = state & run[17];

endmodule
