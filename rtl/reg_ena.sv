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
    input  logic             clk_i,
    input  logic             rst_i,
    input  logic             ena_i,
    input  logic [Width-1:0] d_i,
    output logic [Width-1:0] q_o
);

  always_ff @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      q_o <= 'd0;
    end else if (ena_i) begin
      q_o <= d_i;
    end
  end

endmodule
