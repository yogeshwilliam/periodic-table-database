#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then 
if [[ ! $1 =~ ^[0-9]+$ ]]
then 
ELEMENTS=$($PSQL "SELECT atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol='$1' OR name='$1'")
else
ELEMENTS=$($PSQL "SELECT atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$1")
fi
if [[ -z $ELEMENTS ]]
then
echo "I could not find that element in the database."
else
echo "$ELEMENTS" | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
do
echo "The element with atomic number $(echo $ATOMIC_NUMBER | sed -E 's/^ *| *$//g') is $(echo $NAME | sed -E 's/^ *| *$//g') ($(echo $SYMBOL | sed -E 's/^ *| *$//g')). It's a $(echo $TYPE | sed -E 's/^ *| *$//g'), with a mass of $(echo $ATOMIC_MASS | sed -E 's/^ *| *$//g') amu. $(echo $NAME | sed -E 's/^ *| *$//g') has a melting point of $(echo $MELTING_POINT | sed -E 's/^ *| *$//g') celsius and a boiling point of $(echo $BOILING_POINT | sed -E 's/^ *| *$//g') celsius."
done
#
fi
else
echo "Please provide an element as an argument."
fi
