// Luc Laporte (3/25/26)
/*
  Usage Instructions and Tips
    Labels - Ensure unique label names and avoid using verilog keywords
    Warnings - Connect all optional inputs to remove warnings
    Clock - Use a single global clock
    Button - Buttons are not natively supported in verilog, consider using Inputs instead
*/

// Sample Testbench Code - Uncomment to use

/*
module TestBench();

  reg clk_0, Clock;
  reg [1:0] I;
  reg [3:0] inp_0;

  wire [1:0] Output;
  wire [2:0] out_0, out_1, out_2, out_3;

  Big DUT0(out_0, out_1, out_2, out_3, clk_0, inp_0);

  \TwoBitRiseEdge  DUT1(Output, I, Clock);

  always begin
    #10
    clk_0 = 0;
    #10
    clk_0 = 1;
  end

  initial begin
    inp_0 = 0;
    I = 0;
    Clock = 0;

    #15
    $display("out_0 = %b", out_0);
    $display("out_1 = %b", out_1);
    $display("out_2 = %b", out_2);
    $display("out_3 = %b", out_3);
    $display("Output = %b", Output);

    #10
    $display("out_0 = %b", out_0);
    $display("out_1 = %b", out_1);
    $display("out_2 = %b", out_2);
    $display("out_3 = %b", out_3);
    $display("Output = %b", Output);

    $finish;

  end
endmodule

*/
/*
module TestBench();
  reg clk_0, Clock; // clock
  reg [3:0] inp_0;  // opcode
  
  wire [2:0] out_0, out_1, out_2, out_3;
  
  Big DUT(out_0, out_1, out_2, out_3, clk_0, inp_0);
  
  always begin
    #10 clk_0 = 0;
    #10 clk_0 = 1;
  end
  
  initial begin
    Clock = 0; inp_0 = 4'b0000;  // Reset low, all-off mode
    #20 inp_0 = 4'b0001;         // Mode 1
    #200
    $display("North: %b, South: %b, East: %b, West: %b", out_0, out_1, out_2, out_3);
    $finish;
  end
endmodule
*/

module TestBench();
    reg clk_0;
    reg [3:0] inp_0;

    wire [2:0] out_0, out_1, out_2, out_3;

    Big DUT(out_0, out_1, out_2, out_3, clk_0, inp_0);

    always begin
        #10 clk_0 = 0;
        #10 clk_0 = 1;
    end

    initial begin
        inp_0 = 4'b0000;
        #50
        inp_0 = 4'b0001;
        #100
        inp_0 = 4'b0010;
        #100
        inp_0 = 4'b0011;
        #500
        $finish;
    end

    always @(posedge clk_0) begin
        $display("t=%0t: inp=%b | N=%b S=%b E=%b W=%b",
            $time, inp_0, out_0, out_1, out_2, out_3);
    end
endmodule

module Counter_2(q0, q1, Clock, Reset);
  output q0,  q1;
  input Clock, Reset;
  wire DflipFlop_1_Q, xor_0_out, DflipFlop_0_Q, DflipFlop_0_Q_inv;
  DflipFlop DflipFlop_1(DflipFlop_1_Q, , Clock, xor_0_out, Reset, , );
  assign q1 = DflipFlop_1_Q;
  assign xor_0_out = DflipFlop_0_Q ^ DflipFlop_1_Q;
  DflipFlop DflipFlop_0(DflipFlop_0_Q, DflipFlop_0_Q_inv, Clock, DflipFlop_0_Q_inv, Reset, , );
  assign q0 = DflipFlop_0_Q;
endmodule

