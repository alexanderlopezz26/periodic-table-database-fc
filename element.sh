#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  
  #If number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    INFO_RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties 
    USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
    
  #If symbol
  elif [[ $1 =~ ^[a-zA-Z]{1,2}$ ]]
  then
    INFO_RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties 
    USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol ILIKE '$1'")
  
  #If name
  else
    INFO_RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties 
    USING(atomic_number) INNER JOIN types USING(type_id) WHERE name ILIKE '$1'")
  fi
  
  #if INFO_RESULT valid echo
  if [[ -z $INFO_RESULT ]]
  then
    echo I could not find that element in the database.

  else
    # 2. Divides el texto usando la barra vertical '|' como separador
    IFS="|" read type_id atomic_number symbol name atomic_mass melting_point_celsius boiling_point_celsius type <<< "$INFO_RESULT"
    echo -e "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
  fi
fi
