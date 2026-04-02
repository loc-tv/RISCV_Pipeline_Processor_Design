`timescale 1ns / 1ps

module tb();

    reg clk;
    reg rst;

    // Instantiate
    Pipeline_top dut (
        .clk(clk),
        .rst(rst)
    );

    // Clock 10ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset + load program
    initial begin
        rst = 0;

        // Load instruction memory
        $readmemh("memfile.hex", dut.Fetch.IMEM.mem);

        #20;
        rst = 1;

        $display("=== START SIMULATION ===");

        #2000;
        $finish;
    end

    // Monitor debug
    always @(posedge clk) begin
        if (rst) begin
            $display("%t | PC=%h | Instr=%h | RD=%0d | RS1=%0d | RS2=%0d",
                $time,
                dut.Fetch.PCD,          // PC trong Fetch
                dut.Fetch.InstrD,       // instruction
            );
        end
    end

    // Dump waveform
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
    end

endmodule