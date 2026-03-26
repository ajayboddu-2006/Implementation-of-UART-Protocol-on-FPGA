`timescale 1ns/1ps

module uart_tb;

    // Parameters
    parameter BAUD_RATE  = 9600;
    parameter CLOCK_FREQ = 100_000_000;
    parameter SAMPLING   = 16;

    // DUT signals
    reg clk;
    reg rst;
    reg wr_enb;
    reg [7:0] data_in;
    wire [7:0] data_out;

    // Instantiate DUT
    uart #(
        .BAUD_RATE(BAUD_RATE),
        .CLOCK_FREQ(CLOCK_FREQ),
        .SAMPLING(SAMPLING)
    ) dut (
        .clk(clk),
        .rst(rst),
        .wr_enb(wr_enb),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (100 MHz ? 10ns period)
    always #5 clk = ~clk;

    // ---------------- TASK: SEND BYTE ----------------
    task send_byte(input [7:0] data);
    begin
        @(posedge clk);
        data_in = data;
        wr_enb  = 1;

        // Hold wr_enb for few cycles (important)
        repeat (5) @(posedge clk);

        wr_enb = 0;
    end
    endtask

    // ---------------- TEST SEQUENCE ----------------
    initial begin
        // Initialize
        clk = 0;
        rst = 0;
        wr_enb = 0;
        data_in = 0;

        // Dump waveform
        $dumpfile("uart.vcd");
        $dumpvars(0, uart_tb);

        // Apply reset
        #50;
        rst = 1;

        // Wait after reset
        #100;

        // -------- TEST 1 --------
        send_byte(8'hA5);
        wait_for_rx(8'hA5);

        // -------- TEST 2 --------
        send_byte(8'h3C);
        wait_for_rx(8'h3C);

        // -------- TEST 3 --------
        send_byte(8'hF0);
        wait_for_rx(8'hF0);

        // Finish
        #100000;
        $display("All tests completed!");
        $finish;
    end

    // ---------------- TASK: WAIT & CHECK ----------------
    task wait_for_rx(input [7:0] expected);
    begin
        // Wait enough time for full UART frame (~1ms)
        #(1200000);  // 1.2 ms safe margin

        if (data_out == expected)
            $display("PASS: Expected = %h, Received = %h at time %0t", expected, data_out, $time);
        else
            $display("FAIL: Expected = %h, Received = %h at time %0t", expected, data_out, $time);
    end
    endtask

endmodule