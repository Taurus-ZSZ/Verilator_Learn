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

parameter HBURST_SINGLE = 3'b000,
          HBURST_INCR   = 3'b001,
          HBURST_WRAP4  = 3'b010,
          HBURST_INCR4  = 3'b011,
          HBURST_WRAP8  = 3'b100,
          HBURST_INCR8  = 3'b101,
          HBURST_WRAP16 = 3'b110,
          HBURST_INCR16 = 3'b111;
  

logic [1:0] CS,NS;
logic hrd_en,hwr_en;
logic burst_undef_l_en;
logic mbusy ;
logic valid ;
logic write ;
logic [ADDR_WIDTH-1:0] address;

logic [4:0] beat_num;
logic [4:0] beat_cnt;

assign hrd_en = HREADY & HSELx & (!HWRITE) ;
assign hwr_en = HREADY & HSELx & HWRITE ;

always_ff @(posedge HCLK or negedge HRESETn) begin 
  if (!HRESETn) begin
    CS <= IDLE;
  end else begin
    CS <= NS;
  end
end

logic trans_nonseq_flag;
logic trans_idle_flag;
logic trans_seq_flag;
logic trans_busy_flag;

assign trans_nonseq_flag = HSELx & (HTRANS == HTRANS_NONSEQ);
assign trans_idle_flag   = HSELx & (HTRANS == HTRANS_IDLE);
assign trans_seq_flag    = HSELx & (HTRANS == HTRANS_SEQ);
assign trans_busy_flag   = HSELx & (HTRANS == HTRANS_BUSY);;


always_comb (*) begin : state_block

  case (CS)
    IDLE : begin
      if ((hrd_en | hwr_en) &(trans_nonseq_flag)) begin
        NS = TRANS_PROC; 
      end else begin
        NS = IDLE;
      end
    end
    
    TRANS_PROC : begin
      if ()
    end 
    
    TRANS_ERR : begin

    end
    
    default : 
  endcase
  
end

always_ff @(posedge HCLK or negedge HRESETn) begin 
  if (!HRESETn) begin
    <= 'd0;
  end else begin
    case (CS)
      
      default : 
    endcase
  end
end

always_ff @(posedge HCLK or negedge HRESETn) begin  
  if (HRESETn) begin
    beat_num <= 'd0;
    mbusy    <= 1'b0;
    burst_undef_l_en<= 1'b0;
  end else begin
    //trans first transfer  address phase get trans info
    if ((hwr_en | hrd_en) & (trans_nonseq_flag)) begin 
      mbusy   <= 1'b0;
      valid   <= 1'b1;
      write   <= HWRITE; 
      address <= HADDR ; //get base start address 
      case (HBURST) 
        HBURST_INCR:begin
          beat_nun <= 0;
        end
        HBURST_SINGLE: begin
          beat_num <= 1;
        end
        HBURST_INCR4,HBURST_WRAP4 :begin
          beat_num <= 'd4;
        end 
        HBURST_INCR8,HBURST_WRAP8 :begin
          beat_num <= 'd8;
        end
        HBURST_INCR16,HBURST_WRAP16 :begin
          beat_num <= 'd16;
        end

        default : 
      endcase
      if (HBURST == HBURST_INCR) begin
        beat_num <= 'd0;
        burst_undef_l_en <= 1'b1;
      end else begin
        burst_undef_l_en <= 1'b0;
      end
    end else if (trans_busy_flag) begin
      mbusy   <= 1'b1;
      if (HREADY) begin
        address <= HADDR ;
        write   <= HWRITE;
      end else begin
        address <= HADDR ;
        write   <= HWRITE;
      end 
    end else if (trans_seq_flag) begin
      if (HREADY & burst_undef_l_en) begin
        address <= address + N;
      end else begin

      end 
    end
  end
  
end


endmodule
