##############################################################
# Main Task
# Convert all inputs to format[1] & SDC format,
# and pass to synthesis tool Yosys
#
# Sub Tasks
# Create variables
# Check if required files and directories exist
# Read constraints file for csv and convert to SDC format
# Read all files in netlist directory ==> NEED TO DO
# Create main synthesis script in format[2]
#
##############################################################

# Create variables
puts "DesignName = $DesignName"
puts "OutputDirectory = $OutputDirectory"
puts "NetlistDirectory = $NetlistDirectory"
puts "EarlyLibraryPath = $EarlyLibraryPath"
puts "LateLibraryPath = $LateLibraryPath"
puts "ConstraintsFile = $ConstraintsFile"

# Check if required directories and files as specified in csv exist
if {! [file isdirectory $OoutputDirectory]} {
  puts "\nInfo: Cannot find output directory $OutputDirectory. Creating $OutputDirectory"
  file mkdir $OutputDirectory
} else {
    puts "\nInfo: Output directory found in path $OutputDirectory"
  }
if {! [file isdirectory $NetlistDirectory]} {
  puts "\nInfo: Cannot find RTL netlist directory $NetlistDirectory. Exiting..."
  exit
} else {
    puts "\nInfo: RTL netlist directory found in path $NetlistDirectory"
  }
if  {! [file exists $EarlyLibraryPath]} {
  puts "\nError: cannot find early cell library in path $EarlyLibraryPath. Exiting..."
  exit
} else {
    puts "\nInfo: Early cell library found in path $EarlyLibraryPath"
  } 
if  {! [file exists $LateLibraryPath]} {
  puts "\nError: cannot find late cell library in path $LateLibraryPath. Exiting..."
  exit
} else {
    puts "\nInfo: Late cell library found in path $LateLibraryPath"
  }  
if  {! [file exists $ConstraintsFile]} {
  puts "\nError: cannot find constraints file in path $ConstraintsFile. Exiting..."
  exit
} else {
    puts "\nInfo: Constraints file found in path $ConstraintsFile"
  }
  
# Read all files in netlist directory
set netlist [glob -dir $NetlistDirectory *.v]
foreach f $netlist {
  set data $f
  puts -nonewline $fieId "\nread_verilog $f"
}
puts -nonewline $fileId "\nhierarchy -check"
close $fileId

# Create main synthesis script in format[2]
puts -nonewline $fileId "\nhiearchy -top $DesignName"
puts -nonewline $fileId "\nsynth -top $DesignName"
puts -nonewline $fileId "\nsplitnets -ports -format __\proc; memory; opt; fsm; opt\ntechmap; opt\ndifflibmap -liberty  ${LateLibraryPath}"
puts -nonewline $fileId "\nabc -liberty ${LateLibraryPath}"
puts -nonewline $fileId "\nflatten"
puts -nonewline $fileId "\nclean -purge\niopadmap -outpad BUFX2 A:Y -bits\nopt\nclean"
puts -nonewline $fileId "\nwrite_verilog $OutputDirectory/$DesignName.synth.v"
close $fileId
puts "\nInfo: Synthesis script created and can be accessed from path $OutputDirectory/$DesignName.ys"


