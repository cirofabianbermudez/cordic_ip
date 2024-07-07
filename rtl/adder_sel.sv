///////////////////////////////////////////////////////////////////////////////////
// [Filename]       -
// [Project]        -
// [Author]         -
// [Language]       SystemVerilog 2017 [IEEE Std. 1800-2017]
// [Created]        -
// [Description]    -
// [Notes]          -
//                  d_i = 1 -> Z es negativo
//                  d_i = 0 -> Z es positivo
// [Status]         -
///////////////////////////////////////////////////////////////////////////////////

module adder_sel #(
    parameter int Width = 16
) (
    input  logic signed [Width-1:0] x_i,
    input  logic signed [Width-1:0] y_i,
    input  logic                    d_i,
    output logic signed [Width-1:0] xn_o
);

  assign xn_o = (d_i) ? x_i + y_i : x_i - y_i;

endmodule
