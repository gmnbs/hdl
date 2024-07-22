

module mBUSMux #(parameter PARAM_N = 4, parameter PARAM_BUS_WIDTH = 4) (
    input [$clog2(PARAM_N)-1:0] sel,           // Select input (log2(N) bits)
    input [PARAM_N*PARAM_BUS_WIDTH-1:0] in,          // Concatenated input buses
    output reg [PARAM_BUS_WIDTH-1:0] out       // Output bus
);

    always @(*) begin
        case (sel)
            default: out = in[(sel+1)*PARAM_BUS_WIDTH-1 -: PARAM_BUS_WIDTH];
        endcase
    end

endmodule