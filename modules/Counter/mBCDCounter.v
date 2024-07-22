




module mLSDBCDCounter #(
    parameter PARAM_BASE = 10
)(
    input   clk,
    input   rst,
    output  carry,
    output [3:0] data
);

    reg [3:0]   r_data;
    reg         r_carry;

    assign data     = r_data;
    assign carry    = r_carry;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            r_data <= 4'h0;
            r_carry <= 1'b0;
        end else begin
            if (r_data == (PARAM_BASE-1)) begin
                r_data <= 4'h0;
                r_carry <= 1'b1;
            end else begin
                r_data <= r_data + 1;
                r_carry <= 1'b0;
            end
        end
    end
endmodule

module mLSDBCDCounterCE #(
    parameter PARAM_BASE = 10
)(
    input   clk,
    input   rst,
    input   ce,
    output  carry,
    output [3:0] data
);

    reg [3:0]   r_data;
    reg         r_carry;

    assign data     = r_data;
    assign carry    = r_carry;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            r_data <= 4'h0;
            r_carry <= 1'b0;
        end else begin
            if (ce) begin
                if (r_data == (PARAM_BASE-1)) begin
                    r_data <= 4'h0;
                    r_carry <= 1'b1;
                end else begin
                    r_data <= r_data + 1;
                    r_carry <= 1'b0;
                end
            end
        end
    end
endmodule

// BCD Counter implemented internally using the single digit BCD counter
module mBCDCounterModular #(
    parameter PARAM_DIGITS = 4,
    parameter PARAM_BASE = 10
) (
    input clk,
    input rst,
    output [4*PARAM_DIGITS-1:0] data
);

    wire [PARAM_DIGITS:0] r_carry;

    assign r_carry[0] = clk;

    genvar i;
    generate
        for (i = 0; i < PARAM_DIGITS; i = i + 1) begin : gen_digits
            mLSDBCDCounter #(
                .PARAM_BASE(PARAM_BASE)
            ) u_digit (
                .clk(r_carry[i]),
                .rst(rst),
                .carry(r_carry[i+1]),
                .data(data[4*i +: 4])
            );
        end
    endgenerate
    
endmodule


module mBCDCounterModularSynchronous #(
    parameter PARAM_DIGITS = 4,
    parameter PARAM_BASE = 10
) (
    input clk,
    input rst,
    input ce,
    output [4*PARAM_DIGITS-1:0] data
);

    wire [PARAM_DIGITS:0] ce_chain;

    genvar i;
    generate
        for (i = 0; i < PARAM_DIGITS; i = i + 1) begin : gen_digits
            mLSDBCDCounterCE #(
                .PARAM_BASE(PARAM_BASE)
            ) u_digit (
                .clk(clk),
                .rst(rst),
                .ce(i>0 ? ce_chain[i] : 1'b1),
                .carry(ce_chain[i+1]),
                .data(data[4*i +: 4])
            );
        end
    endgenerate

endmodule



// module mBCDCounter #(
//     parameter PARAM_DIGITS = 4,
//     parameter PARAM_BASE = 10
// ) (
//     input clk,
//     input rst,
//     output [4*PARAM_DIGITS-1:0] data
// );

//     reg [3:0] r_data [PARAM_DIGITS-1:0];
//     integer i; // Declare loop variable outside of always block

//     // Generate block to concatenate the array into a single output vector
//     genvar j;
//     generate
//         for (j = 0; j < PARAM_DIGITS; j = j + 1) begin : gen_data
//             assign data[4*j +: 4] = r_data[j];
//         end
//     endgenerate

//     always @(posedge clk or posedge rst) begin
//         if (rst) begin
//             // Reset all digits to 0
//             for (i = 0; i < PARAM_DIGITS; i = i + 1) begin
//                 r_data[i] <= 4'h0;
//             end
//         end else begin

//             r_data[0] <= r_data[0] + 1;

//             // Handle carry propagation
//             for (i = 0; i < PARAM_DIGITS; i = i + 1) begin
//                 if (r_data[i] == (PARAM_BASE-1) ) begin
//                     r_data[i] <= 4'h0; // Blocking assignment to reset current digit
//                     r_data[i+1] <= r_data[i+1] + 1; // Blocking assignment to increment next digit
//                 end
//             end

//             // Check the most significant digit separately
//             if (r_data[PARAM_DIGITS-1] == (PARAM_BASE-1)) begin
//                 r_data[PARAM_DIGITS-1] <= 4'h0; // Blocking assignment to reset most significant digit
//             end
//         end
//     end

//     // always @(posedge clk or posedge rst) begin
//     //     if (rst) begin
//     //         // Reset all digits to 0
//     //         for (i = 0; i < PARAM_DIGITS; i = i + 1) begin
//     //             r_data[i] <= 4'h0;
//     //         end
//     //     end else begin
//     //         // Handle carry propagation
//     //         if (r_data[0] == (PARAM_BASE - 1)) begin
//     //             r_data[0] <= 4'h0;
//     //             r_data[1] <= r_data[1] + 1;
//     //         end else begin
//     //             r_data[0] <= r_data[0] + 1;
//     //         end

//     //         for (i = 1; i < PARAM_DIGITS-1; i = i + 1) begin
//     //             if (r_data[i] == PARAM_BASE) begin
//     //                 r_data[i] <= 4'h0;
//     //                 r_data[i+1] <= r_data[i+1] + 1;
//     //             end
//     //         end

//     //         // Check the most significant digit separately
//     //         if (r_data[PARAM_DIGITS-1] == PARAM_BASE) begin
//     //             r_data[PARAM_DIGITS-1] <= 4'h0;
//     //         end
//     //     end
//     // end

// endmodule