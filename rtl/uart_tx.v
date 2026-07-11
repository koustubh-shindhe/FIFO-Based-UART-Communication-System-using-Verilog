module uart_tx (
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,
    output reg tx,
    output reg tx_busy
);

// System clock and UART baud rate
parameter CLK_FREQ = 50000000;
parameter BAUD_RATE = 9600;

// Number of clock cycles required for one UART bit
localparam BAUD_TICK = CLK_FREQ / BAUD_RATE;

// Counters and shift register
reg [12:0] baud_cnt;
reg [3:0] bit_cnt;
reg [9:0] data_frame;

always @(posedge clk or posedge rst)
begin
    // Reset condition
    if (rst)
    begin
        tx <= 1'b1;                  // UART line is idle high
        tx_busy <= 1'b0;
        baud_cnt <= 0;
        bit_cnt <= 0;
        data_frame <= 10'b1111111111;
    end
    else
    begin
        // UART is idle
        if (!tx_busy)
        begin
            tx <= 1'b1;

            // Load data when transmission starts
            if (tx_start)
            begin
                tx_busy <= 1'b1;

                // Frame format:
                // {Stop Bit, Data[7:0], Start Bit}
                data_frame <= {1'b1, tx_data, 1'b0};

                baud_cnt <= 0;
                bit_cnt <= 0;
            end
        end
        else
        begin
            // Wait for one baud period
            if (baud_cnt == BAUD_TICK-1)
            begin
                baud_cnt <= 0;

                // Send one bit (LSB first)
                tx <= data_frame[0];

                // Shift to the next bit
                data_frame <= {1'b1, data_frame[9:1]};

                // Total bits = 10
                // 1 Start + 8 Data + 1 Stop
                if (bit_cnt == 9)
                begin
                    tx_busy <= 1'b0;
                    bit_cnt <= 0;
                    tx <= 1'b1;      // Return to idle
                end
                else
                    bit_cnt <= bit_cnt + 1;
            end
            else
                baud_cnt <= baud_cnt + 1;
        end
    end
end

endmodule
