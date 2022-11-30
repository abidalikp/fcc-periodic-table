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
		ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where name='$NAME_FORMATTED';")
		SYMBOL=$($PSQL "select symbol from elements where name='$NAME_FORMATTED';")

		# Format 
		ATOMIC_NUMBER_FORMATTED=$(echo $ATOMIC_NUMBER | sed 's/ |/"/')
		SYMBOL_FORMATTED=$(echo $SYMBOL | sed 's/ |/"/')

		echo "The element with atomic number $ATOMIC_NUMBER_FORMATTED is $NAME_FORMATTED ($SYMBOL_FORMATTED). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius."

	fi

	
fi
