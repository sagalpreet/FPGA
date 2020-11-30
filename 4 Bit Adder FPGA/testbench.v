module test;
    
    // input to be bound
    reg [3:0] rin1, rin2;
    reg clk, rcin;
    
    // output to be bound
    wire wcout;
    wire [3:0] wout;

    // register to store configuration
    reg [31:0] read [5:0];
    
    // generate clock signal although not required for combinational circuit (adder in this case)
    initial clk = 0;
    always #10 clk = ~clk;
    
    // bind i/o ports
    adder_4_bit inst_adder_4_bit(.clock(clk), .in1(rin1), .in2(rin2), .cin(rcin), .out(wout), .cout(wcout));
    
    // read up lookup table from file : configure.mem
    initial $readmemh("configure.mem", read);
    
    // store lookup table and configuration data in the module
    initial begin
        inst_adder_4_bit.LT00.mem[31:0] <= read[0];
        inst_adder_4_bit.LT00.mem[32] <= read[1][0];

        inst_adder_4_bit.LT01.mem[31:0] <= read[0];
        inst_adder_4_bit.LT01.mem[32] <= read[1][0];

        inst_adder_4_bit.LT10.mem[31:0] <= read[2];
        inst_adder_4_bit.LT10.mem[32] <= read[3][0];

        inst_adder_4_bit.LT11.mem[31:0] <= read[2];
        inst_adder_4_bit.LT11.mem[32] <= read[3][0];

        inst_adder_4_bit.LT20.mem[31:0] <= read[4];
        inst_adder_4_bit.LT20.mem[32] <= read[5][0];

        inst_adder_4_bit.LT21.mem[31:0] <= read[4];
        inst_adder_4_bit.LT21.mem[32] <= read[5][0];
    end

    // checking for different test cases
    integer i;
    initial
        begin
            rin1 = 4'b0000;
            rin2 = 4'b0000;
            rcin = 1'b0;
            #10
            $display(" in1    in2   cin     out  cout");
            $display(" %b   %b   %b  =>  %b  %b", rin1, rin2, rcin, wout, wcout);
            rin1 = 4'b0001;
            rin2 = 4'b0000;
            rcin = 1'b1;
            #10
            $display(" %b   %b   %b  =>  %b  %b", rin1, rin2, rcin, wout, wcout);
            rin1 = 4'b1111;
            rin2 = 4'b1000;
            rcin = 1'b0;
            #10
            $display(" %b   %b   %b  =>  %b  %b", rin1, rin2, rcin, wout, wcout);
            rin1 = 4'b1111;
            rin2 = 4'b1111;
            rcin = 1'b1;
            #10
            $display(" %b   %b   %b  =>  %b  %b", rin1, rin2, rcin, wout, wcout); 
            rin1 = 4'b1111;
            rin2 = 4'b1111;
            rcin = 1'b0;
            #10
            $display(" %b   %b   %b  =>  %b  %b", rin1, rin2, rcin, wout, wcout); 
            rin1 = 4'b1010;
            rin2 = 4'b0101;
            rcin = 1'b0;
            #10
            $display(" %b   %b   %b  =>  %b  %b", rin1, rin2, rcin, wout, wcout);  
            rin1 = 4'b1010;
            rin2 = 4'b0101;
            rcin = 1'b1;
            #10
            $display(" %b   %b   %b  =>  %b  %b", rin1, rin2, rcin, wout, wcout);  
        end

    // generate vcd file
    initial begin
        $dumpfile("l5.vcd");
        $dumpvars;
    end

    // declaring finish time as we used always block for generating clock signal
    initial
        #1000 $finish;
endmodule