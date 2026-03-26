`timescale 1ns / 1ps
module tx_module(
    input       clk,
    input       rst,
    input       wr_enb,
    input       tx_enb,
    input [7:0] data_in,
    output reg     tx,
    output      busy
);

    // FSM states
    localparam idle  = 2'b00;
    localparam start = 2'b01;
    localparam data  = 2'b10;
    localparam stop  = 2'b11;

    reg [1:0] state;
    reg [2:0] count;
    reg [7:0] data_reg;

    assign busy = (state != idle);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state    <= idle;
            tx       <= 1'b1;   // idle high
            count    <= 3'd0;
            data_reg <= 8'd0;
        end else begin
            case (state)

                idle: begin
                    tx <= 1'b1;
                    if (wr_enb) begin
                        data_reg <= data_in;
                        count    <= 3'd0;
                        state    <= start;
                    end
                end

                start: begin
                    tx <= 1'b0;   // start bit immediately
                    if (tx_enb)
                        state <= data;
                end

                data: begin
                    tx <= data_reg[count];
                    if (tx_enb) begin
                        if (count == 3'd7)
                            state <= stop;
                        else
                            count <= count + 1;
                    end
                end

                stop: begin
                    tx <= 1'b1;
                    if (tx_enb)
                        state <= idle;
                end

                default: begin
                    state <= idle;
                    tx    <= 1'b1;
                end

            endcase
        end
    end
endmodule
