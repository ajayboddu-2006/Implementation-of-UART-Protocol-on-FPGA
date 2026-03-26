`timescale 1ns/1ps
module uart #(
    parameter integer BAUD_RATE  = 9600,
    parameter integer CLOCK_FREQ = 100_000_000,
    parameter integer SAMPLING   = 16
)(
    input  wire       clk,
    input  wire       rst,        // active-low reset (matches your negedge rst style)
    input  wire       rx,
//    // TX interface
    input  wire       wr_enb,      // pulse to request transmit
    input  wire [7:0] data_in,     // byte to send
    output wire [7:0] data_out,
    output wire       tx
);
    wire busy;
    // enables from baud generator
    wire tx_enb;   // 1x baud enable (TX bit timing)
    wire rx_enb;   // 16x baud enable (RX oversampling)
    // ---------------- Baud generator ----------------
    baud_rate #(
        .baud_rate (BAUD_RATE),
        .clock_freq(CLOCK_FREQ),
        .sampling  (SAMPLING)
    ) u_baud (
        .clk   (clk),
        .rst   (rst),     // IMPORTANT: baud gen should have reset
        .tx_enb(tx_enb),
        .rx_enb(rx_enb)
    );

//     ---------------- Transmitter ----------------
    tx_module u_tx (
        .clk     (clk),
        .rst     (rst),
        .wr_enb  (wr_enb),
        .tx_enb  (tx_enb),
        .data_in (data_in),
        .tx      (tx),
        .busy    (busy)
    );

    // ---------------- Receiver ----------------
    rx_module u_rx (
        .clk      (clk),
        .rst      (rst),
        .rx_enb   (rx_enb),
        .rx       (rx),
        .data_out (data_out)
    );

endmodule
