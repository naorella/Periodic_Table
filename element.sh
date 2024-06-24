#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

MAIN(){
  if [[ $1 ]]
  #if argument provided
  then
    #check to see if its an atomic number
    RETURN_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE $1 = atomic_number")
    if [[ -z $RETURN_RESULT ]]
    #if not then
    then
      #check to see if its a symbol
      RETURN_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE '$1' = symbol")
      if [[ -z $RETURN_RESULT ]]
      #if not then
      then
        #check to see if its a name
        RETURN_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE '$1' = name")
      fi
    fi
  else
    echo "Please provide an element as an argument."
  fi
}

MAIN