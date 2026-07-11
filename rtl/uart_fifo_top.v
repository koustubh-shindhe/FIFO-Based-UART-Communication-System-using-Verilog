module uart_fifo_top(
    input clk,
    input rst,
    input wr_en,
    input [7:0] data_in,
    output tx,
    output full,
    output empty
);

// Data coming from FIFO to UART
wire [7:0] fifo_data;

// Control signals
wire rd_en;
wire tx_start;
wire tx_busy;

// Read data from FIFO only when:
// 1. FIFO is not empty
// 2. UART is not busy transmitting
assign rd_en    = (!empty && !tx_busy);
assign tx_start = (!empty && !tx_busy);

// FIFO Instance
fifo fifo_inst(
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .data_in(data_in),
    .data_out(fifo_data),
    .full(full),
    .empty(empty)
);

// UART Transmitter Instance
uart_tx uart_tx_inst(
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(fifo_data),
    .tx(tx),
    .tx_busy(tx_busy)
);

endmodule
