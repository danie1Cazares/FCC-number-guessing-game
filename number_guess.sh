#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=number_guess --no-align --tuples-only -c"

RAND=$(( $RANDOM % 1000 + 1 ))
#echo $RAND

echo "Enter your username:"
read USERNAME

IS_USER=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")

if [[ -z $IS_USER ]]
then
  INSERTED=USER=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(user_id) FROM games")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
NEW_GAME=$($PSQL "INSERT INTO games (user_id) VALUES ($USER_ID)")
CUR_GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games")

echo "Guess the secret number between 1 and 1000:"
read GUESS
UPDATE_GUESS=$($PSQL "UPDATE games SET guesses=guesses+1 WHERE game_id=$CUR_GAME_ID") 

while [[ $GUESS != $RAND ]]
do
if [[ $GUESS =~ ^[0-9]+$ ]]
then
  if [[ $GUESS -lt $RAND ]] 
  then
    echo "It's higher than that, guess again:"
  elif [[ $GUESS -gt $RAND ]] 
  then
    echo "It's lower than that, guess again:"
  fi
else
  echo "That is not an integer, guess again:"
fi
UPDATE_GUESS=$($PSQL "UPDATE games SET guesses=guesses+1 WHERE game_id=$CUR_GAME_ID") 
GUESSNUM=$($PSQL "SELECT guesses FROM games WHERE game_id=$CUR_GAME_ID")
read GUESS
done

echo "You guessed it in $GUESSNUM tries. The secret number was $RAND. Nice job!"

#5th commit
