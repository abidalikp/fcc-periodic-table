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
		ELEMENT_NAME=$($PSQL "select name from elements where atomic_number=$1;")
	
	else

		# Get element name
		ELEMENT_NAME=$($PSQL "select name from elements where name='$1' or symbol='$1';")
	
	fi

	# ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where name='$1' or symbol='$1';")

	# Check if element exists
	if [[ -z $ELEMENT_NAME ]]
	then
		
		echo "I could not find that element in the database."

	else

		echo "Found"

	fi

	
fi
