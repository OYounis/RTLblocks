/*Crude testbench*/

`timescale 1ns/1ns
`define DISPLAY \
    $display("TIME: %t, Status code: %d, VALID: %b", $time, status_out_t, valid_t);

module huffman_decode_tb;
    reg clk_t;
    reg nrst_t;
    reg serial_in_t;

    wire [2:0] status_out_t;
    wire valid_t;
    
    huffman_decode DUT(
        .clk        (clk_t), 
        .nrst       (nrst_t),
        .serial_in  (serial_in_t),
        .status_out (status_out_t),
        .valid      (valid_t)
    );
    
    initial begin //reset block
        serial_in_t = 1;
        nrst_t = 1;
        #10
        nrst_t = 0;
        #10
        nrst_t = 1;
    end

    initial begin //clocking block
        $timeformat(-9, 0, "ns");
        
        clk_t = 0;
        forever #10 clk_t = ~clk_t;
    end

    always begin
        @(negedge clk_t) serial_in_t = 1;
        @(negedge clk_t) serial_in_t = 1; //3'b1
        @(posedge clk_t) `DISPLAY

        @(negedge clk_t) serial_in_t = 1;
        @(negedge clk_t) serial_in_t = 0; //3'b0
        @(posedge clk_t) `DISPLAY

        @(negedge clk_t) serial_in_t = 0;
        @(negedge clk_t) serial_in_t = 1;
        @(negedge clk_t) serial_in_t = 1; //3'b100
        @(posedge clk_t) `DISPLAY

        @(negedge clk_t) serial_in_t = 0;
        @(negedge clk_t) serial_in_t = 1;
        @(negedge clk_t) serial_in_t = 0; //3'b011
        @(posedge clk_t) `DISPLAY

        @(negedge clk_t) serial_in_t = 0;
        @(negedge clk_t) serial_in_t = 1;
        @(negedge clk_t) serial_in_t = 0; //3'b011
        @(posedge clk_t) `DISPLAY

        @(negedge clk_t) serial_in_t = 0;
        @(negedge clk_t) serial_in_t = 0;
        @(negedge clk_t) serial_in_t = 1; //3'b010
        @(posedge clk_t) `DISPLAY

        @(negedge clk_t) serial_in_t = 0;
        @(negedge clk_t) serial_in_t = 0;
        @(negedge clk_t) serial_in_t = 1; //3'b010
        @(posedge clk_t) `DISPLAY

        @(negedge clk_t) serial_in_t = 0;
        @(negedge clk_t) serial_in_t = 0;
        @(negedge clk_t) serial_in_t = 0;
        @(negedge clk_t) serial_in_t = 1; //3'b110
        @(posedge clk_t) `DISPLAY

        @(negedge clk_t) serial_in_t = 0;
        @(negedge clk_t) serial_in_t = 0;
        @(negedge clk_t) serial_in_t = 0;
        @(negedge clk_t) serial_in_t = 0; //3'b101
        @(posedge clk_t) `DISPLAY

        $stop;
    end
endmodule
