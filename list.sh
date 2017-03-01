#!/bin/bash
# EXIT CODES
# 0 - all good
# 1 - no arguments given
# 2 - database file not found

if test "$1" = "" ; then
  echo "Usage: ./find.sh <database file>"
  exit 1
fi

if ! test -f $1 ; then
  echo "Database file '$1' not found."
  exit 2
fi

fields=$(head -n 1 $1)
database=$(grep -iv -- $fields $1)

echo ""
echo "All records in $1"

IFS=$'\n'                             # to split lines
i=1
for line in $database ; do
  echo $i. ${line//":"/", "}              # Replace ':' with ', ' then echo
  i=$((i+1))
done

echo ""
