catch {close_project}

set repo_root "C:/GitHub/Digital_Logic_camera_project"
puts "repo_root exists: [file isdirectory $repo_root]"
puts "Top-level contents: [glob -nocomplain -tails -directory $repo_root *]"

set part "xc7s50csga324-1"
create_project my_project $repo_root/build -part $part -force

set sv_files [glob -nocomplain -recursive -directory $repo_root/src *.sv *.v *.vhd *.svh]
puts "Found [llength $sv_files] source files in src"

if {[llength $sv_files] > 0} {
    add_files -fileset sources_1 $sv_files
} else {
    puts "WARNING: no source files found, check the folder name above"
}

update_compile_order -fileset sources_1