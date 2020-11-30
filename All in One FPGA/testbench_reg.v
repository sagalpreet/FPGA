module test;

    // input to be bound
    reg [11:0] rin;
    reg clk;
    
    // output to be bound
    wire [8:0] wout;

    // register to store configuration
    reg [31:0] read[14:0];

    // generate clock signal
    initial clk = 0;
    always #10 clk = ~clk;

    // bind i/o ports
    add_multiplex_shift inst_add_multiplex_shift(.clock(clk), .in(rin), .out(wout));

    // read up lookup table from file : configure.mem
    initial $readmemh("configure_reg.mem", read);

    /*
    Structure of configuration file is as follows:

    Line 1: 32 bits for LUT of ADD0
    Line 2: 1 bit for Mux Control of ADD0

    Line 3: 32 bits for LUT of ADD1
    Line 4: 1 bit for Mux Control of ADD1

    Line 5: 32 bits for LUT of ADDC
    Line 6: 1 bit for Mux Control of ADDC

    Line 7: 32 bits for LUT of 2X1 MUX
    Line 8: 1 bit for Mux Control of MUX

    Line 9: 32 bits for LUT of MUXS
    Line 10: 1 bit for Mux Control of MUXS

    Line 11: 32 bits for LUT of REGC
    Line 12: 1 bit for Mux Control of REGC

    Line 13: 16 bits for configuration of SB0

    Line 14: 16 bits for configuration of SB1, SB2

    Line 15: 16 bits for configuration of SB3
    */

    // store lookup table and configuration data in the module
    initial begin
        inst_add_multiplex_shift.SB0.configure[15:0] <= read[12];
        inst_add_multiplex_shift.SB1.configure[15:0] <= read[13];
        inst_add_multiplex_shift.SB2.configure[15:0] <= read[13];
        inst_add_multiplex_shift.SB3.configure[15:0] <= read[14];

        inst_add_multiplex_shift.REGC_1.mem[31:0] <= read[10];
        inst_add_multiplex_shift.REGC_1.mem[32] <= read[11][0];
        inst_add_multiplex_shift.REGC_2.mem[31:0] <= read[10];
        inst_add_multiplex_shift.REGC_2.mem[32] <= read[11][0];

        inst_add_multiplex_shift.MUXS_R1.mem[31:0] <= read[8];
        inst_add_multiplex_shift.MUXS_R1.mem[32] <= read[9][0];
        inst_add_multiplex_shift.MUXS_R2.mem[31:0] <= read[8];
        inst_add_multiplex_shift.MUXS_R2.mem[32] <= read[9][0];
        inst_add_multiplex_shift.MUXS_R3.mem[31:0] <= read[8];
        inst_add_multiplex_shift.MUXS_R3.mem[32] <= read[9][0];
        inst_add_multiplex_shift.MUXS_R4.mem[31:0] <= read[8];
        inst_add_multiplex_shift.MUXS_R4.mem[32] <= read[9][0];
        inst_add_multiplex_shift.MUXS_R5.mem[31:0] <= read[8];
        inst_add_multiplex_shift.MUXS_R5.mem[32] <= read[9][0];
        inst_add_multiplex_shift.MUXS_R6.mem[31:0] <= read[8];
        inst_add_multiplex_shift.MUXS_R6.mem[32] <= read[9][0];
        inst_add_multiplex_shift.MUXS_R7.mem[31:0] <= read[8];
        inst_add_multiplex_shift.MUXS_R7.mem[32] <= read[9][0];
        inst_add_multiplex_shift.MUXS_R8.mem[31:0] <= read[8];
        inst_add_multiplex_shift.MUXS_R8.mem[32] <= read[9][0];

        inst_add_multiplex_shift.ADD0_1.mem[31:0] <= read[0];
        inst_add_multiplex_shift.ADD0_1.mem[32] <= read[1][0];
        inst_add_multiplex_shift.ADD0_2.mem[31:0] <= read[0];
        inst_add_multiplex_shift.ADD0_2.mem[32] <= read[1][0];
        
        inst_add_multiplex_shift.ADD1_1.mem[31:0] <= read[2];
        inst_add_multiplex_shift.ADD1_1.mem[32] <= read[3][0];
        inst_add_multiplex_shift.ADD1_2.mem[31:0] <= read[2];
        inst_add_multiplex_shift.ADD1_2.mem[32] <= read[3][0];

        inst_add_multiplex_shift.ADDC_1.mem[31:0] <= read[4];
        inst_add_multiplex_shift.ADDC_1.mem[32] <= read[5][0];
        inst_add_multiplex_shift.ADDC_2.mem[31:0] <= read[4];
        inst_add_multiplex_shift.ADDC_2.mem[32] <= read[5][0];

        inst_add_multiplex_shift.MUX_M1.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_M1.mem[32] <= read[7][0];
        inst_add_multiplex_shift.MUX_M2.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_M2.mem[32] <= read[7][0];
        inst_add_multiplex_shift.MUX_M3.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_M3.mem[32] <= read[7][0];
        inst_add_multiplex_shift.MUX_M4.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_M4.mem[32] <= read[7][0];
        inst_add_multiplex_shift.MUX_M5.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_M5.mem[32] <= read[7][0];
        inst_add_multiplex_shift.MUX_M6.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_M6.mem[32] <= read[7][0];
        inst_add_multiplex_shift.MUX_M7.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_M7.mem[32] <= read[7][0];

        inst_add_multiplex_shift.MUX_R1_1.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_R1_1.mem[32] <= read[7][0];
        inst_add_multiplex_shift.MUX_R2_1.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_R2_1.mem[32] <= read[7][0];
        inst_add_multiplex_shift.MUX_R3_1.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_R3_1.mem[32] <= read[7][0];
        inst_add_multiplex_shift.MUX_R4_1.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_R4_1.mem[32] <= read[7][0];
        inst_add_multiplex_shift.MUX_R5_1.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_R5_1.mem[32] <= read[7][0];
        inst_add_multiplex_shift.MUX_R6_1.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_R6_1.mem[32] <= read[7][0];
        inst_add_multiplex_shift.MUX_R7_1.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_R7_1.mem[32] <= read[7][0];
        inst_add_multiplex_shift.MUX_R8_1.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_R8_1.mem[32] <= read[7][0];
        inst_add_multiplex_shift.MUX_R1_2.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_R1_2.mem[32] <= read[7][0];
        inst_add_multiplex_shift.MUX_R2_2.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_R2_2.mem[32] <= read[7][0];
        inst_add_multiplex_shift.MUX_R3_2.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_R3_2.mem[32] <= read[7][0];
        inst_add_multiplex_shift.MUX_R4_2.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_R4_2.mem[32] <= read[7][0];
        inst_add_multiplex_shift.MUX_R5_2.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_R5_2.mem[32] <= read[7][0];
        inst_add_multiplex_shift.MUX_R6_2.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_R6_2.mem[32] <= read[7][0];
        inst_add_multiplex_shift.MUX_R7_2.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_R7_2.mem[32] <= read[7][0];
        inst_add_multiplex_shift.MUX_R8_2.mem[31:0] <= read[6];
        inst_add_multiplex_shift.MUX_R8_2.mem[32] <= read[7][0];
    end

    // running for different test cases
    // we have loaded shift register configuration in this testbench, so we give input
    // for shift register and expect output of shift register
    // fpga has 12 input pins, for shift register we use pins 0 to 11
    // pins [7:0] take parallel input for i_th bit
    // in[8] = shl, in[9] = sh, in[10] = L, in[11] = serial in
    // fpga has 9 outupt pins, for shift register we use pins out[8:0]
    // pins [7:0] represent the parallel out and pin[8] is serial out
    initial
        begin
            rin[7:0] = 8'b01000000;
            rin[8] = 1'b0;
            rin[9] = 1'b0;
            rin[10] = 1'b1;
            rin[11] = 1'b0;
            #10
            $display("shl  sh  l   s input   p input    p output    s output");
            $display(" %b   %b   %b       %b     %b   %b        %b", rin[8], rin[9], rin[10], rin[11], rin[7:0], wout[7:0], wout[8]);
            rin[7:0] = 8'b00000000;
            rin[8] = 1'b0;
            rin[9] = 1'b0;
            rin[10] = 1'b1;
            rin[11] = 1'b0;
            #10
            $display(" %b   %b   %b       %b     %b   %b        %b", rin[8], rin[9], rin[10], rin[11], rin[7:0], wout[7:0], wout[8]);
            rin[7:0] = 8'b00000000;
            rin[8] = 1'b1;
            rin[9] = 1'b0;
            rin[10] = 1'b0;
            rin[11] = 1'b0;
            #10
            $display(" %b   %b   %b       %b     %b   %b        %b", rin[8], rin[9], rin[10], rin[11], rin[7:0], wout[7:0], wout[8]);
            rin[7:0] = 8'b00000000;
            rin[8] = 1'b1;
            rin[9] = 1'b0;
            rin[10] = 1'b0;
            rin[11] = 1'b0;
            #10
            $display(" %b   %b   %b       %b     %b   %b        %b", rin[8], rin[9], rin[10], rin[11], rin[7:0], wout[7:0], wout[8]);
            rin[7:0] = 8'b00000000;
            rin[8] = 1'b0;
            rin[9] = 1'b1;
            rin[10] = 1'b0;
            rin[11] = 1'b1;
            #10
            $display(" %b   %b   %b       %b     %b   %b        %b", rin[8], rin[9], rin[10], rin[11], rin[7:0], wout[7:0], wout[8]);
            rin[7:0] = 8'b00000000;
            rin[8] = 1'b0;
            rin[9] = 1'b1;
            rin[10] = 1'b0;
            rin[11] = 1'b1;
            #10
            $display(" %b   %b   %b       %b     %b   %b        %b", rin[8], rin[9], rin[10], rin[11], rin[7:0], wout[7:0], wout[8]);
        end
    
    // generate vcd file
    initial begin
        $dumpfile("l6.vcd");
        $dumpvars;
    end

    // declaring finish time as we used always block for generating clock signal
    initial
        #1000 $finish;
endmodule