module apb_slave #(
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
  

logic [1:0] CS,NS;

always_ff @(posedge HCLK or negedge HRESETn) begin 
  if (!HRESETn) begin
    
  end else begin
    
  end
  
end


endmodule
