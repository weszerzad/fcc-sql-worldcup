#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# function to add team
add_winner () {
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$1'")
  if [[ -z $WINNER_ID ]]
  then
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$1')")
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$1'")
    echo Added $1
  fi
}
add_opponent () {
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$1'")
  if [[ -z $OPPONENT_ID ]]
  then
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$1')")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$1'")
    echo Added $1
  fi
}

# clear tables
TRUNCATE_RESULT=$($PSQL "TRUNCATE teams, games")

# reading games.csv line by line
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # ignore title
  if [[ $YEAR != year ]]
  then
    # add winner team
    add_winner "$WINNER"
    # add opponent team
    add_opponent "$OPPONENT"

    # add to games table
    ADD_GAMES_RESULT=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    echo Added a game
  fi
done
