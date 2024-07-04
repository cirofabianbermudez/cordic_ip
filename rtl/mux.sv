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

module mux #(
  parameter int Width = 16
)(
  input  wire [Width-1:0] x1_i,
  input  wire [Width-1:0] x2_i,
  input  wire             sel_i,
  output wire [Width-1:0] xn_o
);

  assign xn_o = (sel_i) ? x2_i : x1_i;

endmodule
