#!/bin/bash

if test "$1" = "" ; then              # Check if 1st argument exists
  echo "You must enter a search term!"
  exit
fi

num=$(grep -ic -- "$1" database)      # count all lines containing text
if test $num = 0 ; then               # check if any record was found
  echo "No record containing your text was found."
  exit
fi

if test $num -gt 1 ; then             # check if num is greater than 1
  echo "$num records were found."     # plural
else                                  # else statement
  echo "$num record was found."       # singular
fi

gout=$(grep -i -- "$1" database)      # store all records found in variable
USRIFS=$IFS
IFS=$'\n'                             # Used to split lines properly
for line in $gout ; do                # loop through each line
  echo ${line//":"/", "}              # Replace ':' with ', ' then echo
done
IFS=$USRIFS                           # set back to normal
