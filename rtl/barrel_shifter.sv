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

module barrel_shifter #(
    parameter int Width = 16
) (
    input  wire [Width-1:0] x_i,
    input  wire [      2:0] amount_i,
    output wire [Width-1:0] y_o
);

  wire [Width-1:0] s0, s1, s2;
  wire sign;

  assign sign = x_i[Width-1];

  assign s0 = (amount_i[0]) ? {{1{sign}}, x_i[Width-1:1]} : x_i;
  assign s1 = (amount_i[1]) ? {{2{sign}}, s0[Widht-1:2]} : s0;
  assign s2 = (amount_i[2]) ? {{4{sign}}, s1[Widht-1:4]} : s1;
  assign y = (amount_i[3]) ? {{8{sign}}, s2[Widht-1:8]} : s2;

endmodule
