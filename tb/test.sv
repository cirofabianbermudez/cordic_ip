module test (
    cordic_if.dvr vif
);
  
  localparam FACTOR = 2.0**-8.0;
  real value;
  
  initial begin
    $display("Begin Of Simulation.");
    reset();
    normal();
    multiple();
    $display("End Of Simulation.");
    $finish;
  end

  task reset();
    vif.rst_i = 1'b1;
    vif.x0_i = 16'b0000_0000_1001_1011; // 0.6054687500
    vif.y0_i = 16'b0000_0000_0000_0000;
    vif.z0_i = 16'b0001_0100_0000_0000; // 20.0000000000
    
    vif.start_cordic_i = 1'b0;
    repeat (2) @(vif.cb);
    vif.cb.rst_i <= 1'b0;
    repeat (2) @(vif.cb);
  endtask : reset

  task normal();
    value = 20.0;
    vif.z0_i <= convert_real_to_fixed_point(value);
    vif.cb.start_cordic_i <= 1'b1;
    @(vif.cb);
    vif.cb.start_cordic_i <= 1'b0;
    $display("[%t]: z0      = %15.10f,  %b", $realtime, $itor(vif.z0_i*FACTOR), vif.z0_i);
    repeat (60) @(vif.cb);
    $display("[%t]: cos(z0) = %15.10f, sin(z0) = %15.10f", $realtime, $itor(vif.cb.xn_o*FACTOR), $itor(vif.cb.yn_o*FACTOR));
  endtask : normal
  
  task multiple();
    value = 10.0;
    repeat(15) begin  
      vif.z0_i <= convert_real_to_fixed_point(value);
      vif.cb.start_cordic_i <= 1'b1;
      @(vif.cb);
      vif.cb.start_cordic_i <= 1'b0;
      $display("[%t]: z0      = %15.10f,  %b", $realtime, $itor(vif.z0_i*FACTOR), vif.z0_i);
      repeat (60) @(vif.cb);
      $display("[%t]: cos(z0) = %15.10f, sin(z0) = %15.10f", $realtime, $itor(vif.cb.xn_o*FACTOR), $itor(vif.cb.yn_o*FACTOR));
      value = value + 5.0;
    end
  endtask : multiple
  
  function logic signed [15:0] convert_real_to_fixed_point(input real in_value);
    int integer_bits = 7;
    int fractional_bits = 8;
    int total_bits = integer_bits + fractional_bits;
    real scaling_factor = 2.0 ** fractional_bits;
    real scaled_value;
    scaled_value = in_value * scaling_factor;
    return $rtoi(scaled_value);
  endfunction

endmodule : test
