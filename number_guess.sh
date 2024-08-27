#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guessing_database --tuples-only -c"
NEW_NUMBER=$((($RANDOM%1000)+1))
NEW_NUMBER=3
echo "Enter your username:"
read USERNAME
# if username doesnt exist
GET_USER_RESULT=$($PSQL "SELECT number_of_games, best_game FROM users WHERE username='$USERNAME'")
# insert user to database
if [[ -z $GET_USER_RESULT ]]
then
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  NUMBER_OF_GAMES=$(echo $GET_USER_RESULT | sed 's/(^[0-9]+).*/\1/g' -E)
  BEST_GAME=$(echo $GET_USER_RESULT | sed 's/.*([0-9]*[0-9]$)/\1/' -E)
  echo "Welcome back, $USERNAME! You have played $NUMBER_OF_GAMES games, and your best game took $BEST_GAME guesses."
fi
NUMBER_OF_GUESSES=0

#read guess
echo "Guess the secret number between 1 and 1000:"
while [[ 1==1 ]]
do
  read GUESS
  NUMBER_OF_GUESSES=$(($NUMBER_OF_GUESSES+1))
  if [[ $GUESS -eq $NEW_NUMBER ]]
    then
    break
  fi
  if [[ ! $GUESS =~ [0-9]+ ]] 
  then 
    echo "That is not an integer, guess again:"
  elif [[ $GUESS -gt $NEW_NUMBER ]]
    then
    echo "It's lower than that, guess again:"
    else
    echo "It's higher than that, guess again:"
  fi
done
echo "You guessed it in $NUMBER_OF_GUESSES" tries. The secret number was $NEW_NUMBER. Nice job!

if [[ $BEST_GAME -eq 0 ]]
then
  BEST_GAME=$NUMBER_OF_GUESSES
elif [[ $BEST_GAME -gt $NUMBER_OF_GUESSES ]]
then
  BEST_GAME=$NUMBER_OF_GUESSES
fi

NUMBER_OF_GAMES=$(($NUMBER_OF_GAMES+1))
UPDATE_USERNAME_RESULT=$($PSQL "UPDATE users SET number_of_games = $NUMBER_OF_GAMES, best_game = $BEST_GAME WHERE username = '$USERNAME'")

