
///////////////////////////////////////////////////////////////////////////////////
// [Filename]       -
// [Project]        -
// [Author]         -
// [Language]       SystemVerilog 2017 [IEEE Std. 1800-2017]
// [Created]        -
// [Description]    -
// [Notes]          -
// [Status]         -
///////////////////////////////////////////////////////////////////////////////////

module counter #(
    parameter int Width = 4
) (
    input  logic             clk_i,
    input  logic             rst_i,
    input  logic             ena_i,
    input  logic [Width-1:0] max_i,
    output logic [Width-1:0] cnt_o,
    output logic             tick_o
);

  logic [Width-1:0] counter_q, counter_d;
  logic counter_done;

  always_ff @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      counter_q <= 'd0;
    end else if (ena_i) begin
      counter_q <= counter_d;
    end
  end

  assign counter_done = (counter_q == max_i - 'd1) ? 1'b1 : 1'b0;
  assign counter_d = (counter_done) ? 'd0 : counter_q + 'd1;

  assign cnt_o = counter_q;
  assign tick_o = counter_done;

endmodule
