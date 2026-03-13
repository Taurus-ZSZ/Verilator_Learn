`timescale 1ns / 1ps 
//****************************************VSCODE PLUG-IN**********************************// 
//---------------------------------------------------------------------------------------- 
// IDE :                   VSCODE      
// VSCODE plug-in version: Verilog-Hdl-Format-3.6.20250614
// VSCODE plug-in author : Jiang Percy 
//---------------------------------------------------------------------------------------- 
//****************************************Copyright (c)***********************************// 
// Copyright(C)            COMPANY_NAME
// All rights reserved      
// File name:               
// Last modified Date:     2026/03/12 16:02:50 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2026/03/12 16:02:50 
// Version:                V1.0 
// TEXT NAME:              apb_if.sv 
// PATH:                   /mnt/c/Work/my_work/Verilator/Verilator_Learn/001_Prj/learn_cocotb_002/01_hdl/AMBA/APB/apb_if.sv 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module apb_if(
    input                               PCLK                        ,
    input                               PRESETn                      ,
    input logic [31:0]                  PADDR,
    input logic                         PSEL,
    input logic PENABLE ,
    input logic PWRITE  ,
    input logic [31:0]  PWDATA,

    input logic [31:0]  test_cfg_0  ,
    input logic [31:0]  test_cfg_1  ,
    input logic [31:0]  test_cfg_2  ,
    input logic [31:0]  test_cfg_3  ,
    input logic [31:0]  test_cfg_4  ,
    input logic [31:0]  test_cfg_5  ,
    input logic [31:0]  test_cfg_6  ,
    input logic [31:0]  test_cfg_7  ,
    input logic [31:0]  test_cfg_8  ,
    input logic [31:0]  test_cfg_9  ,
    input logic [31:0]  test_cfg_10  ,
    input logic [31:0]  test_cfg_11  ,
    input logic [31:0]  test_cfg_12  ,
    input logic [31:0]  test_cfg_13  ,
    input logic [31:0]  test_cfg_14  ,
    input logic [31:0]  test_cfg_15  ,
    output logic [15:0] sel_dn_wren    ,
    output logic [31:0] PWDATAIn,

    output logic PREADY,
    output logic [31:0] PRDATA,
    output logic PSLVERR     
);

logic [31:0] GatedPADDR;
logic apb_wren;
logic apb_rden;
logic [15:0] sel_dn_rden;
assign PREADY  = 1'b1;
assign PSLVERR = 1'b0;

assign GatedPADDR = PSEL ? PADDR : 32'd0;
assign PWDATAIn   = (PSEL & PWRITE) ? PWDATA : 32'd0;

assign apb_wren =  PSEL & PWRITE & PENABLE & PREADY;
assign apb_rden =  PSEL & !PWRITE ;

assign sel_dn_wren[0]  = apb_wren & (GatedPADDR == 32'd0);
assign sel_dn_wren[1]  = apb_wren & (GatedPADDR == 32'd1);
assign sel_dn_wren[2]  = apb_wren & (GatedPADDR == 32'd2);
assign sel_dn_wren[3]  = apb_wren & (GatedPADDR == 32'd3);
assign sel_dn_wren[4]  = apb_wren & (GatedPADDR == 32'd4);
assign sel_dn_wren[5]  = apb_wren & (GatedPADDR == 32'd5);
assign sel_dn_wren[6]  = apb_wren & (GatedPADDR == 32'd6);
assign sel_dn_wren[7]  = apb_wren & (GatedPADDR == 32'd7);
assign sel_dn_wren[8]  = apb_wren & (GatedPADDR == 32'd8);
assign sel_dn_wren[9]  = apb_wren & (GatedPADDR == 32'd9);
assign sel_dn_wren[10] = apb_wren & (GatedPADDR == 32'd10);
assign sel_dn_wren[11] = apb_wren & (GatedPADDR == 32'd11);
assign sel_dn_wren[12] = apb_wren & (GatedPADDR == 32'd12);
assign sel_dn_wren[13] = apb_wren & (GatedPADDR == 32'd13);
assign sel_dn_wren[14] = apb_wren & (GatedPADDR == 32'd14);
assign sel_dn_wren[15] = apb_wren & (GatedPADDR == 32'd15);

assign sel_dn_rden[0]  = apb_rden & (GatedPADDR == 32'd0);
assign sel_dn_rden[1]  = apb_rden & (GatedPADDR == 32'd1);
assign sel_dn_rden[2]  = apb_rden & (GatedPADDR == 32'd2);
assign sel_dn_rden[3]  = apb_rden & (GatedPADDR == 32'd3);
assign sel_dn_rden[4]  = apb_rden & (GatedPADDR == 32'd4);
assign sel_dn_rden[5]  = apb_rden & (GatedPADDR == 32'd5);
assign sel_dn_rden[6]  = apb_rden & (GatedPADDR == 32'd6);
assign sel_dn_rden[7]  = apb_rden & (GatedPADDR == 32'd7);
assign sel_dn_rden[8]  = apb_rden & (GatedPADDR == 32'd8);
assign sel_dn_rden[9]  = apb_rden & (GatedPADDR == 32'd9);
assign sel_dn_rden[10] = apb_rden & (GatedPADDR == 32'd10);
assign sel_dn_rden[11] = apb_rden & (GatedPADDR == 32'd11);
assign sel_dn_rden[12] = apb_rden & (GatedPADDR == 32'd12);
assign sel_dn_rden[13] = apb_rden & (GatedPADDR == 32'd13);
assign sel_dn_rden[14] = apb_rden & (GatedPADDR == 32'd14);
assign sel_dn_rden[15] = apb_rden & (GatedPADDR == 32'd15);

logic  [31:0] NEXT_PRDATA;
assign NEXT_PRDATA = sel_dn_rden[0] ? test_cfg_0 :
                  sel_dn_rden[1] ? test_cfg_1 :
                  sel_dn_rden[2] ? test_cfg_2 :
                  sel_dn_rden[3] ? test_cfg_3 :
                  sel_dn_rden[4] ? test_cfg_4 :
                  sel_dn_rden[5] ? test_cfg_5 :
                  sel_dn_rden[6] ? test_cfg_6 :
                  sel_dn_rden[7] ? test_cfg_7 :
                  sel_dn_rden[8] ? test_cfg_8 :
                  sel_dn_rden[9] ? test_cfg_9 :
                  sel_dn_rden[10] ? test_cfg_10 :
                  sel_dn_rden[11] ? test_cfg_11 :
                  sel_dn_rden[12] ? test_cfg_12 :
                  sel_dn_rden[13] ? test_cfg_13 :
                  sel_dn_rden[14] ? test_cfg_14 :
                  sel_dn_rden[14] ? test_cfg_15 :
                  32'd0;

always_ff @( posedge PCLK or negedge PRESETn ) begin 
    if (!PRESETn) begin
        PRDATA <= 'd0;
    end else begin
        PRDATA <= NEXT_PRDATA;
    end
end
endmodule                                                          
