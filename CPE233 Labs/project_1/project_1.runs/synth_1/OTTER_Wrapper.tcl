# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.cache/wt} [current_project]
set_property parent.project_path {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo {c:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_mem {{C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/otter_memory.mem}}
read_verilog -library xil_defaultlib -sv {
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/CU_DCDR.sv}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/CU_FSM.sv}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/reg_file_v_1_00.v}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/otter_memory_v1_05.sv}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/CathodeDriver.sv}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/SevSegDisp.sv}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/debounce_one_shot.sv}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/BCD.sv}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/clk_divider_nbit.sv}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/reg_nb.sv}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/CSR_v1_01.sv}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/OTTER_Wrapper_exp8.v}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/one_shot_bdir.v}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/dbounce_v1_00.sv}
}
read_verilog -library xil_defaultlib {
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/ALU.v}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/BRANCH_ADDR_GEN.v}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/IMMED_GEN.v}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/ProgramCounter.v}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/cntr_up_clr_nb.v}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/mux_2t1_nb.v}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/mux_4t1_nb.v}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/rca_nb.v}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/OTTER_MCU.v}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/BRANCH_COND_GEN.v}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/CLK_DIV_FS.v}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/univ_sseg.v}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/ram_single_port.v}
  {C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/sources_1/new/mux_8t1_nb.v}
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/constrs_1/new/Basys3_constraints.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/Ryan Madden/Documents/GitHub/CPE233/CPE233 Labs/project_1/project_1.srcs/constrs_1/new/Basys3_constraints.xdc}}]

set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top OTTER_Wrapper -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef OTTER_Wrapper.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file OTTER_Wrapper_utilization_synth.rpt -pb OTTER_Wrapper_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
