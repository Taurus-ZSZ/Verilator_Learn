module top #(
    parameter D_WIDTH = 8
)(
    input logic rst_n,
    input logic clk  ,
    input logic [D_WIDTH-1:0] i_a,
    input logic [D_WIDTH-1:0] i_b,
    output logic              o_co,
    output logic [D_WIDTH:0]  o_sum
);

logic [7:0] cnt;

always_ff @( posedge clk or negedge rst_n) begin : cnt_add
    if (!rst_n) begin
        cnt <= 'd0;
    end else begin
        if (cnt ==8'h80) begin
            cnt <= 'd0;
        end else begin
            cnt <= cnt + 1;
        end
    end 
end

adder_01 #(
    .D_WIDTH(D_WIDTH)
)u_adder_01(
    .i_a(i_a),
    .i_b(i_b),
    .o_co(o_co),
    .o_sum(o_sum)
);

endmodule
