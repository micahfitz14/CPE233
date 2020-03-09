@echo off
REM ****************************************************************************
REM Vivado (TM) v2018.2 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Mon Mar 09 12:23:52 -0700 2020
REM SW Build 2258646 on Thu Jun 14 20:03:12 MDT 2018
REM
REM Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
call xsim Otter_Wrapper_TB_behav -key {Behavioral:sim_1:Functional:Otter_Wrapper_TB} -tclbatch Otter_Wrapper_TB.tcl -view C:/Users/micah/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sim_1/imports/project_1/pc_mem_sim_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
