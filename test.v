// Hello World Program in Verilog
module hello_world;

    // Initial block to start execution
    initial begin
        // Display "Hello, World!" to the console
        $display("Hello, World!");
        // End the simulation
        $finish;
    end

endmodule