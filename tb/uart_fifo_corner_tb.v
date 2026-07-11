`timescale 1ns/1ps

module uart_fifo_corner_tb;

// Testbench signals
reg clk;
reg rst;
reg wr_en;
reg [7:0] data_in;

wire tx;
wire full;
wire empty;

// Instantiate DUT (Device Under Test)
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

// Generate 50 MHz clock
always #10 clk = ~clk;

initial
begin
    // Initialize signals
    clk     = 0;
    rst     = 1;
    wr_en   = 0;
    data_in = 8'h00;

    $display("Running UART Corner Testbench");

    // TC1 : Reset Test
    #100;
    rst = 0;

    // TC2 : Single Data Write
    #50;
    wr_en = 1;
    data_in = 8'h55;
    #20;
    wr_en = 0;

    // TC3 : Multiple Data Writes
    #100;
    wr_en = 1;
    data_in = 8'hAA;
    #20;
    wr_en = 0;

    #100;
    wr_en = 1;
    data_in = 8'hF0;
    #20;
    wr_en = 0;

    // TC4 : Reset while UART is transmitting
    #500;
    rst = 1;
    #40;
    rst = 0;

    // TC5 : FIFO Overflow Attempt
    // Write more than the FIFO depth
    repeat (20)
    begin
        @(posedge clk);
        wr_en = 1;
        data_in = data_in + 1;
    end

    @(posedge clk);
    wr_en = 0;

    // Wait for transmission to complete
    #5000000;

    $finish;
end

// Display signal values in the console
initial
begin
    $monitor(
    "T=%0t rst=%b wr_en=%b data=%h full=%b empty=%b fifo_data=%h tx=%b",
    $time,
    rst,
    wr_en,
    data_in,
    full,
    empty,
    fifo_data,
    tx
    );
end

endmodule
