module ahb2apb_bridge #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 32
)(
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

  output logic HREADYOUT  ,
  output logic HRESP      ,
  output logic [DATA_WIDTH-1:0] HRDATA
  );

 //state 
  //IDLE 
  //NONSEQ -> BUSY -> SEQ 

parameter HTRANS_IDLE   = 2'b00,
          HTRANS_BUSY   = 2'b01,
          HTRANS_NONSEQ = 2'b10,
          HTRANS_SEQ    = 2'b11;

parameter HBURST_SINGLE = 3'b000,
          HBURST_INCR   = 3'b001,
          HBURST_WRAP4  = 3'b010,
          HBURST_INCR4  = 3'b011,
          HBURST_WRAP8  = 3'b100,
          HBURST_INCR8  = 3'b101,
          HBURST_WRAP16 = 3'b110,
          HBURST_INCR16 = 3'b111;

