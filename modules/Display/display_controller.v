

module bcd2segments (
    input       [3:0] bcd,      // BCD input
    output reg  [6:0] segment   // 7-segment output
);

    always @(*) begin
        case(bcd)
            4'b0000: segment = 7'b1000000; // 0
            4'b0001: segment = 7'b1111001; // 1
            4'b0010: segment = 7'b0100100; // 2
            4'b0011: segment = 7'b0110000; // 3
            4'b0100: segment = 7'b0011001; // 4
            4'b0101: segment = 7'b0010010; // 5
            4'b0110: segment = 7'b0000010; // 6
            4'b0111: segment = 7'b1111000; // 7
            4'b1000: segment = 7'b0000000; // 8
            4'b1001: segment = 7'b0010000; // 9
            4'b1010: segment = 7'b0001000; // A
            4'b1011: segment = 7'b0000011; // B
            4'b1100: segment = 7'b1000110; // C
            4'b1101: segment = 7'b0100001; // D
            4'b1110: segment = 7'b0000110; // E
            4'b1111: segment = 7'b0001110; // F
            default: segment = 7'b1111111; // Error
        endcase
    end
    
endmodule

module display_controller #(
    parameter PARAM_DIGITS = 4,
    parameter PARAM_CLK_DIVIDER = 5000000
) (
    input i_clk,
    input [4*PARAM_DIGITS-1:0] data,            // Data input

    output [6:0] segment,                   // 7-segment display output
    output reg [PARAM_DIGITS-1:0] mux_select,   // Mux select output
    output  [15:0] led                       // LED output
);
    localparam LP_INDEX_WIDTH = $clog2(PARAM_DIGITS);

    // reg [23:0]                  r_counter       = 0;
    reg [LP_INDEX_WIDTH-1:0]    r_digit_index   = 0;


    assign led[1:0] = r_digit_index[1:0];
    assign led[5:2] = mux_select[3:0];

    wire clk_anode;

    mCLKDivider #(
        .PARAM_COUNT(PARAM_CLK_DIVIDER)
    ) clk_divider (
        .clk_in(i_clk),
        .clk_out(clk_anode)
    );


    initial begin
        // mux_select = {(PARAM_DIGITS-1){1'b1}, 1'b0}; // Initialize the mux_select reg
        // mux_select = (1 << (PARAM_DIGITS - 1)); // Initialize the mux_select reg to have the least significant bit as 0
        mux_select = 4'b1110;
    end


    always @(posedge clk_anode) begin
        mux_select <= {mux_select[PARAM_DIGITS-2:0], mux_select[PARAM_DIGITS-1]}; // Cycle the 0 through the bits

        r_digit_index <= r_digit_index + 1;
        if (r_digit_index == PARAM_DIGITS - 1) begin
            r_digit_index <= 0;
        end
    end

    wire [3:0] muxed_bcd_data;

    mBUSMux #(
        .PARAM_N(PARAM_DIGITS)
    ) bus_mux (
        .sel(r_digit_index),
        .in(data),
        .out(muxed_bcd_data)
    );

    bcd2segments bcd2seg(
        // .bcd(data[4*r_digit_index +: 4]),
        // .bcd(data[3:0]),
        .bcd(muxed_bcd_data),
        .segment(segment)
    );



endmodule
