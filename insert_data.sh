#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

#Check if it's the first line
if [[ $YEAR != 'year' ]]
then

#Check if winning team has id
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
if [[ -z $WINNER_ID ]]
then
#If not, add to teams
INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

#Assign winning team's id
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
fi

#Check if opponent team has id
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
if [[ -z $OPPONENT_ID ]]
then
#If not, add to teams
INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

#Assign opponent team's id
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
fi

#insert data
INSERT_ALL=$($PSQL "INSERT INTO games(year, round, winner_id, winner_goals, opponent_id, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $WINNER_GOALS, $OPPONENT_ID, $OPPONENT_GOALS)")

fi
done
