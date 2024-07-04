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
    input  wire clk_i,
    input  wire rst_i,
    input  wire start_cordic_i,
    input  wire cnt_tick_i,
    output reg  sel_o,
    output reg  ena1_o,
    output reg  ena2_o,
    output reg  ena_cnt_o,
    output reg  done_tick_cordic_o
);

  localparam [2:0] IDLE        = 3'd0,
                   INIT_COND1  = 3'd1,
                   INIT_COND2  = 3'd2,
                   INC_ADDR    = 3'd3,
                   ITER_STAGE1 = 3'd4,
                   ITER_STAGE2 = 3'd5;

  reg [3:0] state_reg, state_next;

  always @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      state_reg <= IDLE;
    end else begin
      state_reg <= state_next;
    end
  end

  always @(*) begin
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
        sel_o  = 1'b0;
        ena1_o = 1'b1;
        state_next = INIT_COND2;
      end
      INIT_COND2: begin
        sel_o  = 1'b0;
        ena2_o = 1'b1;
        state_next = INC_ADDR;
      end
      INC_ADDR: begin
        ena_cnt_o = 1'b1;
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
        state_next = 'x;
      end
    endcase
  end
endmodule
