#!/bin/bash
# EXIT CODES
# 0 - all good
# 1 - no arguments given
# 2 - database file not found
# 3 - User aborted/invalid search term
# 4 - User cancelled update
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
echo ""
if test $# -gt 1 ; then
  echo "Enter the number corresponding to the entry you want to update"
  echo "or enter any letter to cancel."
  echo ""
  i=1
  for line in $@ ; do
    echo "$i. ${line//":"/", "}"
    i=$((i+1))
  done
  echo -n "Number: "
  read num
  if [[ $num =~ ^[0-9]+$ ]] && [ $num -gt 0 ] && [ $num -le $# ]; then
    updateme=$(eval "echo \$$num")
  else
    echo "Invalid input! Exiting..."
    exit 3
  fi
elif test $# -eq 1 ; then
  echo ${1//":"/", "}
  echo ""
  echo "Are you sure you want to update this entry?"
  echo -n "yes or no? "
  read answer
  case $answer in
    [Yy]* ) updateme=$1;;
    [Nn]* ) exit 4;;
    * ) echo "Invalid input."; exit 3;;
  esac
else
  echo "No records containing your text was found."
  exit 5
fi

grep -iv -- $updateme $database > mytempfile

fields=$(head -n 1 $database)
IFS=':'
set -- $fields
num_fields=$#

echo ""
echo "Choose the field you want to update:"
i=1
set -- $updateme
for field in $updateme ; do
  echo "$i. $field"
  i=$((i+1))
done
echo -n "Number: "
read num
if [[ $num =~ ^[0-9]+$ ]] && [ $num -gt 0 ] && [ $num -le $# ]; then
  old=$(eval "echo \$$num")
  echo -n "Update ($old): "
  read new
  i=1
  for colu in $updateme ; do
    if test $i -eq $num ; then
      colu=$new
    fi
    if test $i -lt $num_fields ; then
      entry="$entry$colu:"
    else
      entry="$entry$colu"
    fi
    i=$((i+1))
  done
else
  echo "Invalid input! Exiting..."
  exit 3  
fi
IFS=" "
echo $entry >> mytempfile
mv mytempfile $database

echo "Record successfully updated!"
echo ""
