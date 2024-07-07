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

module cordic #(
    parameter int Width = 16
) (
    input logic clk_i,
    input logic rst_i,
    input logic start_cordic_i,
    input logic [Width-1:0] x0_i,
    input logic [Width-1:0] y0_i,
    input logic [Width-1:0] z0_i,
    output logic [Width-1:0] xn_o,
    output logic [Width-1:0] yn_o,
    output logic [Width-1:0] zn_o,
    output logic done_tick_cordic_o
);

  // Sign signal
  wire di;

  // Mux signals
  wire [Width-1:0] xn, yn, zn;
  wire [Width-1:0] xn_mux, yn_mux, zn_mux;
  wire sel;

  // Stage 1 register signals
  wire [Width-1:0] xn_aux, yn_aux, zn_aux, rom_aux;
  wire ena1;

  // Stage 2 register signals
  wire ena2;

  // Counter signals
  wire ena_cnt;
  localparam logic [3:0] MaxIter = 'd15;
  wire [3:0] addr;
  wire cnt_tick;

  // ROM signals
  wire [Width-1:0] rom_data;

  // Barral shifter signals
  wire [Width-1:0] xn_shift, yn_shift;

  // Sum signals
  wire [Width-1:0] xn_sum, yn_sum;

  // di logic
  assign di = zn_aux[Width-1];

  ////////////////////////////////////////
  //        FSM CORDIC
  ////////////////////////////////////////
  fsm_cordic fsm_cordic_inst (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .start_cordic_i(start_cordic_i),
      .cnt_tick_i(cnt_tick),
      .sel_o(sel),
      .ena1_o(ena1),
      .ena2_o(ena2),
      .ena_cnt_o(ena_cnt),
      .done_tick_cordic_o(done_tick_cordic_o)
  );


  ////////////////////////////////////////
  //          Address counter
  ////////////////////////////////////////
  counter #(
      .Width(4)
  ) addr_counter (
      .clk_i (clk_i),
      .rst_i (rst_i),
      .ena_i (ena_cnt),
      .max_i (MaxIter),
      .cnt_o (addr),
      .tick_o(cnt_tick)
  );

  ////////////////////////////////////////
  //            Z logic
  ////////////////////////////////////////
  mux #(
      .Width(Width)
  ) mux_z (
      .x1_i (z0_i),
      .x2_i (zn),
      .sel_i(sel),
      .xn_o (zn_mux)
  );

  reg_ena #(
      .Width(Width)
  ) reg_z (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .ena_i(ena1),
      .d_i  (zn_mux),
      .q_o  (zn_aux)
  );

  rom_cordic #(
      .Width(Width)
  ) angle_rom (
      .addr_i(addr),
      .data_o(rom_data)
  );

  reg_ena #(
      .Width(Width)
  ) reg_rom (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .ena_i(ena1),
      .d_i  (rom_data),
      .q_o  (rom_aux)
  );

  adder_sel #(
      .Width(Width)
  ) sum_z (
      .x_i (zn_aux),
      .y_i (rom_aux),
      .d_i (di),
      .xn_o(zn)
  );

  ////////////////////////////////////////
  //            X logic
  ////////////////////////////////////////
  mux #(
      .Width(Width)
  ) mux_x (
      .x1_i (x0_i),
      .x2_i (xn),
      .sel_i(sel),
      .xn_o (xn_mux)
  );
  reg_ena #(
      .Width(Width)
  ) reg_x (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .ena_i(ena1),
      .d_i  (xn_mux),
      .q_o  (xn_aux)
  );
  barrel_shifter #(
      .Width(Width)
  ) shifter_x (
      .x_i(xn_aux),
      .amount_i(addr),
      .y_o(xn_shift)
  );
  adder_sel #(
      .Width(Width)
  ) sum_x (
      .x_i (xn_aux),
      .y_i (yn_shift),
      .d_i (di),
      .xn_o(xn_sum)
  );
  reg_ena #(
      .Width(Width)
  ) reg_xn (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .ena_i(ena2),
      .d_i  (xn_sum),
      .q_o  (xn)
  );

  ////////////////////////////////////////
  //            y logic
  ////////////////////////////////////////
  mux #(
      .Width(Width)
  ) mux_y (
      .x1_i (y0_i),
      .x2_i (yn),
      .sel_i(sel),
      .xn_o (yn_mux)
  );

  reg_ena #(
      .Width(Width)
  ) reg_y (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .ena_i(ena1),
      .d_i  (yn_mux),
      .q_o  (yn_aux)
  );

  barrel_shifter #(
      .Width(Width)
  ) shifter_y (
      .x_i(yn_aux),
      .amount_i(addr),
      .y_o(yn_shift)
  );

  adder_sel #(
      .Width(Width)
  ) sum_y (
      .x_i (yn_aux),
      .y_i (xn_shift),
      .d_i (~di),
      .xn_o(yn_sum)
  );

  reg_ena #(
      .Width(Width)
  ) reg_yn (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .ena_i(ena2),
      .d_i  (yn_sum),
      .q_o  (yn)
  );

  assign xn_o = xn;
  assign yn_o = yn;
  assign zn_o = zn;

endmodule
