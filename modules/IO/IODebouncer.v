



module IODebouncer #(
    parameter PARAM_FREQ = 10000000 // Input frequency
) (
    input   wire i_clk, 
    input   wire in,
    output  reg out
);

    localparam lp_debounce_length_ms = 10; // Debounce length in ms
    localparam lp_debounce_cycles = (PARAM_FREQ / 1000) * lp_debounce_length_ms;

    reg [31:0] counter = 0;
    reg in_sync_0, in_sync_1, in_debounced;

    // Clock divider instance
    wire clk_slow;

    mCLKDividerV2 #(
        .PARAM_INPUT_FREQ(PARAM_FREQ),
        .PARAM_OUTPUT_FREQ(1000) // 1 kHz for debounce timing
    ) clk_divider (
        .clk_in(i_clk),
        .clk_out(clk_slow)
    );

    // Synchronize the input signal to the divided clock
    always @(posedge clk_slow) begin
        in_sync_0 <= in;
        in_sync_1 <= in_sync_0;
    end

    // Debounce logic
    always @(posedge clk_slow) begin
        if (in_sync_1 == in_debounced) begin
            counter <= 0;
        end else if (counter == lp_debounce_cycles) begin
            counter <= 0;
            in_debounced <= in_sync_1;
        end else begin
            counter <= counter + 1;
        end
    end

    // Assign the debounced signal to the output
    always @(posedge i_clk) begin
        out <= in_debounced;
    end

endmodule
