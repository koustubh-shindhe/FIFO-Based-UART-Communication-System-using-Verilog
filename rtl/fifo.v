module fifo(
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output full,
    output empty
);

// 8-bit wide, 16-depth memory
reg [7:0] mem [0:15];

// Write and read pointers
reg [4:0] wr_ptr;
reg [4:0] rd_ptr;

// FIFO is empty when both pointers are equal
assign empty = (wr_ptr == rd_ptr);

// FIFO is full when write pointer catches read pointer
assign full  = ((wr_ptr + 1'b1) == rd_ptr);

always @(posedge clk or posedge rst)
begin
    // Reset FIFO
    if (rst)
    begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        data_out <= 0;
    end
    else
    begin
        // Write operation
        if (wr_en && !full)
        begin
            mem[wr_ptr[3:0]] <= data_in;
            wr_ptr <= wr_ptr + 1;
        end

        // Read operation
        if (rd_en && !empty)
        begin
            data_out <= mem[rd_ptr[3:0]];
            rd_ptr <= rd_ptr + 1;
        end
    end
end

endmodule
