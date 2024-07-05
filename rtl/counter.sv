
///////////////////////////////////////////////////////////////////////////////////
// [Filename]       -
// [Project]        -
// [Author]         -
// [Language]       -
// [Created]        -
// [Description]    -
// [Notes]          -
// [Status]         -
///////////////////////////////////////////////////////////////////////////////////

module counter #(
    parameter int Width = 4
) (
    input  wire             clk_i,
    input  wire             rst_i,
    input  wire             ena_i,
    input  wire [Width-1:0] max_i,
    output wire [Width-1:0] cnt_o,
    output wire             tick_o
);

  reg [Width-1:0] counter_q, counter_d;
  reg counter_done;

  always @(posedge clk_i, posedge rst_i) begin
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