module Counter6(q0, q1, q2, q3, q4, q5, Clock, Reset);
  output q0,  q1,  q2,  q3,  q4,  q5;
  input Clock, Reset;
  wire DflipFlop_5_Q, xor_4_out, DflipFlop_4_Q, and_3_out, xor_3_out, DflipFlop_3_Q, and_2_out, xor_2_out, DflipFlop_2_Q, and_1_out, xor_1_out, DflipFlop_1_Q, and_0_out, xor_0_out, DflipFlop_0_Q, DflipFlop_0_Q_inv;
  DflipFlop DflipFlop_5(DflipFlop_5_Q, , Clock, xor_4_out, Reset, , );
  assign q5 = DflipFlop_5_Q;
  assign xor_4_out = and_3_out ^ DflipFlop_5_Q;
  DflipFlop DflipFlop_4(DflipFlop_4_Q, , Clock, xor_3_out, Reset, , );
  assign q4 = DflipFlop_4_Q;
  assign and_3_out = and_2_out & DflipFlop_4_Q;
  assign xor_3_out = and_2_out ^ DflipFlop_4_Q;
  DflipFlop DflipFlop_3(DflipFlop_3_Q, , Clock, xor_2_out, Reset, , );
  assign q3 = DflipFlop_3_Q;
  assign and_2_out = and_1_out & DflipFlop_3_Q;
  assign xor_2_out = and_1_out ^ DflipFlop_3_Q;
  DflipFlop DflipFlop_2(DflipFlop_2_Q, , Clock, xor_1_out, Reset, , );
  assign q2 = DflipFlop_2_Q;
  assign and_1_out = and_0_out & DflipFlop_2_Q;
  assign xor_1_out = and_0_out ^ DflipFlop_2_Q;
  DflipFlop DflipFlop_1(DflipFlop_1_Q, , Clock, xor_0_out, Reset, , );
  assign q1 = DflipFlop_1_Q;
  assign and_0_out = DflipFlop_1_Q & DflipFlop_0_Q;
  assign xor_0_out = DflipFlop_0_Q ^ DflipFlop_1_Q;
  DflipFlop DflipFlop_0(DflipFlop_0_Q, DflipFlop_0_Q_inv, Clock, DflipFlop_0_Q_inv, Reset, , );
  assign q0 = DflipFlop_0_Q;
endmodule

module Main_Timing(Change_Light_Trigger, Clock, Reset, Timing_Mode, Light_Timing_Select);
  output Change_Light_Trigger;
  input Clock, Reset, Timing_Mode;
  input [1:0] Light_Timing_Select;
  wire Normal_Timing_out, Multiplexer_1_out, Rush_Hour_out, Counter6_0_out_0, Counter6_0_out_1, Counter6_0_out_2, Counter6_0_out_3, Counter6_0_out_4, Counter6_0_out_5, \45_Sec_out , \40_Seconds_out , \30_Sec_out , \5_Sec_out , \5_Seconds_out ;
  Multiplexer4 Normal_Timing(Normal_Timing_out, \30_Sec_out , \5_Seconds_out , \40_Seconds_out , , Light_Timing_Select);
  Multiplexer2 Multiplexer_1(Multiplexer_1_out, Normal_Timing_out, Rush_Hour_out, Timing_Mode);
  assign Change_Light_Trigger = Multiplexer_1_out;
  Multiplexer4 Rush_Hour(Rush_Hour_out, \45_Sec_out , \5_Sec_out , \30_Sec_out , , Light_Timing_Select);
  Counter6 Counter6_0(Counter6_0_out_0, Counter6_0_out_1, Counter6_0_out_2, Counter6_0_out_3, Counter6_0_out_4, Counter6_0_out_5, Clock, Reset);
  assign \45_Sec_out  = Counter6_0_out_5 & Counter6_0_out_3 & Counter6_0_out_3 & Counter6_0_out_0;
  assign \40_Seconds_out  = Counter6_0_out_3 & Counter6_0_out_5;
  assign \30_Sec_out  = Counter6_0_out_2 & Counter6_0_out_1 & Counter6_0_out_3 & Counter6_0_out_4;
  assign \30_Sec_out  = Counter6_0_out_2 & Counter6_0_out_1 & Counter6_0_out_3 & Counter6_0_out_4;
  assign \5_Sec_out  = Counter6_0_out_3 & Counter6_0_out_0;
  assign \5_Seconds_out  = Counter6_0_out_0 & Counter6_0_out_2;
endmodule

