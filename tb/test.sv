module test (
    cordic_if vif
);

  int  fractional_bits = 8;
  int  integer_bits = 7;
  int  total_bits = integer_bits + fractional_bits + 1;
  real RAD = $acos(-1.0) / 180.0;
  real value;
  real cos_error;
  real sin_error;


  initial begin
    $display("Begin Of Simulation.");
    display_setup();
    reset();
    normal();
    multiple();
    $display("End Of Simulation.");
    $finish;
  end


  task automatic reset();
    vif.rst_i = 1'b1;
    vif.x0_i = 16'b0000_0000_1001_1011;  // 0.6054687500
    vif.y0_i = 16'b0000_0000_0000_0000;
    vif.z0_i = 16'b0001_0100_0000_0000;  // 20.0000000000
    vif.start_cordic_i = 1'b0;
    repeat (2) @(vif.cb);
    vif.cb.rst_i <= 1'b0;
    repeat (2) @(vif.cb);
  endtask : reset


  task automatic normal();
    value = 20.0;
    vif.z0_i <= real_to_fixed(value, fractional_bits);
    vif.cb.start_cordic_i <= 1'b1;
    @(vif.cb);
    vif.cb.start_cordic_i <= 1'b0;
    $display("[%t]: z0      = %15.10f,  %b", $realtime, fixed_to_real(vif.z0_i, fractional_bits), vif.z0_i);
    wait (vif.cb.done_tick_cordic_o != 1);
    @(vif.cb iff (vif.cb.done_tick_cordic_o == 1));
    @(vif.cb);
    $display("[%t]: cos(z0) = %15.10f, sin(z0) = %15.10f [MEASURED]", $realtime, fixed_to_real(vif.xn_o, fractional_bits), fixed_to_real(vif.yn_o, fractional_bits));
    $display("[%t]: cos(z0) = %15.10f, sin(z0) = %15.10f [EXPECTED]", $realtime, $cos(value*RAD), $sin(value*RAD));
    cos_error = abs_value( ( fixed_to_real(vif.xn_o, fractional_bits) - $cos(value*RAD) ) );
    sin_error = abs_value( ( fixed_to_real(vif.yn_o, fractional_bits) - $sin(value*RAD) ) );
    $display("[%t]: cos_err = %15.10f, sin_err = %15.10f [MEASURED_ERROR]", $realtime, cos_error, sin_error);
  endtask : normal


  task automatic multiple();
    value = 0.0;
    repeat (19) begin
      vif.z0_i <= real_to_fixed(value, fractional_bits);
      vif.cb.start_cordic_i <= 1'b1;
      @(vif.cb);
      vif.cb.start_cordic_i <= 1'b0;
      $display("[%t]: z0      = %15.10f,  %b", $realtime, fixed_to_real(vif.z0_i, fractional_bits), vif.z0_i);
      wait (vif.cb.done_tick_cordic_o != 1);
      @(vif.cb iff (vif.cb.done_tick_cordic_o == 1));
      @(vif.cb);
      $display("[%t]: cos(z0) = %15.10f, sin(z0) = %15.10f [MEASURED]", $realtime, fixed_to_real(vif.xn_o, fractional_bits), fixed_to_real(vif.yn_o, fractional_bits));
      $display("[%t]: cos(z0) = %15.10f, sin(z0) = %15.10f [EXPECTED]", $realtime, $cos(value*RAD), $sin(value*RAD));
      cos_error = abs_value( ( fixed_to_real(vif.xn_o, fractional_bits) - $cos(value*RAD) ) );
      sin_error = abs_value( ( fixed_to_real(vif.yn_o, fractional_bits) - $sin(value*RAD) ) );
      $display("[%t]: cos_err = %15.10f, sin_err = %15.10f [MEASURED_ERROR]", $realtime, cos_error, sin_error);
      value = value + 5.0;
    end
  endtask : multiple


  function automatic logic signed [15:0] real_to_fixed(input real in_value, real fractional_bits);
    real scaling_factor = 2.0 ** fractional_bits;
    real scaled_value;
    scaled_value = in_value * scaling_factor;
    return $rtoi(scaled_value);
  endfunction : real_to_fixed


  function automatic real fixed_to_real(input logic signed [15:0] in_value, real fractional_bits);
    real scaling_factor = 2.0 ** -fractional_bits;
    real scaled_value;
    scaled_value = $itor(in_value) * scaling_factor;
    return scaled_value;
  endfunction : fixed_to_real


  function automatic real abs_value(input real x);
    return (x < 0.0) ? -x : x;
  endfunction


  task automatic display_setup();
    $display("========================================================================");
    $display("Fixed point representation: A(%2d, %2d)", integer_bits, fractional_bits);
    $display("sign_bit: %2d, int_bits: %2d, frac_bits: %2d", 1, integer_bits, fractional_bits);
    $display("arq_bits: %2d", total_bits );
    $display("========================================================================");
  endtask : display_setup

endmodule : test
