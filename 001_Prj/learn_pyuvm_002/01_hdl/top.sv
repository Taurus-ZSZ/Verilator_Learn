module top #(
    parameter D_WIDTH = 8
) (
    input logic clk     ,
    input logic rst_n   ,

    input  logic [D_WIDTH-1:0]   A ,
    input  logic [D_WIDTH-1:0]   B ,
    input  logic [2:0]           OP,
    input  logic                 start,
    output logic                 done
);
alu u_alu(
    .clk    (clk    ) ,
    .reset_n(reset_n) ,
    .start  (start  ) ,
    .a      (A      ) ,
    .b      (B      ) ,
    .op     (OP     ) ,
 
    .done   (done   ) ,
    .result (result )  
  );  
 
endmodule
