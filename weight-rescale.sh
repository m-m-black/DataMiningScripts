#!/bin/bash

# Get file from argument passed to script
FILE=${1?Error: no name given}
LOCATION="/Users/mblack/Documents/RMIT/2018 Sem 2/DM/Assignment 2/Files/Results"

MIN="$(head -1 "$LOCATION/sorted-weight.csv")"
MAX="$(tail -n -1 "$LOCATION/sorted-weight.csv")"

# Remove preamble and all lines starting with '#'
tail -n +10 "$FILE" |
	sed -e '/#/d' > "$LOCATION/temp.txt"

# Perform scaling on weight values, send scaled values to new file
awk '{res = ($1 * (max-min)) + min ; print res}'  min="$MIN" max="$MAX" "$LOCATION/temp.txt" > "$LOCATION/temp-rescaled.txt"

# Group each set of 2 values on 1 line
tail -n +0 "$LOCATION/temp-rescaled.txt" |
	sed -e '/#/d' |
	xargs -n 2 > "$LOCATION/temp-grouped.txt"

# Get absolute error for each line
awk '{ res = $1 - $2 ; res< 0 ? res = -res : res = res ; print res }' "$LOCATION/temp-grouped.txt" > "$LOCATION/temp-errors.txt"

# Get number of instances for mean equation
wc "$LOCATION/temp-errors.txt" > tempWC
read lines words characters < tempWC
LINES=$lines

# Get mean absolute error, output to console
awk '{ sum += $1 } END { print sum / lines }'  lines="$LINES" "$LOCATION/temp-errors.txt"
