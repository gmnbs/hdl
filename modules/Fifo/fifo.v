


module MFifo #(
    P_WIDTH = 8,                            // Width of data bus
    P_DEPTH = 16                            // Depth of FIFO
) (
    input wire                  w_clk,      // Write clock
    input wire                  w_en,       // Write enable
    input wire [P_WIDTH-1:0]    w_data,     // Write data

    input wire                  r_clk,      // Read clock
    input wire                  r_en,       // Read enable
    output wire [P_WIDTH-1:0]   r_data,     // Read data

    input wire rst,                         // Reset

    output wire full,                       // Full flag
    output wire empty                       // Empty flag
);

    localparam index_width = $clog2(P_DEPTH);         // Width of index

    reg [index_width-1:0] _w_index = 0;               // Write index
    reg [index_width-1:0] _r_index = 0;               // Read index

    reg [P_WIDTH-1:0] _data [P_DEPTH-1:0];           // Internal data storage for FIFO

    always @(posedge w_clk) begin
        if (w_en) begin
            

        end
        
    end

endmodule

