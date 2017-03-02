#!/bin/bash
# EXIT CODES
# 0 - all good
# 1 - no arguments given
# 2 - database file not found
# 3 - User aborted/invalid search term
# 5 - no records found

# Check for proper parameters
if test "$1" = "" ; then
  echo "Usage: ./find.sh <database file>"
  echo "       ./find.sh <database file> <search term>"
  exit 1
fi

# Check if database file exists
if ! test -f $1 ; then                  # if $1 is NOT a file or doesn't exist
  echo "Database file '$1' not found."
  exit 2
fi

fields=$(head -n 1 $1)      # Grab the first line of the database file
database=$(grep -iv -- $fields $1)    # Grab all the lines that aren't the first

if test "$2" = "" ; then    # Check if search term is in parameter
  echo -n "Enter a search term: "
  read term
  echo ""
else
  term=$2 # command line input support
fi

if test "$term" = "" || test "$term" = ":" ; then # to prevent silliness
  echo "Aborted."
  echo ""
  exit 3
fi

term=${term//":"/""} # prevent extra silliness
raw=$3
gout=$(echo "$database" | grep -i -- "$term") # store all records found
IFS=$'\n'                             # to split lines
set -- $gout                          # set lines as parameters
if ! test "$raw" = "raw" ; then       # For delete and update
  num=$#
  if test $num = 0 ; then               # check if any record was found
    echo "No record containing your text was found."
    exit 5
  fi
fi

if ! test "$raw" = "raw" ; then         # For delete and update
  if test $num -gt 1 ; then             # check if num is greater than 1
    echo "$num records were found."     # plural
  else                                  # else statement
    echo "$num record was found."       # singular
  fi
fi

for line in $@ ; do                     # Loop through all parameters
  if test "$raw" = "raw" ; then         # For delete and update
    echo $line
  else
    echo ${line//":"/", "}              # Replace ':' with ', ' then echo
  fi
done

if test "$raw" = "" ; then
  echo ""
fi