module main_selector(Color, clk_0, \Mode  , Clock, Reset, Timing_Mode);
  output [1:0] Color;
  input Clock, Reset, Timing_Mode, clk_0;
  input [1:0] \Mode  ;
  wire Main_Timing_1_out, DflipFlop_1_Q, Counter_2_0_out_0, Counter_2_0_out_1, and_0_out, or_1_out, or_0_out;
  wire [1:0] Splitter_0_cmb, DflipFlop_0_Q, Multiplexer_0_out, const_2, const_1, const_0;
  Main_Timing Main_Timing_1(Main_Timing_1_out, Clock, or_0_out, Timing_Mode, Multiplexer_0_out);
  DflipFlop DflipFlop_1(DflipFlop_1_Q, , Clock, Main_Timing_1_out, , , );
  Counter_2 Counter_2_0(Counter_2_0_out_0, Counter_2_0_out_1, DflipFlop_1_Q, or_1_out);
  assign Splitter_0_cmb = {Counter_2_0_out_1,Counter_2_0_out_0};
  DflipFlop #(2) DflipFlop_0(DflipFlop_0_Q, , Clock, Splitter_0_cmb, , , );
  Multiplexer4 #(2) Multiplexer_0(Multiplexer_0_out, DflipFlop_0_Q, const_0, const_1, const_2, \Mode  );
  assign Color = Multiplexer_0_out;
  assign and_0_out = Counter_2_0_out_1 & Counter_2_0_out_0;
  assign or_1_out = Reset | and_0_out;
  assign or_0_out = Reset | DflipFlop_1_Q;
  assign const_2 = 2'b10;
  assign const_1 = 2'b01;
  assign const_0 = 2'b00;
endmodule

module Main(Main_Light_North, Main_Light_South, clk_0, Clock, Mode_North, Reset, Mode_South, Timing_Code);
  output [2:0] Main_Light_North, Main_Light_South;
  input Clock, Reset, Timing_Code, clk_0;
  input [1:0] Mode_North, Mode_South;
  wire [1:0] north_color, south_color;
  wire [2:0] north_mux_out, south_mux_out, north_reg_q, south_reg_q;
  wire [2:0] off=3'b000, red=3'b001, yellow=3'b010, green=3'b100;
  
  // North lights
  main_selector north_sel(north_color, clk_0, Mode_North, Clock, Reset, Timing_Code);
  Multiplexer4 #(3) north_mux(north_mux_out, green, yellow, red, off, north_color);
  DflipFlop #(3) north_register(north_reg_q, , Clock, north_mux_out, Reset, ,); // FIX
  assign Main_Light_North = north_reg_q;
  
  // South lights  
  main_selector south_sel(south_color, clk_0, Mode_South, Clock, Reset, Timing_Code);
  Multiplexer4 #(3) south_mux(south_mux_out, green, yellow, red, off, south_color);
  DflipFlop #(3) south_register(south_reg_q, , Clock, south_mux_out, Reset, , ); // FIX
  assign Main_Light_South = south_reg_q;
endmodule

module Side_Timing(Change_Light_Trigger, Clock, Reset, Timing_Mode, Light_Timing_Select);
  output Change_Light_Trigger;
  input Clock, Reset, Timing_Mode;
  input [1:0] Light_Timing_Select;
  wire Normal_Timing_out, Multiplexer_1_out, Rush_Hour_out, Counter6_0_out_0, Counter6_0_out_1, Counter6_0_out_2, Counter6_0_out_3, Counter6_0_out_4, Counter6_0_out_5, \20_Sec_out , \55_Sec_out , \40_Sec_out , \30_Sec_out , \5_Sec_out ;
  Multiplexer4 Normal_Timing(Normal_Timing_out, \40_Sec_out , \30_Sec_out , \5_Sec_out , , Light_Timing_Select);
  Multiplexer2 Multiplexer_1(Multiplexer_1_out, Normal_Timing_out, Rush_Hour_out, Timing_Mode);
  assign Change_Light_Trigger = Multiplexer_1_out;
  Multiplexer4 Rush_Hour(Rush_Hour_out, \55_Sec_out , \20_Sec_out , \5_Sec_out , , Light_Timing_Select);
  Counter6 Counter6_0(Counter6_0_out_0, Counter6_0_out_1, Counter6_0_out_2, Counter6_0_out_3, Counter6_0_out_4, Counter6_0_out_5, Clock, Reset);
  assign \20_Sec_out  = Counter6_0_out_3 & Counter6_0_out_5;
  assign \55_Sec_out  = Counter6_0_out_1 & Counter6_0_out_0 & Counter6_0_out_2 & Counter6_0_out_4 & Counter6_0_out_5;
  assign \40_Sec_out  = Counter6_0_out_3 & Counter6_0_out_5;
  assign \30_Sec_out  = Counter6_0_out_2 & Counter6_0_out_1 & Counter6_0_out_3 & Counter6_0_out_4;
  assign \5_Sec_out  = Counter6_0_out_0 & Counter6_0_out_2;
  assign \5_Sec_out  = Counter6_0_out_0 & Counter6_0_out_2;
endmodule



