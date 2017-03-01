#!/bin/bash
# EXIT CODES
# 0 - all good
# 1 - no arguments given
# 2 - database file not found
# 3 - User aborted/invalid search term
# 5 - no records found

if test "$1" = "" ; then
  echo "Usage: ./find.sh <database file>"
  echo "       ./find.sh <database file> <search term>"
  exit 1
fi

if ! test -f $1 ; then
  echo "Database file '$1' not found."
  exit 2
fi

fields=$(head -n 1 $1)
database=$(grep -iv -- $fields $1)

if test "$2" = "" ; then
  echo -n "Enter a search term: "
  read term
  echo ""
else
  term=$2 # command line input support
fi

if test "$term" = "" || test "$term" = ":" ; then # to prevent silliness
  echo "Aborted."
  exit 3
fi

term=${term//":"/""} # prevent extra silliness

if ! test "$3" = "raw" ; then
  num=$(echo "$database" | grep -ic -- "$term") # count lines with term
  if test $num = 0 ; then               # check if any record was found
    echo "No record containing your text was found."
    exit 5
  fi
fi

if ! test "$3" = "raw" ; then
  if test $num -gt 1 ; then             # check if num is greater than 1
    echo "$num records were found."     # plural
  else                                  # else statement
    echo "$num record was found."       # singular
  fi
fi

gout=$(echo "$database" | grep -i -- "$term") # store all records found
IFS=$'\n'                             # to split lines
for line in $gout ; do
  if test "$3" = "raw" ; then
    echo $line
  else
    echo ${line//":"/", "}              # Replace ':' with ', ' then echo
  fi
done

if test "$3" = "" ; then
  echo ""
fi
