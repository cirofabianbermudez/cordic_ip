///////////////////////////////////////////////////////////////////////////////////
// [Filename]       -
// [Project]        -
// [Author]         -
// [Language]       -
// [Created]        -
// [Description]    -
// [Notes]          -
//                  d_i = 1 -> Z es negativo
//                  d_i = 0 -> Z es positivo
// [Status]         -
///////////////////////////////////////////////////////////////////////////////////

module sum_sel #(
  parameter int Width = 16
) (
  input  wire signed [Width-1:0] x_i,
  input  wire signed [Width-1:0] y_i,
  input  wire                    d_i,
  output wire signed [Width-1:0] xn_o
);

  assign xn_o = (d_i) ? x_i + y_i : x_i - y_i;

endmodule