module Side_selector(Color, clk_0, \Mode  , Clock, Reset, Timing_Mode);
  output [1:0] Color;
  input Clock, Reset, Timing_Mode, clk_0;
  input [1:0] \Mode  ;
  wire DflipFlop_1_Q, Counter_2_0_out_0, Counter_2_0_out_1, Side_Timing_1_out, and_0_out, or_1_out, or_0_out;
  wire [1:0] Splitter_0_cmb, DflipFlop_0_Q, Multiplexer_0_out, const_2, const_1, const_0;
  DflipFlop DflipFlop_1(DflipFlop_1_Q, , clk_0, Side_Timing_1_out, , , );
  Counter_2 Counter_2_0(Counter_2_0_out_0, Counter_2_0_out_1, DflipFlop_1_Q, or_1_out);
  assign Splitter_0_cmb = {Counter_2_0_out_1,Counter_2_0_out_0};
  DflipFlop #(2) DflipFlop_0(DflipFlop_0_Q, , clk_0, Splitter_0_cmb, , , );
  Multiplexer4 #(2) Multiplexer_0(Multiplexer_0_out, DflipFlop_0_Q, const_0, const_1, const_2, \Mode  );
  Side_Timing Side_Timing_1(Side_Timing_1_out, clk_0, or_0_out, Timing_Mode, Multiplexer_0_out);
  assign Color = Multiplexer_0_out;
  assign and_0_out = Counter_2_0_out_1 & Counter_2_0_out_0;
  assign or_1_out = Reset | and_0_out;
  assign or_0_out = Reset | DflipFlop_1_Q;
  assign const_2 = 2'b10;
  assign const_1 = 2'b01;
  assign const_0 = 2'b00;
endmodule





module Side(Side_Light_East, Side_Light_West, Reset, Clock, Mode_East, Timing_Mode, Mode_West);
  output [2:0] Side_Light_East, Side_Light_West;
  input Reset, Clock, Timing_Mode;
  input [1:0] Mode_East, Mode_West;
  wire [1:0] Side_selector_1_out, Side_selector_0_out;
  wire [2:0] Main_Light_South_out, Side_Light_West_Register_Q, Side_Ligth_North_out, Side_Light_East_Register_Q, Off, Red, Yellow, Green;
  Side_selector Side_selector_1(Side_selector_1_out, Clock, Mode_West, Clock, Reset, Timing_Mode); // added clock
  Multiplexer4 #(3) Main_Light_South(Main_Light_South_out, Red, Green, Yellow, Off, Side_selector_1_out);
  DflipFlop #(3) Side_Light_West_Register(Side_Light_West_Register_Q, , Clock, Main_Light_South_out, Reset, , );
  assign Side_Light_West = Side_Light_West_Register_Q;
  Side_selector Side_selector_0(Side_selector_0_out, Clock, Mode_East, Clock, Reset, Timing_Mode); // added clock
  Multiplexer4 #(3) Side_Ligth_North(Side_Ligth_North_out, Red, Green, Yellow, Off, Side_selector_0_out);
  DflipFlop #(3) Side_Light_East_Register(Side_Light_East_Register_Q, , Clock, Side_Ligth_North_out, Reset, , );
  assign Side_Light_East = Side_Light_East_Register_Q;
  assign Off = 3'b000;
  assign Red = 3'b001;
  assign Yellow = 3'b010;
  assign Green = 3'b100;
endmodule




