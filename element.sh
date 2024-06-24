#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

#the function that will retrieve and show the information
GET_INFO(){
  if [[ $1 ]]
    #if the argument we get is not empty
  then
    #rename variable for better readability
    ATOM_NUM=$1
    #get info from the properties table
    PROP_INFO=$($PSQL "SELECT * FROM properties WHERE atomic_number = $ATOM_NUM")
    #get info from the elements table
    ELEM_INFO=$($PSQL "SELECT * FROM elements WHERE atomic_number = $ATOM_NUM")

    #read both results and assign each column result a variable name
    read -r ELEM_NUM BAR ELEM_SYM BAR ELEM_NAME <<< $(echo "$ELEM_INFO")
    read -r ELEM_NUM BAR ELEM_WEIGHT BAR MELT BAR BOIL BAR TYPE_ID <<< $(echo "$PROP_INFO")
    
    #using TYPE_ID find the type on the types table
    TYPE_INFO=$($PSQL "SELECT * FROM types WHERE type_id = $TYPE_ID")
    #read the result to assign variables
    read -r TYPE_ID BAR ELEM_TYPE <<< $(echo "$TYPE_INFO")

    #combine all the info we have and format it into a sentence
    echo "The element with atomic number $ATOM_NUM is $ELEM_NAME ($ELEM_SYM). It's a $ELEM_TYPE, with a mass of $ELEM_WEIGHT amu. $ELEM_NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    fi
}

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
        if [[ -z $RETURN_RESULT ]]
          #if still nothing
        then
          #say we couldn't find it
          echo "I could not find that element in the database."
        fi
      fi
    fi
    #GET_INFO at end so we don't have to call it three times after each case
    #If nothing was found it will pass an empty variable
    GET_INFO $RETURN_RESULT
  else
    echo "Please provide an element as an argument."
  fi
}

MAIN $1