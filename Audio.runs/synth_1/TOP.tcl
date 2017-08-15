# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7z020clg484-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir D:/audio/Audio/Audio.cache/wt [current_project]
set_property parent.project_path D:/audio/Audio/Audio.xpr [current_project]
set_property XPM_LIBRARIES XPM_CDC [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
set_property ip_output_repo d:/audio/Audio/Audio.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files -quiet d:/audio/Audio/Audio.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.dcp
set_property used_in_implementation false [get_files d:/audio/Audio/Audio.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.dcp]
read_vhdl -library xil_defaultlib {
  D:/audio/Audio/Audio.srcs/sources_1/new/typedefs.vhd
  D:/audio/Audio/Audio.srcs/sources_1/new/CEGEN48k.vhd
  D:/audio/Audio/Audio.srcs/sources_1/new/waveformGen.vhd
  D:/audio/Audio/Audio.srcs/sources_1/new/Mixer.vhd
  D:/audio/Audio/Audio.srcs/sources_1/new/Filter.vhd
  D:/audio/Audio/Audio.srcs/sources_1/new/DAC.vhd
  D:/audio/Audio/Audio.srcs/sources_1/new/components.vhd
  D:/audio/Audio/Audio.srcs/sources_1/new/TOP.vhd
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc D:/audio/Audio/Audio.srcs/constrs_1/imports/Downloads/zedboard_master_XDC_RevC_D_v3.xdc
set_property used_in_implementation false [get_files D:/audio/Audio/Audio.srcs/constrs_1/imports/Downloads/zedboard_master_XDC_RevC_D_v3.xdc]


synth_design -top TOP -part xc7z020clg484-1


write_checkpoint -force -noxdef TOP.dcp

catch { report_utilization -file TOP_utilization_synth.rpt -pb TOP_utilization_synth.pb }
