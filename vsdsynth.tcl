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
# Pass this script to Yosys
##############################################################

# Autocreate variables
# set filename [lindex $argv 0]

# Function to open a CSV file and set variables
proc processCsvAndSetVariables {filePath} {
    # Check if the file exists
    if {![file exists $filePath]} {
        puts "Error: File '$filePath' not found."
        return
    }

    # Open the CSV file for reading
    set fileId [open $filePath r]

    # Read the file line by line
    while {[gets $fileId line] >= 0} {
        # Skip empty lines
        if {[string trim $line] eq ""} {
            continue
        }

        # Split the line by comma to get columns
        # Handle cases where values might contain commas if enclosed in quotes (simple approach here)
        set columns [split $line ","]

        # Ensure there are at least two columns
        if {[llength $columns] >= 2} {
            set varName [lindex $columns 0]
            set varValue [lindex $columns 1]

            # Remove leading/trailing whitespace from variable name and value
            set varName [string trim $varName]
            set varValue [string trim $varValue]

            # Basic validation for variable name (Tcl variable names usually start with a letter or underscore)
            # You might want more robust validation depending on your needs.
            if {[string match {^[a-zA-Z_][a-zA-Z0-9_]*$} $varName]} {
                # Set the variable
                set $varName $varValue
                puts "Set variable: $varName = $varValue"
            } else {
                puts "Warning: Invalid variable name '$varName' found in CSV. Skipping row."
            }
        } else {
            puts "Warning: Skipping line due to insufficient columns: $line"
        }
    }

    # Close the file
    close $fileId
}

# --- Example Usage ---

# 1. Create a dummy CSV file for demonstration
set dummyCsvContent {
var_name_1,value_1
variable_2,another_value
my_setting,some_data
host_ip,192.168.1.1
port_number,8080
last_item,final_value
}

set csvFileName "example.csv"
set outFile [open $csvFileName w]
puts $outFile $dummyCsvContent
close $outFile

puts "--- Processing '$csvFileName' ---"
processCsvAndSetVariables $csvFileName

puts "\n--- Verifying Variables ---"
# You can now access the variables directly
if {[info exists var_name_1]} {
    puts "Value of var_name_1: $var_name_1"
}
if {[info exists host_ip]} {
    puts "Value of host_ip: $host_ip"
}
if {[info exists non_existent_var]} {
    puts "Value of non_existent_var: $non_existent_var"
} else {
    puts "non_existent_var is not set."
}

# Clean up the dummy CSV file
file delete $csvFileName

# Create variables manually
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

#---------------------------------------------------------------------------------------------#
#------------------------------ Run synthesis script using yosys -----------------------------#
#---------------------------------------------------------------------------------------------#
if {[catch { exec yosys -s $OutputDirectory/$DesignName.ys >& $OutputDirectory/$DesignName.synthesis.log} msg]} {
  puts "\nError: Synthesis failed due to errors.  Please refer to log $OutputDirectory/$DesignName.synthesis.log for errors"
  exit
} else {
    puts "\nInfo: Synthesis finished successfully"
  }
}
puts "\nInfo: Please refer to log $OutputDirectory/$DesignName.synthesis.log"




