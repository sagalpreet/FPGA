module logic_tile(out, clock, in1, in2, in3, in4, in5);
    // declaring input output
    input clock, in1, in2, in3, in4, in5;
    output out;
    // declaring memory to store lookup table
    reg [32:0] mem;
    // declaring memory to store intermediate value. used reg istead of wire because it has been used in flip-flop that way.
    // reg d;
    wire d;
    // declaring flip flop
    reg q, qbar;
    always@(posedge clock)
        begin
            q <= d;
            qbar = !d;
        end
    // getting output of LUT through behavioral modelling using blocking assignment i.e combinational design. It can be realized using the rom model with the help of a multiplexer. 
    integer x;
    initial x = {in5, in4, in3, in2, in1};
    assign d = mem[x];

    always@(in5, in4, in3, in2, in1)
        begin
            case(in1)
                1'b1: x[0] = 1'b1;
                default x[0] = 1'b0;
            endcase
            case(in2)
                1'b1: x[1] = 1'b1;
                default x[1] = 1'b0;
            endcase
            case(in3)
                1'b1: x[2] = 1'b1;
                default x[2] = 1'b0;
            endcase
            case(in4)
                1'b1: x[3] = 1'b1;
                default x[3] = 1'b0;
            endcase
            case(in5)
                1'b1: x[4] = 1'b1;
                default x[4] = 1'b0;
            endcase
        end

    // depending upon the mux control value, output has been given as ff output for mux control 1 and combinational output for mux control 0.
    assign out = (mem[32] & q) | ((~mem[32]) & d);
endmodule

module switch_box_4x4(out, in);
    // input output declaration
    input [3:0] in;
    output [3:0] out;
    // declaring memory to store configuration of the switch_box_4x4
    reg [15:0] configure;
    // assigning output using simple combinational logic on the basis of configuration
    assign out[0] = (configure[0] & in[0]) | (configure[1] & in[1]) | (configure[2] & in[2]) | (configure[3] & in[3]);
    assign out[1] = (configure[4] & in[0]) | (configure[5] & in[1]) | (configure[6] & in[2]) | (configure[7] & in[3]);
    assign out[2] = (configure[8] & in[0]) | (configure[9] & in[1]) | (configure[10] & in[2]) | (configure[11] & in[3]);
    assign out[3] = (configure[12] & in[0]) | (configure[13] & in[1]) | (configure[14] & in[2]) | (configure[15] & in[3]);
endmodule

