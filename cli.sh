#!/bin/bash
# EXIT CODES
# 0 - all good
# 1 - no arguments given
# 2 - database file not found

if test "$1" = "" ; then
  echo "Usage: ./cli.sh <database filepath>"
  exit 1
fi

if ! test -f $1 ; then
  echo "Database file '$1' not found."
  exit 2
fi

database=$1

echo ""
echo "l. List all records"
echo "a. Add a new record"
echo "u. Update a current record"
echo "d. Delete a record"
echo "f. Search for a record"
echo "e. Exit"
while true ; do
  echo -n "Command: "
  read cmd
  case $cmd in
    [Ll] | [Ll][Ss] | [Ll][Ii][Ss][Tt] ) ./list.sh $database;;
    [Aa] | [Aa][Dd][Dd] ) ./add.sh $database;;
    [Uu] | [Uu][Pp][Dd][Aa][Tt][Ee]) ./update.sh $database;;
    [Dd] | [Dd][Ee][Ll][Ee][Tt][Ee]) ./delete.sh $database;;
    [Ff] | [Ff][Ii][Nn][Dd]) ./find.sh $database;;
    [Ee] | [Ee][Xx][Ii][Tt]) exit 0;;
    * ) echo "Unrecognized command."
  esac
done
