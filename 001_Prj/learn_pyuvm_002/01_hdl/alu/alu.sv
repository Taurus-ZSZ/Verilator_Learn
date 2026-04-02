module alu(
  input logic clk     ,
  input logic reset_n ,
  input logic start   ,
  input logic [7:0] a ,
  input logic [7:0] b ,
  input logic [2:0] op,

  output logic done   ,
  output logic [15:0] result
  );

localparam  = ADD=3'b001,
              AND=3'b010,
              XOR=3'b011,
              MUL=3'b100;
logic done_1,done_2,done_3;
logic [15:0] mult_result_comb ;
always_ff @(posedge clk or negedge reset_n) begin 
  if (reset_n) begin
    done   <='d0;
    done_1 <='d0;
    done_2 <='d0;
    done_3 <='d0;
    result <='d0;
  end else begin
    case(op)
      ADD: begin
        if (start) begin
          done   <= 1'b1;
          result <= a+b ;
        end else begin
          done   <= 1'b0;
          result <= 0;
        end
      end
      AND: begin
        if (start) begin
          done <= 1'b1;
          result <= {8'd0,(a & b)};
        end else begin
          done <= 1'b0;
          result <= 'd0;
        end
      end
      XOR: begin
        if (start) begin
          done <= 1'b1;
          result <= {8'd0,(a | b)};
        end else begin
          done <= 1'b0;
          result <= 'd0;
        end
      end
      MUL: begin
        if (start) begin
          done_3 <= 1'b1;
          done_2 <= done_3;
          done_1 <= done_2;
          done <= !done_1 & done_2;
          if (!done_1 & done_2) begin
            result <= mult_result_comb;
          end else begin
            result <= 'd0;
          end
        end else begin
          done_3 <= 1'b0;
          done_2 <= 1'b0;
          done_1 <= 1'b0;
          done <= 1'b0;
          result <= 'd0;
        end
      end
    endcase 
  end
end

always_comb begin : mul_block
  if((op == MUL)&&(start)) begin
    mult_result_comb = a*b;
  end else begin
    mult_result_comb = 'd0;
  end
end
endmodule
