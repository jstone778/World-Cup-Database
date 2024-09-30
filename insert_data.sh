#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPP W_GOALS O_GOALS
do
  echo $YEAR $ROUND $WINNER $OPP $W_GOALS $O_GOALS
  if [[ $YEAR != 'year' ]]
  then
    TEAM_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    if [[ -z $TEAM_WINNER_ID ]]
    then
      TEAM_WINNER_ID=null
    fi

    if [[ $TEAM_WINNER_ID ]]
    then
      INSERT_WINNER_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    fi

    TEAM_OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")

    if [[ -z $TEAM_OPP_ID ]]
    then
      TEAM_OPP_ID=null
    fi

    if [[ $TEAM_OPP_ID ]]
    then
      INSERT_OPP_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPP')")
      if [[ $INSERT_OPP_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPP
      fi
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPP W_GOALS O_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")

    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPP_ID', '$W_GOALS', '$O_GOALS')")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into games, $WINNER vs. $OPP in $ROUND of $YEAR
    fi
  fi
done