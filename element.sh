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
    ATOM_NUM=$RETURN_RESULT
    PROP_INFO=$($PSQL "SELECT * FROM properties WHERE atomic_number = $ATOM_NUM")
    ELEM_INFO=$($PSQL "SELECT * FROM elements WHERE atomic_number = $ATOM_NUM")
    read -r ELEM_NUM BAR ELEM_SYM BAR ELEM_NAME <<< $(echo "$ELEM_INFO")
    read -r ELEM_NUM BAR ELEM_TYPE BAR ELEM_WEIGHT BAR BOIL BAR MELT TYPE_ID <<< $(echo "$PROP_INFO")

    echo "$ELEM_NUM $ELEM_SYM $ELEM_NAME"

  else
    echo "Please provide an element as an argument."
  fi
}

MAIN $1