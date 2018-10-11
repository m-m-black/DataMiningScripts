#!/bin/bash

LOCATION="/Users/mblack/Documents/RMIT/2018 Sem 2/DM/Assignment 2/Files/Results"
# replace value of HEAD each time script is run
HEAD="test"
FILE="$LOCATION/$HEAD.res"

MIN="$(head -1 "$LOCATION/sorted-weight.csv")"
MAX="$(tail -n -1 "$LOCATION/sorted-weight.csv")"

# Remove preamble and all lines starting with '#'
tail -n +10 "$FILE" |
	sed -e '/#/d' > "$LOCATION/test.txt"

# Perform scaling on weight values, send scaled values to new file
awk '{res = ($1 * (max-min)) + min ; print res}'  min="$MIN" max="$MAX" "$LOCATION/test.txt" > "$LOCATION/test-rescaled.txt"

# Group each set of 2 values on 1 line
tail -n +0 "$LOCATION/test-rescaled.txt" |
	sed -e '/#/d' |
	xargs -n 2 > "$LOCATION/test-grouped.txt"
