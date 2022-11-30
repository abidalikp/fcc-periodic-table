#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# Check if argument is provided
if [[ -z $1 ]]
then

	echo "Please provide an element as an argument."

else

	# Check if argument is number
	if [[ $1 =~ ^[0-9]+$ ]]
	then

		# Get element name
		NAME=$($PSQL "select name from elements where atomic_number=$1;")
	
	else

		# Get element name
		NAME=$($PSQL "select name from elements where name='$1' or symbol='$1';")
	
	fi


	# Check if element exists
	if [[ -z $NAME ]]
	then
		
		echo "I could not find that element in the database."

	else

		NAME_FORMATTED=$(echo $NAME | sed 's/ |/"/')

		# Get atomic number, symbol
		read ATOMIC_NUMBER BAR SYMBOL <<< $($PSQL "select atomic_number, symbol from elements where name='$NAME_FORMATTED';") 

		# Format 
		ATOMIC_NUMBER_FORMATTED=$(echo $ATOMIC_NUMBER | sed 's/ |/"/')
		SYMBOL_FORMATTED=$(echo $SYMBOL | sed 's/ |/"/')

		# Get atomic mass, melting point, boiling point and type id 
		read MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE_ID <<< $($PSQL "select atomic_mass, melting_point_celsius, boiling_point_celsius, type_id
		 from properties where atomic_number = $ATOMIC_NUMBER_FORMATTED;" )

		# Get type
		read TYPE <<< $($PSQL "select type from types where type_id=$TYPE_ID")		

		echo "The element with atomic number $ATOMIC_NUMBER_FORMATTED is $NAME_FORMATTED ($SYMBOL_FORMATTED). It's a $TYPE, with a mass of $MASS amu. $NAME_FORMATTED has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."

	fi
	
fi
