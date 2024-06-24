#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

MAIN(){
  if [[ $1 ]]
  then
    RETURN_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE $1 = atomic_number")
  else
    echo "Please provide an element as an argument."
  fi
}

MAIN