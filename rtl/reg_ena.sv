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

module reg_ena #(
    parameter int Width = 16
) (
    input  wire             clk_i,
    input  wire             rst_i,
    input  wire             ena_i,
    input  wire [Width-1:0] d_i,
    output reg  [Width-1:0] q_o
);

  always @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      q_o <= 'd0;
    end else if (ena_i) begin
      q_o <= d_i;
    end
  end

endmodule
