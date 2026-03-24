module ahb_slave #(
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

  input logic READY_CTRL,

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
parameter RESP_OKAY = 1'b0,
          RESP_ERROR= 1'b1;

logic [1:0] CS,NS;
logic hrd_en,hwr_en;
logic mbusy ;
logic valid ;
logic write ;
logic [ADDR_WIDTH-1:0] address;
logic [2:0] burst_d;

logic [4:0] beat_num;
logic [4:0] beat_cnt;

logic trans_err_flag;
logic last_beat_flag;

//===============================================
//============HREADYOUT assign===================
//===============================================
assign HREADYOUT = READY_CTRL;


assign hrd_en = HREADY & HSELx & (!HWRITE) ;
assign hwr_en = HREADY & HSELx & HWRITE ;

// buf HBURST
always_ff @(posedge HCLK or negedge HRESETn) begin 
  if (!HRESETn) begin
    burst_d <= 3'd0;
  end else begin
    if (HREADY) begin
      burst_d <= HBURST;
    end else begin
      burst_d <= HBURST;
    end
  end
end

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
      if (trans_idle_flag) begin
        if (burst_d == HBURST_SINGLE) begin //不允许在单次传输后+busy传输
          NS = TRANS_ERR;
        end else begin
          NS = IDLE;
        end
      end else if (trans_err_flag) begin
        NS = TRANS_ERR;
      end else begin
        NS = TRANS_PROC;
      end 
    end 
    
    TRANS_ERR : begin
      if (trans_idle_flag) begin
        NS = IDLE;
      end else if ((hrd_en | hwr_en) &(trans_nonseq_flag)) begin
        NS = TRANS_PROC; 
      end else begin
        NS = TRANS_ERR;
      end
    end
    
    default : NS = IDLE;
  endcase
  
end

always_ff @(posedge HCLK or negedge HRESETn) begin 
  if (!HRESETn) begin
    HRESP <= 1'd0;
  end else begin
    case (CS)
      IDLE :begin
        HRESP <= RESP_OKAY;
      end
      TRANS_PROC : begin
        HRESP <= RESP_OKAY;
      end
      TRANS_ERR : begin
          HRESP <= RESP_ERROR;
      end
      default : begin
        HRESP <= RESP_OKAY;
      end
    endcase
  end
end

always_ff @(posedge HCLK or negedge HRESETn) begin  
  if (HRESETn) begin
    beat_num <= 'd0;
    beat_cnt <= 'd0;
    mbusy    <= 1'b0;
    valid    <= 1'b0;
    write    <= 1'b0;
    address  <= 'd0;
    last_beat_flag <= 1'b0;
  end else begin
    //trans first transfer  address phase get trans info
    if ((hwr_en | hrd_en) & (trans_nonseq_flag)) begin //T0
      mbusy   <= 1'b0;
      valid   <= 1'b1;
      write   <= HWRITE; 
      address <= HADDR ; //get base start address 
      case (HBURST) 
        HBURST_SINGLE: begin
          beat_num <= 1;
          last_beat_flag <= 1'b1;
        end
        HBURST_INCR:begin
          beat_num <= 0;
          last_beat_flag <= 1'b0;
        end
        HBURST_INCR4,HBURST_WRAP4 :begin
          beat_num <= 'd4;
          last_beat_flag <= 1'b0;
        end 
        HBURST_INCR8,HBURST_WRAP8 :begin
          beat_num <= 'd8;
          last_beat_flag <= 1'b0;
        end
        HBURST_INCR16,HBURST_WRAP16 :begin
          beat_num <= 'd16;
          last_beat_flag <= 1'b0;
        end
        default : begin
          beat_num <= 'd16;
          last_beat_flag <= 1'b0;
        end
      endcase
    end else if (trans_seq_flag & HREADY) begin
      mbusy    <= 1'b0;
      if (last_beat_flag) begin
        trans_err_flag <= 1'b1;
        beat_cnt <= 'd0;
      end else begin
        address <= HADDR;
        if (beat_cnt == beat_num - 2) begin
          last_beat_flag <= 1'b1;
        end else begin
          last_beat_flag <= 1'b0;
        end
        beat_cnt <= beat_cnt + 1'b1;
        //for check address is error?
        //if( (HBURST == HBURST_WRAP4)
        //  ||(HBURST == HBURST_WRAP8)
        //  ||(HBURST == HBURST_WRAP16)) begin
        //  address <= address + N;
        //end else begin
        //  address <= address + ((32'd8) << (HSIZE));
        //end
      end

    end else if (trans_busy_flag & HREADY) begin
      mbusy   <= 1'b1;
      address <= HADDR ;
      write   <= HWRITE;
      if (burst_d == HBURST_SINGLE) begin
        trans_err_flag <= 1'b1;
      end 
    end else if (trans_idle_flag & HREADY) begin
      mbusy    <= 1'b0;
      address  <= HADDR ;
      beat_cnt <= 'd0;
      trans_err_flag <= 1'b0;
      last_beat_flag <= 1'b0;
    end
  end
end


endmodule
