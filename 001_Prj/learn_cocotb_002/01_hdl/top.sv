module top #(
    parameter D_WIDTH = 8
) (
    input logic clk     ,
    input logic rst_n   ,

    input logic [D_WIDTH-1:0]   i_a,
    input logic [D_WIDTH-1:0]   i_b,

    output logic [D_WIDTH:0]    o_sum,
    output logic                o_flag
);

    counter #(
        .D_WIDTH(D_WIDTH)
    ) u_counter(
        .clk(clk),
        .rst_n(rst_n),
        .o_flag(o_flag)
    );

    assign o_sum = {i_a[D_WIDTH-1],i_a} + {i_b[D_WIDTH-1],i_b};

    //===================================================================
    //=============== AMBA APB
    //===================================================================

test_apb_wrapper u_test_apb_wrapper(
    .PCLK   (clk    ),
    .PRESETn(rst_n  ),
    .PSEL   (PSEL   ),
    .PENABLE(PENABLE),
    .PWRITE (PWRITE ),
    .PADDR  (PADDR  ),
    .PWDATA (PWDATA ),
    .PRDATA (PRDATA ),
    .PREADY (PREADY ),
    .PSLVERR(PSLVERR)
);

endmodule