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
// Last modified Date:     2026/03/12 15:45:57 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2026/03/12 15:45:57 
// Version:                V1.0 
// TEXT NAME:              regblock.sv 
// PATH:                   /mnt/c/Work/my_work/Verilator/Verilator_Learn/001_Prj/learn_cocotb_002/01_hdl/AMBA/APB/regblock.sv 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module regblock(
    input                               clk                        ,
    input                               rst_n                      ,

    input  logic [31:0]                 pwdin,
    input  logic [15:0]                 sel_dn_en,
    output logic [31:0]                 test_cfg_0,
    output logic [31:0]                 test_cfg_1,
    output logic [31:0]                 test_cfg_2,
    output logic [31:0]                 test_cfg_3,
    output logic [31:0]                 test_cfg_4,
    output logic [31:0]                 test_cfg_5,
    output logic [31:0]                 test_cfg_6,
    output logic [31:0]                 test_cfg_7,
    output logic [31:0]                 test_cfg_8,
    output logic [31:0]                 test_cfg_9,
    output logic [31:0]                 test_cfg_10,
    output logic [31:0]                 test_cfg_11,
    output logic [31:0]                 test_cfg_12,
    output logic [31:0]                 test_cfg_13,
    output logic [31:0]                 test_cfg_14,
    output logic [31:0]                 test_cfg_15
);


always_ff @( posedge clk or negedge rst_n ) begin 
    if (!rst_n) begin
        test_cfg_0 <= 'd0;
    end else begin
        if (sel_dn_en[0]) begin
            test_cfg_0 <= pwdin;
        end
    end
end

always_ff @( posedge clk or negedge rst_n ) begin 
    if (!rst_n) begin
        test_cfg_1 <= 'd0;
    end else begin
        if (sel_dn_en[1]) begin
            test_cfg_1 <= pwdin;
        end
    end
end

always_ff @( posedge clk or negedge rst_n ) begin 
    if (!rst_n) begin
        test_cfg_2 <= 'd0;
    end else begin
        if (sel_dn_en[2]) begin
            test_cfg_2 <= pwdin;
        end
    end
end

always_ff @( posedge clk or negedge rst_n ) begin 
    if (!rst_n) begin
        test_cfg_3 <= 'd0;
    end else begin
        if (sel_dn_en[3]) begin
            test_cfg_3 <= pwdin;
        end
    end
end

always_ff @( posedge clk or negedge rst_n ) begin 
    if (!rst_n) begin
        test_cfg_4 <= 'd0;
    end else begin
        if (sel_dn_en[4]) begin
            test_cfg_4 <= pwdin;
        end
    end
end
always_ff @( posedge clk or negedge rst_n ) begin 
    if (!rst_n) begin
        test_cfg_5 <= 'd0;
    end else begin
        if (sel_dn_en[5]) begin
            test_cfg_5 <= pwdin;
        end
    end
end

always_ff @( posedge clk or negedge rst_n ) begin 
    if (!rst_n) begin
        test_cfg_6 <= 'd0;
    end else begin
        if (sel_dn_en[6]) begin
            test_cfg_6 <= pwdin;
        end
    end
end

always_ff @( posedge clk or negedge rst_n ) begin 
    if (!rst_n) begin
        test_cfg_7 <= 'd0;
    end else begin
        if (sel_dn_en[7]) begin
            test_cfg_7 <= pwdin;
        end
    end
end

always_ff @( posedge clk or negedge rst_n ) begin 
    if (!rst_n) begin
        test_cfg_8 <= 'd0;
    end else begin
        if (sel_dn_en[8]) begin
            test_cfg_8 <= pwdin;
        end
    end
end

always_ff @( posedge clk or negedge rst_n ) begin 
    if (!rst_n) begin
        test_cfg_9 <= 'd0;
    end else begin
        if (sel_dn_en[9]) begin
            test_cfg_9 <= pwdin;
        end
    end
end

always_ff @( posedge clk or negedge rst_n ) begin 
    if (!rst_n) begin
        test_cfg_10 <= 'd0;
    end else begin
        if (sel_dn_en[10]) begin
            test_cfg_10 <= pwdin;
        end
    end
end

always_ff @( posedge clk or negedge rst_n ) begin 
    if (!rst_n) begin
        test_cfg_11 <= 'd0;
    end else begin
        if (sel_dn_en[11]) begin
            test_cfg_11 <= pwdin;
        end
    end
end

always_ff @( posedge clk or negedge rst_n ) begin 
    if (!rst_n) begin
        test_cfg_12 <= 'd0;
    end else begin
        if (sel_dn_en[12]) begin
            test_cfg_12 <= pwdin;
        end
    end
end

always_ff @( posedge clk or negedge rst_n ) begin 
    if (!rst_n) begin
        test_cfg_13 <= 'd0;
    end else begin
        if (sel_dn_en[13]) begin
            test_cfg_13 <= pwdin;
        end
    end
end

always_ff @( posedge clk or negedge rst_n ) begin 
    if (!rst_n) begin
        test_cfg_14 <= 'd0;
    end else begin
        if (sel_dn_en[14]) begin
            test_cfg_14 <= pwdin;
        end
    end
end

always_ff @( posedge clk or negedge rst_n ) begin 
    if (!rst_n) begin
        test_cfg_15 <= 'd0;
    end else begin
        if (sel_dn_en[15]) begin
            test_cfg_15 <= pwdin;
        end
    end
end

endmodule                                                          
