module adder_01 # (
    parameter D_WIDTH = 8
)
(
    input logic [D_WIDTH-1:0]   i_a,
    input logic [D_WIDTH-1:0]   i_b,

    output logic                o_co,
    output logic [D_WIDTH:0]    o_sum
);

assign o_sum = {i_a[D_WIDTH-1],i_a}+{i_b[D_WIDTH-1],i_b};
assign o_co = o_sum[D_WIDTH];



endmodule
