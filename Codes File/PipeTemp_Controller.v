module PipeTemp_Controller (
    input Clock,
    input Reset,
    input [7:0] Temp_Data,
    output reg Alarm,
    output reg Shutdown,
    output reg Done,
    output [6:0] units_seconds_segment_leds,
    output [6:0] tens_seconds_segment_leds,
    output [6:0] units_minutes_segment_leds,
    output [6:0] tens_minutes_segment_leds,
    output reg [3:0] minutes_tens,
    minutes_units,
    output reg [3:0] seconds_tens,
    seconds_units
);

  parameter PERIOD = 15;

  reg [31:0] counter;

  reg [ 3:0] minutes;
  reg [ 5:0] seconds;

  // `include "decoder_7seg_anode.v"

  decoder_7seg_anode decoder_seconds_units (
      .A(seconds_units[3]),
      .B(seconds_units[2]),
      .C(seconds_units[1]),
      .D(seconds_units[0]),
      .led_a(units_seconds_segment_leds[6]),
      .led_b(units_seconds_segment_leds[5]),
      .led_c(units_seconds_segment_leds[4]),
      .led_d(units_seconds_segment_leds[3]),
      .led_e(units_seconds_segment_leds[2]),
      .led_f(units_seconds_segment_leds[1]),
      .led_g(units_seconds_segment_leds[0])
  );

  decoder_7seg_anode decoder_seconds_tens (
      .A(seconds_tens[0]),
      .B(seconds_tens[1]),
      .C(seconds_tens[2]),
      .D(seconds_tens[3]),
      .led_a(tens_seconds_segment_leds[6]),
      .led_b(tens_seconds_segment_leds[5]),
      .led_c(tens_seconds_segment_leds[4]),
      .led_d(tens_seconds_segment_leds[3]),
      .led_e(tens_seconds_segment_leds[2]),
      .led_f(tens_seconds_segment_leds[1]),
      .led_g(tens_seconds_segment_leds[0])
  );

  decoder_7seg_anode decoder_minutes_units (
      .A(minutes_units[3]),
      .B(minutes_units[2]),
      .C(minutes_units[1]),
      .D(minutes_units[0]),
      .led_a(units_minutes_segment_leds[6]),
      .led_b(units_minutes_segment_leds[5]),
      .led_c(units_minutes_segment_leds[4]),
      .led_d(units_minutes_segment_leds[3]),
      .led_e(units_minutes_segment_leds[2]),
      .led_f(units_minutes_segment_leds[1]),
      .led_g(units_minutes_segment_leds[0])
  );

  decoder_7seg_anode decoder_minutes_tens (
      .A(minutes_tens[3]),
      .B(minutes_tens[2]),
      .C(minutes_tens[1]),
      .D(minutes_tens[0]),
      .led_a(tens_minutes_segment_leds[6]),
      .led_b(tens_minutes_segment_leds[5]),
      .led_c(tens_minutes_segment_leds[4]),
      .led_d(tens_minutes_segment_leds[3]),
      .led_e(tens_minutes_segment_leds[2]),
      .led_f(tens_minutes_segment_leds[1]),
      .led_g(tens_minutes_segment_leds[0])
  );

  // RisingEdgeDetector edge_detector (
  //     .clk(your_clock_signal),
  //     .signal(your_input_signal),
  //     .detected_edge(edge_detected)
  // );

  wire CLK1Hz;
  clock_divider clock_divid (
      .clk(Clock),
      .reset(Reset),
      .CLK1Hz(CLK1Hz)
  );
  // always @(posedge Clock) begin
  //   if (Reset == 1'b1 && reset_reg == 1'b0) begin
  //     reset_reg <= 1'b1;
  //   end else begin
  //     reset_reg <= 1'b0;
  //   end
  // end
  
  always @(posedge Clock or posedge Reset) begin
    if (Reset) begin
      counter <= PERIOD;
      seconds = counter % 60;
      minutes = counter / 60;
      Alarm <= 1'b0;
      Shutdown <= 1'b0;
      Done <= 1'b0;
    end else begin
      if (counter == 0) begin
        
        if (Temp_Data >= 300) begin
          Alarm <= 1'b1;
          Shutdown <= 1'b1;
        end else if (Temp_Data >= 250) begin
          Alarm <= 1'b1;
          Shutdown <= 1'b0;
        end else begin
          Alarm <= 1'b0;
          Shutdown <= 1'b0;
        end
        Done <= 1'b1;
        counter <= PERIOD;
      end else begin
        Done <= 1'b1;
        seconds = counter % 60;
        minutes = counter / 60;
        if (minutes >= 10) begin
          minutes_tens  = 1;
          minutes_units = minutes - 10;
        end else begin
          minutes_tens  = 0;
          minutes_units = minutes;
        end
        if (seconds >= 50) begin
          seconds_tens  = 5;
          seconds_units = seconds - 50;
        end else if (seconds >= 40) begin
          seconds_tens  = 4;
          seconds_units = seconds - 40;
        end else if (seconds >= 30) begin
          seconds_tens  = 3;
          seconds_units = seconds - 30;
        end else if (seconds >= 20) begin
          seconds_tens  = 2;
          seconds_units = seconds - 20;
        end else if (seconds >= 10) begin
          seconds_tens  = 1;
          seconds_units = seconds - 10;
        end else begin
          seconds_tens  = 0;
          seconds_units = seconds;
        end
        counter <= counter - 1'b1;
        Done <= 1'b0;
      end
    end
  end
