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
) (
    input  logic [Width-1:0] x1_i,
    input  logic [Width-1:0] x2_i,
    input  logic             sel_i,
    output logic [Width-1:0] xn_o
);

  assign xn_o = (sel_i) ? x2_i : x1_i;

endmodule
