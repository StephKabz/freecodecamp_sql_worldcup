#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
ADD_TEAMS()
{
  #add teams to database
  cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
    if [[ $WINNER != "winner" ]]
    then

      #get teams id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

      # if WINNER not found
      if [[ -z $WINNER_ID ]]
      then
        WINNER_ID_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER');")
        if [[ $WINNER_ID_RESULT == "INSERT 0 1" ]]
        then
          echo "inserted $WINNER into teams table!"
        fi
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      fi

      # if OPPONENT not founb
      if [[ -z $OPPONENT_ID ]]
      then
        OPPONENT_ID_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT');")
        if [[ $OPPONENT_ID_RESULT == "INSERT 0 1" ]]
        then
          echo "inserted $OPPONENT into teams table!"
        fi
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
      fi

      #add games
      ADD_GAME_RESULT=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
      if [[ $ADD_GAME_RESULT == "INSERT 0 1" ]]
      then
        echo -e "game of $ROUND in $YEAR between $WINNER and $OPPONENT endend with the score of $WINNER_GOALS - $OPPONENT_GOALS!\n"
      fi
    fi
  done
}
ADD_TEAMS