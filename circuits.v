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
instantiation function for the flip flop
DflipFlop DflipFlop_inst (
  .q(q wire), .q_inv(q_inv wire), .clk(Clock), 
  .d(d input), .a_rst(Reset), .pre(1'b1), .en(1'b1)
); 
*/

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
    reg Reset;
    reg [3:0] inp_0;
    wire [2:0] out_0, out_1, out_2, out_3;
    wire [3:0] current_opcode; // new declarations
    wire [1:0] north_state, south_state, east_state, west_state;
    wire error_flag;
    Big DUT(
      .out_0(out_0),
      .out_1(out_1),
      .out_2(out_2),
      .out_3(out_3),
      .current_opcode(current_opcode), // added missing params
      .north_state(north_state), 
      .south_state(south_state),
      .east_state(east_state),
      .west_state(west_state),
      .error_flag(error_flag),
      .clk_0(clk_0),
      .Reset(Reset),
      .inp_0(inp_0)
    );

    always begin
        #10 clk_0 = 0;
        #10 clk_0 = 1;
    end

    initial begin
      Reset = 1'b1;
        inp_0 = 4'b0000;
      #20
      Reset = 1'b0;
        #50
        inp_0 = 4'b0001;
        #100
        inp_0 = 4'b0010;
        #100
        inp_0 = 4'b0011;
        #500
        $finish;
    end

    always @(posedge clk_0) begin // expanding the debug to show more info
    $display("t=%0t: inp=%b op=%b | N=%b S=%b E=%b W=%b err=%b", 
        $time, inp_0, current_opcode,
        out_0, out_1, out_2, out_3,
        error_flag);
    end
endmodule