module OP_Selector(Main_North, Side_East, Reset, Timing_Mode, Main_South, Side_West, OPCodes);
  output Reset,  Timing_Mode;
  output [1:0] Main_North, Side_East, Main_South, Side_West;
  input [3:0] OPCodes;
  wire and_17_out, or_7_out, and_16_out, and_15_out, or_6_out, and_14_out, and_13_out, or_5_out, and_12_out, and_10_out, or_4_out, and_9_out, and_8_out, or_3_out, and_18_out, not_8_out, and_5_out, or_2_out, not_5_out, and_7_out, and_2_out, or_1_out, not_3_out, and_1_out, and_0_out, or_0_out, not_0_out, and_3_out, not_13_out, and_11_out, not_11_out, and_6_out, and_4_out, not_4_out, not_1_out, not_16_out, not_14_out, not_12_out, not_19_out, not_6_out, not_18_out, not_17_out, not_15_out, not_10_out, not_9_out, not_7_out, not_2_out;
  wire [1:0] Splitter_4_cmb, Splitter_3_cmb, Splitter_2_cmb, Splitter_1_cmb;
  
  assign and_17_out = OPCodes[3] & OPCodes[1] & OPCodes[0];
  assign or_7_out = and_16_out | and_17_out;
  assign Splitter_4_cmb = {or_7_out,or_6_out};
  assign Side_West = Splitter_4_cmb;
  assign and_16_out = OPCodes[2] & OPCodes[3] & not_16_out & not_17_out;
  assign and_15_out = OPCodes[3] & OPCodes[1] & not_18_out;
  assign or_6_out = and_10_out | and_14_out | and_15_out;
  assign and_14_out = OPCodes[3] & OPCodes[2] & not_15_out;
  assign and_13_out = OPCodes[2] & OPCodes[3] & OPCodes[1] & OPCodes[0];
  assign or_5_out = and_12_out | and_13_out;
  assign Splitter_3_cmb = {or_5_out,or_4_out};
  assign Side_East = Splitter_3_cmb;
  assign and_12_out = OPCodes[3] & not_13_out & not_14_out;
  assign and_10_out = OPCodes[3] & OPCodes[2] & OPCodes[1];
  assign or_4_out = and_9_out | and_10_out | and_11_out;
  assign and_9_out = not_11_out & OPCodes[3] & not_12_out & OPCodes[0];
  assign and_8_out = OPCodes[3] & OPCodes[2] & OPCodes[1];
  assign or_3_out = and_7_out | and_8_out | and_4_out;
  assign Splitter_2_cmb = {or_3_out,or_2_out};
  assign Main_South = Splitter_2_cmb;
  assign and_18_out = OPCodes[2] & OPCodes[3] & not_19_out & OPCodes[0];
  assign Timing_Mode = and_18_out;
  assign not_8_out = ~OPCodes[3];
  assign and_5_out = not_8_out & OPCodes[2] & not_9_out;
  assign or_2_out = and_5_out | and_6_out;
  assign not_5_out = ~OPCodes[3];
  assign and_7_out = OPCodes[2] & not_5_out & not_6_out & OPCodes[0];
  assign and_2_out = OPCodes[3] & OPCodes[2] & OPCodes[1];
  assign or_1_out = and_1_out | and_2_out;
  assign Splitter_1_cmb = {or_1_out,or_0_out};
  assign Main_North = Splitter_1_cmb;
  assign not_3_out = ~OPCodes[3];
  assign and_1_out = not_3_out & not_4_out & OPCodes[1];
  assign and_0_out = OPCodes[1] & not_2_out & OPCodes[2] & OPCodes[3];
  assign or_0_out = and_3_out | and_0_out;
  assign not_0_out = ~OPCodes[3];
  assign and_3_out = not_0_out & not_1_out & OPCodes[0];
  assign not_13_out = ~OPCodes[2];
  assign and_11_out = OPCodes[2] & OPCodes[1] & OPCodes[0];
  assign not_11_out = ~OPCodes[2];
  assign and_6_out = OPCodes[2] & OPCodes[1] & not_10_out;
  assign and_4_out = OPCodes[2] & OPCodes[1] & not_7_out;
  assign not_4_out = ~OPCodes[2];
  assign not_1_out = ~OPCodes[2];
  assign not_16_out = ~OPCodes[1];
  assign not_14_out = ~OPCodes[1];
  assign not_12_out = ~OPCodes[1];
  assign not_19_out = ~OPCodes[1];
  assign not_6_out = ~OPCodes[1];
  assign not_18_out = ~OPCodes[0];
  assign not_17_out = ~OPCodes[0];
  assign not_15_out = ~OPCodes[0];
  assign not_10_out = ~OPCodes[0];
  assign not_9_out = ~OPCodes[0];
  assign not_7_out = ~OPCodes[0];
  assign not_2_out = ~OPCodes[0];
endmodule


module RiseEdge_Detector(Output, I, Clock);
  output Output;
  input I, Clock;
  wire DflipFlop_0_Q_inv, and_0_out;
  DflipFlop DflipFlop_0(, DflipFlop_0_Q_inv, Clock, I, , , );
  assign and_0_out = I & DflipFlop_0_Q_inv;
  assign Output = and_0_out;
endmodule


