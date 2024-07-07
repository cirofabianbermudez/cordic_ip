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

module fsm_cordic (
    input  logic clk_i,
    input  logic rst_i,
    input  logic start_cordic_i,
    input  logic cnt_tick_i,
    output logic sel_o,
    output logic ena1_o,
    output logic ena2_o,
    output logic ena_cnt_o,
    output logic done_tick_cordic_o
);

  typedef enum {
    IDLE,
    INIT_COND1,
    INIT_COND2,
    INC_ADDR,
    ITER_STAGE1,
    ITER_STAGE2,
    XXX
  } state_type_e;

  state_type_e state_reg, state_next;

  always_ff @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      state_reg <= IDLE;
    end else begin
      state_reg <= state_next;
    end
  end

  always_comb begin
    state_next         = state_reg;
    done_tick_cordic_o = 1'b0;
    sel_o              = 1'b1;
    ena1_o             = 1'b0;
    ena2_o             = 1'b0;
    ena_cnt_o          = 1'b0;
    case (state_reg)
      IDLE: begin
        sel_o = 1'b0;
        if (start_cordic_i) begin
          state_next = INIT_COND1;
        end
      end
      INIT_COND1: begin
        sel_o = 1'b0;
        ena1_o = 1'b1;
        state_next = INIT_COND2;
      end
      INIT_COND2: begin
        sel_o = 1'b0;
        ena2_o = 1'b1;
        state_next = INC_ADDR;
      end
      INC_ADDR: begin
        ena_cnt_o  = 1'b1;
        state_next = ITER_STAGE1;
      end
      ITER_STAGE1: begin
        ena1_o = 1'b1;
        state_next = ITER_STAGE2;
      end
      ITER_STAGE2: begin
        ena2_o = 1'b1;
        if (cnt_tick_i) begin
          done_tick_cordic_o = 1'b1;
          state_next = IDLE;
        end else begin
          state_next = INC_ADDR;
        end
      end
      default: begin
        state_next = XXX;
      end
    endcase
  end
endmodule
