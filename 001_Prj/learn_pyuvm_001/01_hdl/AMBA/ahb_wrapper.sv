module ahb_wrapper #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 32
  ) (
    // global siangal 
    input logic HCLK  ,
    input logic HRESETn ,
    
    input logic HSELx ,
    //address and control siangal
    input logic HWRITE  ,
    input logic HREADY  ,
    input logic [2:0] HSIZE ,
    input logic [2:0] HBURST, 
    input logic [3:0] HPROT,
    input logic [1:0] HTRANS  ,
    input logic HMASTLOCK ,
    input logic [ADDR_WIDTH-1:0] HADDR  ,
    input logic [DATA_WIDTH-1:0] HWDATA ,
    
    input logic READY_CTRL,
    
    output logic HREADYOUT  ,
    output logic HRESP      ,
    output logic [DATA_WIDTH-1:0] HRDATA
); 
//===================================================================
//=============== AMBA AHB Slave
//===================================================================
// global siangal 

  //logic HSELx ;
  ////address and control siangal
  //logic HWRITE  ;
  //logic HREADY  ;
  //logic [2:0] HSIZE ;
  //logic [2:0] HBURST; 
  //logic [3:0] HPROT;
  //logic [1:0] HTRANS  ;
  //logic HMASTLOCK ;
  //logic [ADDR_WIDTH-1:0] HADDR  ;
  //logic [DATA_WIDTH-1:0] HWDATA ;

  //logic READY_CTRL;

  //logic HREADYOUT  ;
  //logic HRESP      ;
  //logic [DATA_WIDTH-1:0] HRDATA;


ahb_slave #(
  .DATA_WIDTH (DATA_WIDTH),
  .ADDR_WIDTH (ADDR_WIDTH)
)u1_ahb_slave(
  // global siangal 
  .HCLK    (HCLK),
  .HRESETn (HRESETn),

  .HSELx   (HSELx),
  //address and control siangal
  .HWRITE   (HWRITE   ) ,
  .HREADY   (HREADY   ) ,
  .HSIZE    (HSIZE    ) ,
  .HBURST   (HBURST   ) , 
  .HPROT    (HPROT    ) ,
  .HTRANS   (HTRANS   ) ,
  .HMASTLOCK(HMASTLOCK),
  .HADDR    (HADDR    ),
  .HWDATA   (HWDATA   ),

  .READY_CTRL(READY_CTRL),
                        
  .HREADYOUT (HREADYOUT ) ,
  .HRESP     (HRESP     ) ,
  .HRDATA    (HRDATA    )
  );

//===================================================================
//=============== AMBA APB
//===================================================================
    logic                        PCLK    ;
    logic                        PRESETn ;
    logic                        PSEL    ;
    logic                        PENABLE ;
    logic                        PWRITE  ;
    logic [31:0]                 PADDR   ;
    logic [31:0]                 PWDATA  ;
    logic [31:0]                 PRDATA  ;
    logic                        PREADY  ;
    logic                        PSLVERR ;

assign PCLK    = HCLK;
assign PRESETn = HRESETn;

test_apb_wrapper u_test_apb_wrapper(
    .PCLK   (PCLK   ),
    .PRESETn(PRESETn),
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
