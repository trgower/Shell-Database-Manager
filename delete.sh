#!/bin/bash
# EXIT CODES
# 0 - all good
# 1 - no arguments given
# 2 - database file not found
# 3 - User aborted/invalid search term
# 4 - User cancelled delete
# 5 - no records found

if test "$1" = "" ; then
  echo "Usage: ./delete.sh <database file>"
  echo "       ./delete.sh <database file> <search term>"
  exit 1
fi

if ! test -f $1 ; then
  echo "Database file '$1' not found."
  exit 2
fi

database=$1

if test "$2" = "" ; then
  echo -n "Enter a search term: "
  read term
else
  term=$2 # command line input support
fi

if test "$term" = "" || test "$term" = ":" ; then # to prevent silliness
  echo "Aborted."
  exit 3
fi

term=${term//":"/""} # prevent extra silliness

result=$(./find.sh $1 $term raw)
IFS=$'\n'
set -- $result
if test $# -gt 1 ; then
  echo ""
  i=1
  for line in $@ ; do
    echo "$i. ${line//":"/", "}"
    i=$((i+1))
  done
  echo ""
  echo "Enter the number corresponding to the entry you want to delete"
  echo "or any letter to cancel."
  echo -n "Number: "
  read num
  if [[ $num =~ ^[0-9]+$ ]] && [ $num -gt 0 ] && [ $num -le $# ]; then
    deleteme=$(eval "echo \$$num")
  else
    echo "Invalid input! Exiting..."
    exit 3
  fi
elif test $# -eq 1 ; then
  echo ""
  echo ${1//":"/", "}
  echo ""
  echo "Are you sure you want to delete this entry?"
  echo -n "yes or no? "
  read answer
  case $answer in
    [Yy]* ) deleteme=$1;;
    [Nn]* ) exit 4;;
    * ) echo "Invalid input."; exit 3;;
  esac
else
  echo "No records containing your text was found."
  exit 5
fi

grep -iv -- $deleteme $database > mytempfile
mv mytempfile $database
