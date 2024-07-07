`timescale 1ns / 100ps

module tb;

  localparam int Width = 16;

  // Clock signal
  parameter time CLK_PERIOD = 10ns;
  logic clk_i = 0;
  always #(CLK_PERIOD / 2) clk_i = ~clk_i;

  // Interface
  cordic_if #(.Width(Width)) vif (clk_i);

  // Test
  test top_test (vif);

  // Instantiation
  cordic #(
      .Width(Width)
  ) dut (
      .clk_i(vif.clk_i),
      .rst_i(vif.rst_i),
      .start_cordic_i(vif.start_cordic_i),
      .x0_i(vif.x0_i),
      .y0_i(vif.y0_i),
      .z0_i(vif.z0_i),
      .xn_o(vif.xn_o),
      .yn_o(vif.yn_o),
      .zn_o(vif.zn_o),
      .done_tick_cordic_o(vif.done_tick_cordic_o)
  );

  initial begin
    $timeformat(-9, 1, "ns", 10);
  end

endmodule
