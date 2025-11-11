

# Create variables
puts "DesignName = $DesignName"
puts "OutputDirectory = $OutputDirectory"
puts "NetlistDirectory = $NetlistDirectory"
puts "EarlyLibraryPath = $EarlyLibraryPath"
puts "LateLibraryPath = $LateLibraryPath"
puts "ConstraintsFile = $ConstraintsFile"

# Check if required directories and files as specified in csv exist
if  {! [file exists $LateLibraryPath]} {
  puts "\nError: cannot file late cell library in path $LateLibraryPath. Exiting..."
  exit
} else {
    puts "\nInfo: Late cell library found in path $LateLibraryPath"
  }

if {! [file isdirectory $OoutputDirectory]} {
  puts "\nInfo: Cannot fine output directory $OutputDirectory. Creating $OutputDirectory"
  file mkdir $OutputDirectory
} else {
    puts "\nInfo: Output directory found in path $OutputDirectory"
  }

