`timescale 1ns / 1ps

module testbench();

    // Clock and reset signals
    reg clk;
    reg reset;

    reg [31:0] RAM[63:0];

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;

        // Apply reset
        #10 reset = 0;

        // Load the machine code into memory
        // This is a simplified example. In practice, you might need more detailed memory initialization.
        $readmemh("memory_init.txt", RAM);

        // Run the simulation for a certain period
        #500 $finish;
    end
endmodule

