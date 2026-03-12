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
    output logic [15:0] sel_dn_en    ,
    output logic [31:0] pwdin,


    output logic PREADY,
    output logic PRDATA,
    output logic PSLVERR     
);

assign PREADY  = 1'b1;
assign PSLVERR = 1'b0;
                                                                   
                                                                   
endmodule                                                          
