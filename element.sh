#!/bin/bash
#Program to return queried information on periodic table elements

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
else
  ARG="$1"
  CHECK_QUERY=$($PSQL "SELECT name, symbol FROM elements WHERE symbol = '$ARG' OR name = '$ARG'")
  if [[ -z $CHECK_QUERY ]]
  then
    if [[ $ARG == [1-9] ]]
    then
    CHECK_QUERY_INT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = '$ARG'")
      if [[ -z $CHECK_QUERY_INT ]]
      then
        echo "I could not find that element in the database."
      else
        GET_ELEMENT_INT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM types FULL JOIN properties USING(type_id) FULL JOIN elements USING(atomic_number) WHERE atomic_number = '$ARG'")
        echo "$GET_ELEMENT_INT" | while read ATNUM BAR NAME BAR SYM BAR TYPE BAR ATMASS BAR MELT BAR BOIL
        do
          echo "The element with atomic number "$ATNUM" is "$NAME" ($SYM). It's a "$TYPE", with a mass of "$ATMASS" amu. "$NAME" has a melting point of "$MELT" celsius and a boiling point of "$BOIL" celsius."
        done
      fi
      
    else
      echo "I could not find that element in the database."
    fi

  else 
    GET_ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM types FULL JOIN properties USING(type_id) FULL JOIN elements USING(atomic_number) WHERE name = '$ARG' OR symbol = '$ARG'")
    echo "$GET_ELEMENT" | while read ATNUM BAR NAME BAR SYM BAR TYPE BAR ATMASS BAR MELT BAR BOIL
    do
      echo "The element with atomic number "$ATNUM" is "$NAME" ($SYM). It's a "$TYPE", with a mass of "$ATMASS" amu. "$NAME" has a melting point of "$MELT" celsius and a boiling point of "$BOIL" celsius."
    done
  fi
fi