module Big(out_0, out_1, out_2, out_3, clk_0, inp_0);
  output [2:0] out_0, out_1, out_2, out_3;
  input clk_0;
  input [3:0] inp_0;
  wire Button_0_out, and_1_out, and_2_out, RiseEdge_Detector_4_out, Counter_2_3_out_0, Counter_2_3_out_1, and_3_out, OP_Selector_2_out_2, OP_Selector_2_out_3, and_0_out;
  wire [1:0] OP_Selector_2_out_0, OP_Selector_2_out_1, OP_Selector_2_out_4, OP_Selector_2_out_5;
  wire [2:0] Side_1_out_0, Side_1_out_1, Main_0_out_0, Main_0_out_1;
  wire [3:0] xnor_0_out, Multiplexer_0_out, DflipFlop_0_Q, All_Red, Ground_0_out;
  assign Button_0_out = inp_0[0];
  Side Side_1(Side_1_out_0, Side_1_out_1, Button_0_out, clk_0, OP_Selector_2_out_1, OP_Selector_2_out_3, OP_Selector_2_out_5);
  assign out_3 = Side_1_out_1;
  assign out_2 = Side_1_out_0;
  Main Main_0(Main_0_out_0, Main_0_out_1, clk_0, clk_0, OP_Selector_2_out_0, Button_0_out, OP_Selector_2_out_4, OP_Selector_2_out_3);
  assign out_1 = Main_0_out_1;
  assign out_0 = Main_0_out_0;
  assign xnor_0_out = ~(Ground_0_out ^ inp_0);
  assign and_1_out = xnor_0_out[2] & xnor_0_out[3];
  assign and_2_out = and_0_out & and_1_out;
  RiseEdge_Detector RiseEdge_Detector_4(RiseEdge_Detector_4_out, and_2_out, clk_0);
  Counter_2 Counter_2_3(Counter_2_3_out_0, Counter_2_3_out_1, clk_0, RiseEdge_Detector_4_out);
  assign and_3_out = Counter_2_3_out_1 & Counter_2_3_out_0;
  Multiplexer2 #(4) Multiplexer_0(Multiplexer_0_out, All_Red, DflipFlop_0_Q, and_3_out);
  OP_Selector OP_Selector_2(OP_Selector_2_out_0, OP_Selector_2_out_1, OP_Selector_2_out_2, OP_Selector_2_out_3, OP_Selector_2_out_4, OP_Selector_2_out_5, Multiplexer_0_out);
  assign and_0_out = xnor_0_out[0] & xnor_0_out[1];
  DflipFlop #(4) DflipFlop_0(DflipFlop_0_Q, , clk_0, inp_0, Button_0_out, ,);
  assign All_Red = 4'b1110;
  assign Ground_0_out = 4'b0;
endmodule

module TwoBitRiseEdge (Output, I, Clock);
  output [1:0] Output;
  input Clock;
  input [1:0] I;
  wire or_0_out;
  wire [1:0] DflipFlop_0_Q_inv, and_0_out;
  DflipFlop #(2) DflipFlop_0(, DflipFlop_0_Q_inv, Clock, I, , , or_0_out);
  assign and_0_out = I & DflipFlop_0_Q_inv;
  
  assign or_0_out = and_0_out[0] | and_0_out[1];
  assign Output = and_0_out;
endmodule

module DflipFlop(q, q_inv, clk, d, a_rst, pre, en);
    parameter WIDTH = 1;
    output reg [WIDTH-1:0] q, q_inv;
    input clk, a_rst, pre, en;
    input [WIDTH-1:0] d;

    always @ (posedge clk or posedge a_rst)
    if (a_rst) begin
        q <= 'b0;
        q_inv <= 'b1;
    end else if (en == 0) ;
    else begin
        q <= d;
        q_inv <= ~d;
    end
endmodule
    
module Multiplexer4(out, in0, in1, in2, in3, sel);
  parameter WIDTH = 1;
  output reg [WIDTH-1:0] out;
  input [WIDTH-1:0] in0, in1, in2, in3;
  input [1:0] sel;
  
  always @ (*)
    case (sel)
      0 : out = in0;
      1 : out = in1;
      2 : out = in2;
      3 : out = in3;
    endcase
endmodule


module Multiplexer2(out, in0, in1, sel);
  parameter WIDTH = 1;
  output reg [WIDTH-1:0] out;
  input [WIDTH-1:0] in0, in1;
  input [0:0] sel;
  
  always @ (*)
    case (sel)
      0 : out = in0;
      1 : out = in1;
    endcase
endmodule
    