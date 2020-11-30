module test;
    // input to be bound
    reg rin1, rin2, rin3, rin4, rin5;
    reg [3:0] rin6;
    // output to be bound
    wire rout1;
    wire [3:0] rout2;
    // memory to read look up table and configuration
    reg [31:0] read [2:0];
    // clock reg
    reg clk;

    // generate clock signal
    initial clk = 0;
    always #10 clk = ~clk;

    // bind input output to modules
    logic_tile inst_logic_tile(.out(rout1), .clock(clk), .in1(rin1), .in2(rin2), .in3(rin3), .in4(rin4), .in5(rin5));
    switch_box_4x4 inst_switch_box_4x4(.out(rout2), .in(rin6));

    // read up lookup table and configuration from file : lut.mem
    initial $readmemh("lut.mem", read);

    // store lookup table and configuration data in the module
    initial begin
        inst_logic_tile.mem[31:0] <= read[0];
        inst_logic_tile.mem[32] <= read[1][0];
        inst_switch_box_4x4.configure <= read[2][15:0];
    end

    // temporary check for whether the things have been initialized properly
    initial
    begin
        #10
        $display("%x", read[0]);
        $display("%x", read[2]);
    end

    // checking for different test cases
    integer i;
    initial
        begin
            {rin1, rin2, rin3, rin4, rin5} = 5'b00000;
            rin6 = 4'b1010;
            #10
            $display("in5 in4 in3 in2 in1   in     out1  out");
            $display(" %b   %b   %b   %b   %b   %b  =>  %b  %b",rin5,rin4,rin3,rin2,rin1,rin6,rout1, rout2);
            {rin1, rin2, rin3, rin4, rin5} = 5'b00001;
            rin6 = 4'b0000; 
             #10
            $display(" %b   %b   %b   %b   %b   %b  =>  %b  %b",rin5,rin4,rin3,rin2,rin1,rin6,rout1, rout2);
            {rin1, rin2, rin3, rin4, rin5} = 5'b11111;
            rin6 = 4'b1111; 
             #10
            $display(" %b   %b   %b   %b   %b   %b  =>  %b  %b",rin5,rin4,rin3,rin2,rin1,rin6,rout1, rout2);
            {rin1, rin2, rin3, rin4, rin5} = 5'b10101;
            rin6 = 4'b1001; 
             #10
            $display(" %b   %b   %b   %b   %b   %b  =>  %b  %b",rin5,rin4,rin3,rin2,rin1,rin6,rout1, rout2);
            {rin1, rin2, rin3, rin4, rin5} = 5'b00000;
            rin6 = 4'b1110; 
             #10
            $display(" %b   %b   %b   %b   %b   %b  =>  %b  %b",rin5,rin4,rin3,rin2,rin1,rin6,rout1, rout2);
        end

    // generate vcd file
    initial begin
        $dumpfile("l4.vcd");
        $dumpvars;
    end

    // declaring finish time as we used always block for generating clock signal
    initial
        #1000 $finish;
endmodule