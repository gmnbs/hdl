
module mCLKDivider #(
    parameter PARAM_COUNT = 50000000 
    ) (
    input clk_in,
    output reg clk_out
    );
    
    reg [25:0] counter;

    always @(posedge clk_in) begin
        counter <= counter + 1;
        if (counter == PARAM_COUNT) begin
            counter <= 0;
            clk_out <= ~clk_out;
        end
    end

endmodule



module mCLKDividerV2 #(
    parameter PARAM_INPUT_FREQ = 100000000, // Input frequency in Hz
    parameter PARAM_OUTPUT_FREQ = 10000000  // Desired output frequency in Hz
) (
    input   wire    clk_in,     // input clock
    output  reg     clk_out     // output clock
);
    // Ensure the output frequency is less than the input frequency
    initial begin
        if (PARAM_OUTPUT_FREQ >= PARAM_INPUT_FREQ) begin
            $error("Output frequency must be less than input frequency");
        end
    end

    // Calculate the divider value (number of input clock cycles per output clock cycle)
    localparam lp_divider = PARAM_INPUT_FREQ / PARAM_OUTPUT_FREQ;
    // Calculate the width of the counter based on the divider value
    localparam lp_counter_width = $clog2(lp_divider);

    // Counter register with width based on the calculated counter width
    reg [lp_counter_width-1:0] counter;

    // Initialize counter and output clock
    initial begin
        counter = 0;
        clk_out = 0;
    end

    always @(posedge clk_in) begin
        if (counter == (lp_divider / 2) - 1) begin
            counter <= 0;
            clk_out <= ~clk_out;
        end else begin
            counter <= counter + 1;
        end
    end

endmodule