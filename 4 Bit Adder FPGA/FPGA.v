module logic_tile(out, clock, in1, in2, in3, in4, in5);
    // declaring input output
    input clock, in1, in2, in3, in4, in5;
    output out;
    // declaring memory to store lookup table
    reg [32:0] mem;
    // declaring memory to store intermediate value. used reg instead of wire because it has been used in flip-flop that way.
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
            x <= {in5, in4, in3, in2, in1};
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

// code for lab5
// 4 bit adder with carry in and carry out

module adder_4_bit(clock, in1, in2, cin, out, cout);
    // input output declaration
    input [3:0] in1, in2;
    input clock, cin;
    output [3:0] out;
    output cout;
    // declaring memory to store configuration of 3 different logic tiles
    reg [32:0] mem0, mem1, mem2;
    // declaring wires to be used in the circuit in intermediate parts
    wire w20;
    // combinational circuit design using structural statements
    logic_tile LT00(out[0], clock, cin, in2[0], in2[1], in1[0], in1[1]);
    logic_tile LT10(out[1], clock, cin, in2[0], in2[1], in1[0], in1[1]);
    logic_tile LT20(w20, clock, cin, in2[0], in2[1], in1[0], in1[1]);
    logic_tile LT01(out[2], clock, w20, in2[2], in2[3], in1[2], in1[3]);
    logic_tile LT11(out[3], clock, w20, in2[2], in2[3], in1[2], in1[3]);
    logic_tile LT21(cout, clock, w20, in2[2], in2[3], in1[2], in1[3]);
endmodule