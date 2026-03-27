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
// Last modified Date:     2026/03/13 18:01:25 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2026/03/13 18:01:25 
// Version:                V1.0 
// TEXT NAME:              test_apb_wrapper.sv 
// PATH:                   /mnt/c/Work/my_work/Verilator/Verilator_Learn/001_Prj/learn_cocotb_002/01_hdl/AMBA/APB/test_apb_wrapper.sv 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module test_apb_wrapper(
    input                               PCLK    ,
    input                               PRESETn ,
    input  logic                        PSEL    ,
    input  logic                        PENABLE ,
    input  logic                        PWRITE  ,
    input  logic [31:0]                 PADDR   ,
    input  logic [31:0]                 PWDATA  ,
    output logic [31:0]                 PRDATA  ,
    output logic                        PREADY  ,
    output logic                        PSLVERR
);

logic [31:0] test_cfg_0 ;
logic [31:0] test_cfg_1 ;
logic [31:0] test_cfg_2 ;
logic [31:0] test_cfg_3 ;
logic [31:0] test_cfg_4 ;
logic [31:0] test_cfg_5 ;
logic [31:0] test_cfg_6 ;
logic [31:0] test_cfg_7 ;
logic [31:0] test_cfg_8 ;
logic [31:0] test_cfg_9 ;
logic [31:0] test_cfg_10;
logic [31:0] test_cfg_11;
logic [31:0] test_cfg_12;
logic [31:0] test_cfg_13;
logic [31:0] test_cfg_14;
logic [31:0] test_cfg_15;

logic [15:0] sel_dn_wren ;
logic [31:0] PWDATAIn    ;

apb_if u_apb_if(
    .PCLK        (PCLK) ,
    .PRESETn     (PRESETn) ,
    .PADDR       (PADDR) ,
    .PSEL        (PSEL) ,
    .PENABLE     (PENABLE) ,
    .PWRITE      (PWRITE) ,
    .PWDATA      (PWDATA) ,
    .test_cfg_0  (test_cfg_0 ),
    .test_cfg_1  (test_cfg_1 ),
    .test_cfg_2  (test_cfg_2 ),
    .test_cfg_3  (test_cfg_3 ),
    .test_cfg_4  (test_cfg_4 ),
    .test_cfg_5  (test_cfg_5 ),
    .test_cfg_6  (test_cfg_6 ),
    .test_cfg_7  (test_cfg_7 ),
    .test_cfg_8  (test_cfg_8 ),
    .test_cfg_9  (test_cfg_9 ),
    .test_cfg_10 (test_cfg_10) ,
    .test_cfg_11 (test_cfg_11) ,
    .test_cfg_12 (test_cfg_12) ,
    .test_cfg_13 (test_cfg_13) ,
    .test_cfg_14 (test_cfg_14) ,
    .test_cfg_15 (test_cfg_15) ,
    .sel_dn_wren (sel_dn_wren) ,
    .PWDATAIn    (PWDATAIn   ) ,

    .PREADY     (PREADY ),
    .PRDATA     (PRDATA ),
    .PSLVERR    (PSLVERR)     
);                                                               
regblock u_regblock(
    .clk        (PCLK   ),
    .rst_n      (PRESETn),

    .PWDATAIn   (PWDATAIn   ),
    .sel_dn_wren(sel_dn_wren  ),
    .test_cfg_0 (test_cfg_0 ),
    .test_cfg_1 (test_cfg_1 ),
    .test_cfg_2 (test_cfg_2 ),
    .test_cfg_3 (test_cfg_3 ),
    .test_cfg_4 (test_cfg_4 ),
    .test_cfg_5 (test_cfg_5 ),
    .test_cfg_6 (test_cfg_6 ),
    .test_cfg_7 (test_cfg_7 ),
    .test_cfg_8 (test_cfg_8 ),
    .test_cfg_9 (test_cfg_9 ),
    .test_cfg_10(test_cfg_10),
    .test_cfg_11(test_cfg_11),
    .test_cfg_12(test_cfg_12),
    .test_cfg_13(test_cfg_13),
    .test_cfg_14(test_cfg_14),
    .test_cfg_15(test_cfg_15)
);
                                                                  
endmodule                                                          
