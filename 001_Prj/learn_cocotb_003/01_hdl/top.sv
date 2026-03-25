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
    //=============== AMBA AHB
    //===================================================================
  parameter DATA_WIDTH = 32;
  parameter ADDR_WIDTH = 32;
 
  logic HCLK    ;
  logic HRESETn ;
  logic HSELx   ;
  //address and control siangal
  logic HWRITE  ;
  logic HREADY  ;
  logic [2:0] HSIZE ;
  logic [2:0] HBURST; 
  logic [3:0] HPROT;
  logic [1:0] HTRANS  ;
  logic HMASTLOCK ;
  logic [ADDR_WIDTH-1:0] HADDR  ;
  logic [DATA_WIDTH-1:0] HWDATA ;

  logic READY_CTRL;

  logic HREADYOUT  ;
  logic HRESP      ;
  logic [DATA_WIDTH-1:0] HRDATA;


//assign HCLK = clk;
//assign HRESETn= rst_n;

ahb_wrapper #(
  .DATA_WIDTH (DATA_WIDTH),
  .ADDR_WIDTH (ADDR_WIDTH)
  ) u_ahb_wrapper (
    .HCLK    (HCLK   ),
    .HRESETn (HRESETn),
    .HSELx   (HSELx  ),
  //address and control siangal
    .HWRITE   (HWRITE   ) ,
    .HREADY   (HREADY   ) ,
    .HSIZE    (HSIZE    ) ,
    .HBURST   (HBURST   ) , 
    .HPROT    (HPROT    ) ,
    .HTRANS   (HTRANS   ) ,
    .HMASTLOCK(HMASTLOCK) ,
    .HADDR    (HADDR    ) ,
    .HWDATA   (HWDATA   ) ,

    .READY_CTRL(READY_CTRL),
                          
    .HREADYOUT (HREADY ) ,
    //.HREADYOUT (HREADYOUT ) ,
    .HRESP     (HRESP     ) ,
    .HRDATA    (HRDATA    )
); 

endmodule
