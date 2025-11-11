##############################################################
# Main Task
# Convert all inputs to format[1] & SDC format,
# and pass to synthesis tool Yosys
#
# Sub Tasks
# Create variables
# Check if required files and directories exist
# Read constraints file for csv and convert to SDC format
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

  
