#!/bin/bash
# EXIT CODES
# 0 - all good
# 1 - no arguments given
# 2 - database file not found
# 3 - User aborted/invalid search term
# 5 - no records found

if test "$1" = "" ; then
  echo "Usage: ./cli.sh <database filepath>"
  exit 1
fi

if ! test -f $1 ; then
  echo "Database file '$1' not found."
  exit 2
fi

database=$1

while true ; do
  echo "a. Add a new record"
  echo "u. Update a record"
  echo "d. Delete a record"
  echo "f. Find a record"
  echo "x. Exit"
  echo ""
  echo -n "Command: "
  read cmd
  case $cmd in 
    'a' ) ./add.sh $database;;
    'u' ) echo "IN PROGRESS";;
    'd' ) ./delete.sh $database;;
    'f' ) ./find.sh $database;;
    'x' ) exit 0;;
    * ) echo "Unrecognized command."
  esac
done