module add_multiplex_shift(clock, in, out);
    /*
    The implementation of add_multiplex_shift module requires 6 different types of logic tiles and 38 logic tiles in total
    By using 11 different types of logic tiles it is possible to speed up multiplexer and reduce cost to 36 logic tiles in total
    I chose first one because the aim of the FPGA fabrication as told by sir in example video is to reuse logic tiles as much as possible
    5 switch boxes are required in both cases
    */
    
    // input output declaration
    input clock;
    input [11:0] in;
    output [8:0] out;
    // wire declaration for final output through switchbox
    // all three compete for out[0]
    // only adder and shift register compete for out[7:1]
    // out[8] can be assigned shift register
    // we need to define output wires for multiplexer and adder only
    // shift register has output wires as a part of its design
    wire m0, a0, a1, a2, a3, a4;

    // multiplexer construction begins
    // multiplexer accepts inputs from in[10:0] and gives output to out[0]
    // out[0] is the output
    // in[10:8] are the control bits and in[7:0] are the inputs to multiplexer
    // we use a single type of logic tiles to implement entire multiplexer

    // declaring wires to be used in the circuit in intermediate parts
    wire w_muxm1, w_muxm2, w_muxm3, w_muxm4, w_muxm5, w_muxm6;
    // combinational circuit design using structural statements
    logic_tile MUX_M1(w_muxm1, clock, in[8], in[0], in[1], 1'b0, 1'b0);
    logic_tile MUX_M2(w_muxm2, clock, in[8], in[2], in[3], 1'b0, 1'b0);
    logic_tile MUX_M3(w_muxm3, clock, in[8], in[4], in[5], 1'b0, 1'b0);
    logic_tile MUX_M4(w_muxm4, clock, in[8], in[6], in[7], 1'b0, 1'b0);
    logic_tile MUX_M5(w_muxm5, clock, in[9], w_muxm1, w_muxm2, 1'b0, 1'b0);
    logic_tile MUX_M6(w_muxm6, clock, in[9], w_muxm3, w_muxm4, 1'b0, 1'b0);
    logic_tile MUX_M7(m0, clock, in[10], w_muxm5, w_muxm6, 1'b0, 1'b0);

    // adder construction begins
    // adder accepts input from in[8:0] and gives output to out[4:0]
    // in[3:0] are input bits of first 4 bit number, in[7:4] of second number and in[8] is cin
    // out[3:0] represents the output number and out[4] is cout
    // we use 3 different types of logic tiles to implement adder

    // declaring wires to be used in the circuit in intermediate parts
    wire w_addc1;
    // combinational circuit design using structural statements
    logic_tile ADD0_1(a0, clock, in[0], in[1], in[4], in[5], in[8]);
    logic_tile ADD1_1(a1, clock, in[0], in[1], in[4], in[5], in[8]);
    logic_tile ADDC_1(w_addc1, clock, in[0], in[1], in[4], in[5], in[8]);
    logic_tile ADD0_2(a2, clock, in[2], in[3], in[6], in[7], w_addc1);
    logic_tile ADD1_2(a3, clock, in[2], in[3], in[6], in[7], w_addc1);
    logic_tile ADDC_2(a4, clock, in[2], in[3], in[6], in[7], w_addc1);

    // shift register construction begins
    // shift register accepts inputs from in[11:0] and gives output to out[8:0]
    // for 0 to 7 in[i] = load for i_th bit, in[8] = shl, in[9] = sh, in[10] = L, in[11] = serial in
    // out[7:0] are parallel outs for i_th bit, out[8] is serial out
    // we use 3 different types of logic tiles to implement shift register

    // declaring wires to be used in the circuit in intermediate parts
    wire regc1, regc2;
    wire [2:0] muxr1, muxr2, muxr3, muxr4, muxr5, muxr6, muxr7, muxr8;
    // combinational circuit design using structural statements
    logic_tile REGC_1(regc1, clock, in[8], in[9], in[10], 1'b0, 1'b0);
    logic_tile REGC_2(regc2, clock, in[9], in[8], in[10], 1'b0, 1'b0);

    logic_tile MUX_R1_1(muxr1[1], clock, regc1, muxr1[0], muxr2[0], 1'b0, 1'b0);
    logic_tile MUX_R2_1(muxr2[1], clock, regc1, muxr2[0], muxr3[0], 1'b0, 1'b0);
    logic_tile MUX_R3_1(muxr3[1], clock, regc1, muxr3[0], muxr4[0], 1'b0, 1'b0);
    logic_tile MUX_R4_1(muxr4[1], clock, regc1, muxr4[0], muxr5[0], 1'b0, 1'b0);
    logic_tile MUX_R5_1(muxr5[1], clock, regc1, muxr5[0], muxr6[0], 1'b0, 1'b0);
    logic_tile MUX_R6_1(muxr6[1], clock, regc1, muxr6[0], muxr7[0], 1'b0, 1'b0);
    logic_tile MUX_R7_1(muxr7[1], clock, regc1, muxr7[0], muxr8[0], 1'b0, 1'b0);
    logic_tile MUX_R8_1(muxr8[1], clock, regc1, muxr8[0], 1'b0, 1'b0, 1'b0);

    logic_tile MUX_R1_2(muxr1[2], clock, regc1, in[11], in[7], 1'b0, 1'b0);
    logic_tile MUX_R2_2(muxr2[2], clock, regc1, muxr1[0], in[6], 1'b0, 1'b0);
    logic_tile MUX_R3_2(muxr3[2], clock, regc1, muxr2[0], in[5], 1'b0, 1'b0);
    logic_tile MUX_R4_2(muxr4[2], clock, regc1, muxr3[0], in[4], 1'b0, 1'b0);
    logic_tile MUX_R5_2(muxr5[2], clock, regc1, muxr4[0], in[3], 1'b0, 1'b0);
    logic_tile MUX_R6_2(muxr6[2], clock, regc1, muxr5[0], in[2], 1'b0, 1'b0);
    logic_tile MUX_R7_2(muxr7[2], clock, regc1, muxr6[0], in[1], 1'b0, 1'b0);
    logic_tile MUX_R8_2(muxr8[2], clock, regc1, muxr7[0], in[0], 1'b0, 1'b0);
    // sequential circuit design using structural elements
    logic_tile MUXS_R1(muxr1[0], clock, regc2, muxr1[1], muxr1[2], 1'b0, 1'b0);
    logic_tile MUXS_R2(muxr2[0], clock, regc2, muxr2[1], muxr2[2], 1'b0, 1'b0);
    logic_tile MUXS_R3(muxr3[0], clock, regc2, muxr3[1], muxr3[2], 1'b0, 1'b0);
    logic_tile MUXS_R4(muxr4[0], clock, regc2, muxr4[1], muxr4[2], 1'b0, 1'b0);
    logic_tile MUXS_R5(muxr5[0], clock, regc2, muxr5[1], muxr5[2], 1'b0, 1'b0);
    logic_tile MUXS_R6(muxr6[0], clock, regc2, muxr6[1], muxr6[2], 1'b0, 1'b0);
    logic_tile MUXS_R7(muxr7[0], clock, regc2, muxr7[1], muxr7[2], 1'b0, 1'b0);
    logic_tile MUXS_R8(muxr8[0], clock, regc2, muxr8[1], muxr8[2], 1'b0, 1'b0);

    // finally switch boxes to assign output depending upon the configuration on switch boxes
    wire w;
    switch_box_4x4 SB0({w, w, w, out[0]}, {1'b0, m0, a0, muxr8[0]});
    switch_box_4x4 SB1({w, w, out[2], out[1]}, {a2, muxr6[0], a1, muxr7[0]});
    switch_box_4x4 SB2({w, w, out[4], out[3]}, {a4, muxr4[0], a3, muxr5[0]});
    switch_box_4x4 SB3({out[8], out[7], out[6], out[5]}, {muxr8[0], muxr1[0], muxr2[0], muxr3[0]});

endmodule