module Counter_2(q0, q1, Clock, Reset);
  output q0,  q1;
  input Clock, Reset;
  wire DflipFlop_1_Q, xor_0_out, DflipFlop_0_Q, DflipFlop_0_Q_inv;
  DflipFlop DflipFlop_1(DflipFlop_1_Q, , Clock, xor_0_out, Reset, , 1'b1); // added 1'b1 as 7th input
  assign q1 = DflipFlop_1_Q;
  assign xor_0_out = DflipFlop_0_Q ^ DflipFlop_1_Q;
  DflipFlop DflipFlop_0(DflipFlop_0_Q, DflipFlop_0_Q_inv, Clock, DflipFlop_0_Q_inv, Reset, , 1'b1);
  assign q0 = DflipFlop_0_Q;
endmodule

module Counter6(q0, q1, q2, q3, q4, q5, Clock, Reset);
  output q0,  q1,  q2,  q3,  q4,  q5;
  input Clock, Reset;
  wire DflipFlop_5_Q, xor_4_out, DflipFlop_4_Q, and_3_out, xor_3_out, DflipFlop_3_Q, and_2_out, xor_2_out, DflipFlop_2_Q, and_1_out, xor_1_out, DflipFlop_1_Q, and_0_out, xor_0_out, DflipFlop_0_Q, DflipFlop_0_Q_inv;
  DflipFlop DflipFlop_5(DflipFlop_5_Q, , Clock, xor_4_out, Reset, , 1'b1); // added 1'b1 as 7th input
  assign q5 = DflipFlop_5_Q;
  assign xor_4_out = and_3_out ^ DflipFlop_5_Q;
  DflipFlop DflipFlop_4(DflipFlop_4_Q, , Clock, xor_3_out, Reset, , 1'b1); // added 1'b1 as 7th input
  assign q4 = DflipFlop_4_Q;
  assign and_3_out = and_2_out & DflipFlop_4_Q;
  assign xor_3_out = and_2_out ^ DflipFlop_4_Q;
  DflipFlop DflipFlop_3(DflipFlop_3_Q, , Clock, xor_2_out, Reset, , 1'b1); // added 1'b1 as 7th input
  assign q3 = DflipFlop_3_Q;
  assign and_2_out = and_1_out & DflipFlop_3_Q;
  assign xor_2_out = and_1_out ^ DflipFlop_3_Q;
  DflipFlop DflipFlop_2(DflipFlop_2_Q, , Clock, xor_1_out, Reset, , 1'b1); // added 1'b1 as 7th input
  assign q2 = DflipFlop_2_Q;
  assign and_1_out = and_0_out & DflipFlop_2_Q;
  assign xor_1_out = and_0_out ^ DflipFlop_2_Q;
  DflipFlop DflipFlop_1(DflipFlop_1_Q, , Clock, xor_0_out, Reset, , 1'b1); // added 1'b1 as 7th input
  assign q1 = DflipFlop_1_Q;
  assign and_0_out = DflipFlop_1_Q & DflipFlop_0_Q;
  assign xor_0_out = DflipFlop_0_Q ^ DflipFlop_1_Q;
  DflipFlop DflipFlop_0(DflipFlop_0_Q, DflipFlop_0_Q_inv, Clock, DflipFlop_0_Q_inv, Reset, , 1'b1); // added 1'b1 as 7th input
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
  assign \5_Sec_out  = Counter6_0_out_3 & Counter6_0_out_0;
endmodule

module main_selector(Color, clk_0, \Mode  , Clock, Reset, Timing_Mode);
  output [1:0] Color;
  input Clock, Reset, Timing_Mode, clk_0;
  input [1:0] \Mode  ;
  wire Main_Timing_1_out, DflipFlop_1_Q, Counter_2_0_out_0, Counter_2_0_out_1, and_0_out, or_1_out, or_0_out;
  wire [1:0] Splitter_0_cmb, DflipFlop_0_Q, Multiplexer_0_out, const_2, const_1, const_0;
  Main_Timing Main_Timing_1(Main_Timing_1_out, Clock, or_0_out, Timing_Mode, Multiplexer_0_out);
  DflipFlop DflipFlop_1(DflipFlop_1_Q, , Clock, Main_Timing_1_out, , , 1'b1); // added 1'b1 as 7th input
  Counter_2 Counter_2_0(Counter_2_0_out_0, Counter_2_0_out_1, DflipFlop_1_Q, or_1_out);
  assign Splitter_0_cmb = {Counter_2_0_out_1,Counter_2_0_out_0};
  DflipFlop #(2) DflipFlop_0(DflipFlop_0_Q, , Clock, Splitter_0_cmb, , , 1'b1); // added 1'b1 as 7th input
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
  DflipFlop #(3) north_register(north_reg_q, , Clock, north_mux_out, Reset, , 1'b1); // added 1'b1 as 7th input
  assign Main_Light_North = north_reg_q;
  
  // South lights  
  main_selector south_sel(south_color, clk_0, Mode_South, Clock, Reset, Timing_Code);
  Multiplexer4 #(3) south_mux(south_mux_out, green, yellow, red, off, south_color);
  DflipFlop #(3) south_register(south_reg_q, , Clock, south_mux_out, Reset, , 1'b1); // added 1'b1 as 7th input
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
  // removed duplicate line
endmodule



module Side_selector(Color, clk_0, \Mode  , Clock, Reset, Timing_Mode);
  output [1:0] Color;
  input Clock, Reset, Timing_Mode, clk_0;
  input [1:0] \Mode  ;
  wire DflipFlop_1_Q, Counter_2_0_out_0, Counter_2_0_out_1, Side_Timing_1_out, and_0_out, or_1_out, or_0_out;
  wire [1:0] Splitter_0_cmb, DflipFlop_0_Q, Multiplexer_0_out, const_2, const_1, const_0;
  DflipFlop DflipFlop_1(DflipFlop_1_Q, , clk_0, Side_Timing_1_out, , , 1'b1); // added 1'b1 as 7th input
  Counter_2 Counter_2_0(Counter_2_0_out_0, Counter_2_0_out_1, DflipFlop_1_Q, or_1_out);
  assign Splitter_0_cmb = {Counter_2_0_out_1,Counter_2_0_out_0};
  DflipFlop #(2) DflipFlop_0(DflipFlop_0_Q, , clk_0, Splitter_0_cmb, , , 1'b1); // added 1'b1 as 7th input
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
  DflipFlop #(3) Side_Light_West_Register(Side_Light_West_Register_Q, , Clock, Main_Light_South_out, Reset, 1'b1, ); // added 1'b1 as 7th input 
  assign Side_Light_West = Side_Light_West_Register_Q;
  Side_selector Side_selector_0(Side_selector_0_out, Clock, Mode_East, Clock, Reset, Timing_Mode); // added clock
  Multiplexer4 #(3) Side_Ligth_North(Side_Ligth_North_out, Red, Green, Yellow, Off, Side_selector_0_out);
  DflipFlop #(3) Side_Light_East_Register(Side_Light_East_Register_Q, , Clock, Side_Ligth_North_out, Reset, 1'b1, ); // added 1'b1 as 7th input
  assign Side_Light_East = Side_Light_East_Register_Q;
  assign Off = 3'b000;
  assign Red = 3'b001;
  assign Yellow = 3'b010;
  assign Green = 3'b100;
endmodule




module OP_Selector(
  output [1:0] Main_North, Side_East, Main_South, Side_West,
    output Reset, Timing_Mode,
    input [3:0] OPCodes
);    
    reg [1:0] Main_North_int, Side_East_int, Main_South_int, Side_West_int; // internal wires   
    assign Timing_Mode = OPCodes[3]; // allows for the flexibility of modes
    assign Reset = ~OPCodes[0]; // 1'b0 on inp_0[0], this makes it reset low

    /* assignments for the internal wires */

    assign Main_North = Main_North_int;
    assign Side_East = Side_East_int;
    assign Main_South = Main_South_int;
    assign Side_West = Side_West_int; 

    always @ (*) begin
        case (OPCodes[3:0])
            4'b0000: begin
                Main_North_int = 2'b00;  // off
                Main_South_int = 2'b00;  // off
                Side_East_int  = 2'b00;  // off
                Side_West_int  = 2'b00;  // off
            end
            4'b0001: begin
                Main_North_int = 2'b10;  // green
                Main_South_int = 2'b10;  // green
                Side_East_int  = 2'b01;  // yellow
                Side_West_int  = 2'b01;  // yellow
            end
            4'b0010: begin
                Main_North_int = 2'b01;  // yellow
                Main_South_int = 2'b01;  // yellow
                Side_East_int  = 2'b10;  // green
                Side_West_int  = 2'b10;  // green
            end
            4'b0011: begin
                Main_North_int = 2'b11;  // red
                Main_South_int = 2'b11;  // red
                Side_East_int  = 2'b11;  // red
                Side_West_int  = 2'b11;  // red
            end
            // 4'b01xx timing modes
            4'b0100,
            4'b0101,
            4'b0110,
            4'b0111: begin
                // normal timing vs fixed pattern
                Main_North_int = 2'b10;
                Main_South_int = 2'b10;
                Side_East_int  = 2'b01;
                Side_West_int  = 2'b01;
            end
            // debug modes for each of them
            4'b1000: begin
                // single‑step / debug
                Main_North_int = 2'b10;
                Main_South_int = 2'b10;
                Side_East_int  = 2'b00;
                Side_West_int  = 2'b00;
            end
            default: begin
                Main_North_int = 2'b00;
                Main_South_int = 2'b00;
                Side_East_int  = 2'b00;
                Side_West_int  = 2'b00;
            end
        endcase
    end
endmodule


module RiseEdge_Detector(Output, I, Clock);
  output Output;
  input I, Clock;
  wire DflipFlop_0_Q_inv, and_0_out;
  DflipFlop DflipFlop_0(, DflipFlop_0_Q_inv, Clock, I, , 1'b1, ); // added 1'b1 as 7th input 
  assign and_0_out = I & DflipFlop_0_Q_inv;
  assign Output = and_0_out;
endmodule


module Big(
    output [2:0] out_0, out_1, out_2, out_3,
    output [3:0] current_opcode, 
    output [1:0] north_state, south_state, east_state, west_state,
    output error_flag, // simple error flag
    input clk_0, Reset, // explicit Reset
    input [3:0] inp_0
);
    wire Button_0_out, and_1_out, and_2_out, RiseEdge_Detector_4_out, Counter_2_3_out_0, Counter_2_3_out_1, and_3_out, OP_Selector_reset, OP_Selector_timing, and_0_out;
    wire [1:0] OP_Selector_2_out_0, OP_Selector_2_out_1, OP_Selector_2_out_4, OP_Selector_2_out_5;
    wire [2:0] Side_1_out_0, Side_1_out_1, Main_0_out_0, Main_0_out_1;
    wire [3:0] xnor_0_out, Multiplexer_0_out, DflipFlop_0_Q, All_Red, Ground_0_out;
    assign Button_0_out = 1'b0; // allows for a button effect

    Side Side_1(
        Side_1_out_0, Side_1_out_1,
      Reset, clk_0, OP_Selector_2_out_1, OP_Selector_timing, OP_Selector_2_out_5
    );
    assign out_3 = Side_1_out_1;
    assign out_2 = Side_1_out_0;

    Main Main_0(
        Main_0_out_0, Main_0_out_1,
        clk_0, clk_0,
      OP_Selector_2_out_0, Reset, OP_Selector_2_out_4, OP_Selector_timing
    );
    assign out_1 = Main_0_out_1;
    assign out_0 = Main_0_out_0;

    // Status outputs
    assign current_opcode = inp_0;

    // 2‑bit state per road (from OP_Selector outputs)
    assign north_state = OP_Selector_2_out_0;
    assign south_state = OP_Selector_2_out_4;
    assign east_state = OP_Selector_2_out_1;
    assign west_state = OP_Selector_2_out_5;

    // error flag with an example
    assign error_flag = (inp_0[3:2] == 2'b11);

    // existing rest of Big (xnor, counters, OP_Selector_2, etc.)
    assign xnor_0_out = ~(Ground_0_out ^ inp_0);
    assign and_1_out = xnor_0_out[2] & xnor_0_out[3];
    assign and_2_out = and_0_out & and_1_out;
    RiseEdge_Detector RiseEdge_Detector_4(RiseEdge_Detector_4_out, and_2_out, clk_0);
    Counter_2 Counter_2_3(Counter_2_3_out_0, Counter_2_3_out_1, clk_0, RiseEdge_Detector_4_out);
    assign and_3_out = Counter_2_3_out_1 & Counter_2_3_out_0;
    Multiplexer2 #(4) Multiplexer_0(Multiplexer_0_out, All_Red, DflipFlop_0_Q, and_3_out);
    OP_Selector OP_Selector_2(
      .Main_North(OP_Selector_2_out_0),
      .Side_East(OP_Selector_2_out_1),
      .Main_South(OP_Selector_2_out_4),
      .Side_West(OP_Selector_2_out_5),
      .Reset(OP_Selector_reset),
      .Timing_Mode(OP_Selector_timing),
      .OPCodes(Multiplexer_0_out)
    );
    assign and_0_out = xnor_0_out[0] & xnor_0_out[1];
    DflipFlop #(4) DflipFlop_0(DflipFlop_0_Q, , clk_0, inp_0, Button_0_out, 1'b1,); // added 1'b1 as 7th input
    assign All_Red = 4'b1110;
    assign Ground_0_out = 4'b0;
endmodule

module TwoBitRiseEdge (Output, I, Clock);
  output [1:0] Output;
  input Clock;
  input [1:0] I;
  wire or_0_out;
  wire [1:0] DflipFlop_0_Q_inv, and_0_out;
  DflipFlop #(2) DflipFlop_0(, DflipFlop_0_Q_inv, Clock, I, , 1'b1, or_0_out); // added 1'b1 as 7th input
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
    