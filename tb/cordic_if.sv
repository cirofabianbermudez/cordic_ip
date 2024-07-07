interface cordic_if #(
    parameter int Width = 16
) (
    input logic clk_i
);

  logic rst_i;
  logic start_cordic_i;
  logic [Width-1:0] x0_i;
  logic [Width-1:0] y0_i;
  logic [Width-1:0] z0_i;
  logic [Width-1:0] xn_o;
  logic [Width-1:0] yn_o;
  logic [Width-1:0] zn_o;
  logic done_tick_cordic_o;

  clocking cb @(posedge clk_i);
    default input #1ns output #5ns;
    output rst_i;
    output start_cordic_i;
    output x0_i;
    output y0_i;
    output z0_i;
    input xn_o;
    input yn_o;
    input zn_o;
    input done_tick_cordic_o;
  endclocking

  modport dvr(clocking cb, output rst_i, x0_i, y0_i, z0_i, start_cordic_i);
  modport mon(clocking cb, input xn_o, yn_o, zn_o, done_tick_cordic_o);

endinterface : cordic_if
