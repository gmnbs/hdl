`timescale 1ns/1ns


`include "mBCDCounter.v"


module mBCDCounter_tb;

    parameter PARAM_DIGITS = 4;
    parameter PARAM_BASE = 10;

    reg clk;
    reg rst;
    wire [4*PARAM_DIGITS-1:0] data;

    // Instantiate the mBCDCounter module
    mBCDCounter #(
        .PARAM_DIGITS(PARAM_DIGITS),
        .PARAM_BASE(PARAM_BASE)
    ) uut (
        .clk(clk),
        .rst(rst),
        .data(data)
    );

    // Generate a clock signal with a period of 10 time units
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Apply test stimuli
    initial begin
        $display("Hello, World");
        $dumpfile("mBCDCounter_tb.vcd");
        $dumpvars(0, mBCDCounter_tb);


        // Apply reset
        rst = 1;
        #10; // Wait for some time
        
        // Release reset and start counting
        rst = 0;

        // Run the counter for enough time to observe several increments
        #300;

        #3; // unsync reset from clock

         // Apply reset
        rst = 1;
        #20; // Wait for some time
        
        // Release reset and start counting
        rst = 0;

        // Run the counter for enough time to observe several increments
        #5000;


        // Finish the simulation
        $finish;
    end

    // Monitor the output
    initial begin
        $monitor("Time: %0t | Reset: %b | Data: %h%h%h%h", $time, rst, 
                 data[15:12], data[11:8], data[7:4], data[3:0]);
    end

endmodule