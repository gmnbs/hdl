


module Basys3_top_level (
    input           clk_100mhz, // 100MHz clock
    input [15:0]    sw,         // switches
    input [ 4:0]    btn,        // push buttons. MSB:LSB -> C,R,L,D,U

    output [ 7:0]   seg,        // 7-segment display. dp is the MSB
    output [ 3:0]   an,         // 4-digit multiplexed display
    output [15:0]   led         // LEDs
    );
    
endmodule