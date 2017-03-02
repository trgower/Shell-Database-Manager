#!/bin/bash
# EXIT CODES
# 0 - all good
# 1 - no argument given
# 2 - database file not found
# 3 - user aborted/input error
# 4 - duplicate record! NO, ok? It's pointless...

if test "$1" = "" ; then
  echo "Usage: ./add.sh <database file>"
  exit 1
fi

if ! test -f $1 ; then
  echo "Database file '$1' not found."
  exit 2
fi

database=$1

fields=$(head -n 1 $database)
tIFS=$IFS
IFS=':'
set -- $fields
num_fields=$#
i=1
echo ""
for field in $fields ; do
  IFS=$tIFS

  echo -n "Enter data for field '$field': "
  read input

  input=${input//":"/""}  # to prevent sillllliiinessss
  input=${input//","/""}  # so that it doesn't look confusing when listing

  if test "$input" = "" ; then
    echo "Aborted. Invalid input."
    echo ""
    exit 3
  fi

  if test $i -lt $num_fields ; then
    entry="$entry$input:"
  else
    entry="$entry$input"
  fi

  i=$((i+1))
done

found=$(grep -i -- "$entry" $database)
IFS=$'\n'
set -- $found
if test $# -gt 0 ; then
  echo "Duplicate record found! You cannot have duplicate records."
  echo ""
  exit 4
fi
IFS=' ' # SAFETY FIRST

echo $entry >> $database
echo "Successfully added new record!"
echo ""
