`timescale 1ns / 1ps
module baud_rate (
    input  clk,
    input  rst,
    output tx_enb,
    output rx_enb
);

    parameter integer baud_rate  = 9600;
    parameter integer clock_freq = 100_000_000;
    parameter integer sampling   = 16;

    localparam integer tx_cyc = clock_freq / baud_rate;
    localparam integer rx_cyc = clock_freq / (baud_rate * sampling);

    reg [$clog2(tx_cyc)-1:0] count_tx;
    reg [$clog2(rx_cyc)-1:0] count_rx;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            count_tx <= 0;
            count_rx <= 0;
        end else begin
            if (count_tx == tx_cyc-1)
                count_tx <= 0;
            else
                count_tx <= count_tx + 1;

            if (count_rx == rx_cyc-1)
                count_rx <= 0;
            else
                count_rx <= count_rx + 1;
        end
    end

    assign tx_enb = (count_tx == 0);
    assign rx_enb = (count_rx == 0);

endmodule