endmodule

module PipeTemp_Controller_tb;

  // Inputs
  reg Clock, Reset;
  reg [7:0] Temp_Data;

  // Outputs
  wire Alarm, Shutdown, Done;
  wire [6:0] units_seconds_segment_leds, tens_seconds_segment_leds;
  wire [6:0] units_minutes_segment_leds, tens_minutes_segment_leds;

  wire [3:0] minutes_tens, minutes_units;
  wire [3:0] seconds_tens, seconds_units;

  // Instantiate the Unit Under Test (UUT)
  PipeTemp_Controller UUT (
      .Clock(Clock),
      .Reset(Reset),
      .Temp_Data(Temp_Data),
      .Alarm(Alarm),
      .Shutdown(Shutdown),
      .Done(Done),
      .units_seconds_segment_leds(units_seconds_segment_leds),
      .tens_seconds_segment_leds(tens_seconds_segment_leds),
      .units_minutes_segment_leds(units_minutes_segment_leds),
      .tens_minutes_segment_leds(tens_minutes_segment_leds),
      .minutes_tens(minutes_tens),
      .minutes_units(minutes_units),
      .seconds_tens(seconds_tens),
      .seconds_units(seconds_units)
  );

  // Clock generation (50 MHz)
  initial begin
    Clock <= 1'b0;
    forever #10 Clock <= ~Clock;
  end

  // Stimulus (Test cases)
  initial begin
    Reset <= 1'b1;
    #20;  // Hold reset for 20 clock cycles

    Reset <= 1'b0;

    // Test case 1: Normal temperature
    Temp_Data <= 150;
    #1000;  // Run for 15 minutes

    // Test case 2: Alarm temperature
    Temp_Data <= 250;
    #1000;  // Wait for some time

    // Test case 3: Shutdown temperature
    Temp_Data <= 150;
    #1000;  // Wait for some time

    Reset <= 1'b0;

    $finish;
  end

  // Monitor outputs (Optional)
  always @(posedge Clock) begin
    if (Reset) begin
      // Do nothing on reset
    end else begin
      // Monitor and print the outputs here
      $display("Time: %d:%02d, Alarm: %b, Shutdown: %b, Done: %b", UUT.counter / 60,
               UUT.minutes_tens, UUT.minutes_units, UUT.seconds_tens, UUT.seconds_units,
               UUT.counter % 60, Alarm, Shutdown, Done);
    end
  end

endmodule

module RisingEdgeDetector (
    input clk,
    input signal,
    output reg detected_edge
);

  reg prev_signal;

  always @(posedge clk) begin
    prev_signal   <= signal;

    detected_edge <= (prev_signal == 1'b0) & (signal == 1'b1);
  end
endmodule

module decoder_7seg_anode (
    A,
    B,
    C,
    D,
    led_a,
    led_b,
    led_c,
    led_d,
    led_e,
    led_f,
    led_g
);
  input A, B, C, D;
  output led_a, led_b, led_c, led_d, led_e, led_f, led_g;
  assign led_a = (A | C | B & D | ~B & ~D);
  assign led_b = (~B | ~C & ~D | C & D);
  assign led_c = (B | ~C | D);
  assign led_d = (~B & ~D | C & ~D | B & ~C & D | ~B & C | A);
  assign led_e = (~B & ~D | C & ~D);
  assign led_f = (A | ~C & ~D | B & ~C | B & ~D);
  assign led_g = (A | B & ~C | ~B & C | C & ~D);
endmodule

module clock_divider (
    clk,
    reset,
    CLK1Hz
);
  input clk, reset;
  output CLK1Hz;
  reg CLK1Hz;
  reg [24:0] count;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      count  <= 0;
      CLK1Hz <= 0;
    end else begin
      if (count < 25_000_000) count <= count + 1;
      else begin
        CLK1Hz = ~CLK1Hz;
        count <= 0;
      end
    end
  end
endmodule
