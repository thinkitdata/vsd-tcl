#!/bin/tcsh -f
echo
echo
echo "blah blah blah banner message"
echo

set my_work_dir = `pwd`

#--------------------------------------------------------------------#
#----------------------- Tool initialization ------------------------#
#--------------------------------------------------------------------#

if ($#argv != 1) then
  echo "Info:  Please provide the csv file"
  exit 1
endif

if (! -f $argv[1] || $argv[1] == "-help") then
  if ($argv[1] != "-help") then
    echo "Error:  Cannot find csv file $argv[1].  Exiting..."
    exit 1
  else
    echo USAGE:  .//vsdsynth \<csv file\>
    exit 1
