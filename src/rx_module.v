`timescale 1ns/1ps
module rx_module (
    input  wire        clk,
    input  wire        rst,        // active-low reset
    input  wire        rx_enb,     // 16x baud enable
    input  wire        rx,         // serial input
    output reg  [7:0]  data_out
);

    // FSM states
    localparam idle  = 2'b00;
    localparam start = 2'b01;
    localparam data  = 2'b10;
    localparam stop  = 2'b11;

    reg [1:0] state;
    reg [3:0] sample_cnt;   // 0-15 (16 samples per bit)
    reg [2:0] bit_cnt;      // 0-7 (8 data bits)
    reg [7:0] shift_reg;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state      <= idle;
            sample_cnt <= 4'd0;
            bit_cnt    <= 3'd0;
            shift_reg  <= 8'd0;
            data_out   <= 8'd0;
        end else begin

            case (state)

                // ---------------- IDLE ----------------
                idle: begin
                    sample_cnt <= 4'd0;
                    bit_cnt    <= 3'd0;
                    if (rx == 1'b0)        // detect start bit
                        state <= start;
                end

                // ---------------- START ----------------
                start: begin
                    if (rx_enb) begin
                        if (sample_cnt == 4'd7) begin
                            if (rx == 1'b0) begin
                                // VALID start bit
                                sample_cnt <= 0;
                                bit_cnt    <= 0;
                                state      <= data;
                            end else begin
                                // FALSE start bit ? abort
                                state      <= idle;
                                sample_cnt <= 0;
                            end
                        end else begin
                            sample_cnt <= sample_cnt + 1;
                        end
                    end
                end

                // ---------------- DATA ----------------
                data: begin
                    if (rx_enb) begin
                        if (sample_cnt == 4'd15) begin
                            sample_cnt <= 4'd0;
                            shift_reg  <= {rx, shift_reg[7:1]}; // LSB first

                            if (bit_cnt == 3'd7)
                                state <= stop;
                            else
                                bit_cnt <= bit_cnt + 1;
                        end else
                            sample_cnt <= sample_cnt + 1;
                    end
                end

                // ---------------- STOP ----------------
                stop: begin
                    if (rx_enb) begin
                        if (sample_cnt == 4'd15) begin
                            data_out   <= shift_reg;
                            state      <= idle;
                            sample_cnt <= 4'd0;
                        end else
                            sample_cnt <= sample_cnt + 1;
                    end
                end

                default: state <= idle;
            endcase
        end
    end
endmodule
