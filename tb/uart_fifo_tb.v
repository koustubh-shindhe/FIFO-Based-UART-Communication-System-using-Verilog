`timescale 1ns/1ps

module uart_fifo_tb;

// Testbench signals
reg clk;
reg rst;
reg wr_en;
reg [7:0] data_in;

wire tx;
wire full;
wire empty;

// Instantiate the DUT (Device Under Test)
uart_fifo_top dut (
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .data_in(data_in),
    .tx(tx),
    .full(full),
    .empty(empty)
);

// Internal signal for observing FIFO output
wire [7:0] fifo_data;
assign fifo_data = dut.fifo_data;

// Generate 50 MHz clock (20 ns period)
always #10 clk = ~clk;

initial begin
    // Initialize signals
    clk = 0;
    rst = 1;
    wr_en = 0;
    data_in = 8'h00;

    // Apply reset
    #100;
    rst = 0;

    // Write first byte into FIFO
    #50;
    wr_en = 1;
    data_in = 8'h55;
    #20;
    wr_en = 0;

    // Write second byte into FIFO
    #200;
    wr_en = 1;
    data_in = 8'hAA;
    #20;
    wr_en = 0;

    // Write third byte into FIFO
    #200;
    wr_en = 1;
    data_in = 8'hF0;
    #20;
    wr_en = 0;

    // Wait for all data to be transmitted
    #5000000;

    $finish;
end

endmodule
