set repo_root [file normalize [file join [file dirname [info script]] ..]]
set proj_name "FPGA_Camera"
set part      "xc7S50csga324-1";# change to your FPGA part

catch {close_project}
create_project $proj_name $repo_root/build -part $part -force

# Design sources (add_files accepts directories)
add_files -fileset sources_1 $repo_root/src

# Testbenches
if {[file isdirectory $repo_root/sim]} {
    add_files -fileset sim_1 $repo_root/sim
}

# Constraints
if {[file isdirectory $repo_root/constrs]} {
    add_files -fileset constrs_1 $repo_root/constrs
}

set_property top my_top_module [get_filesets sources_1]
set_property top my_testbench  [get_filesets sim_1]

update_compile_order -fileset sources_1