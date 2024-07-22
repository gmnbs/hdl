



module mDecoder #(
    parameter PARAM_N = 4
) (
    input [PARAM_N-1:0] in,
    output [2**PARAM_N-1:0] out
);



    assign out = 1 << in;




    
endmodule