#!/bin/bash

TRAIN=100
VALID=20
TEST=30
INPUT=10
OUTPUT=10

LOCATION="/Users/mblack/Documents/RMIT/2018 Sem 2/DM/Assignment 2/Files"
FILE="$LOCATION/heart-v1.arff"

# Remove preamble, shuffle rows, send to temp1.txt
tail -n +20 "$FILE" | 
	fgrep -v "%" |
	gshuf |
	sed -e "s/,/ /g" > "$LOCATION/temp1.txt"

# Training file
/bin/echo "SNNS pattern definition file V3.2"  > "$LOCATION/heart-train.pat"
/bin/echo "generated at Mon Apr 25 15:58:23 1994"  >> "$LOCATION/heart-train.pat"
/bin/echo ""  >> "$LOCATION/heart-train.pat"
/bin/echo ""  >> "$LOCATION/heart-train.pat"
/bin/echo "No. of patterns : $TRAIN"  >> "$LOCATION/heart-train.pat"
/bin/echo "No. of input units : $INPUT"  >> "$LOCATION/heart-train.pat"
/bin/echo "No. of output units : $OUTPUT"  >> "$LOCATION/heart-train.pat"

head -$TRAIN "$LOCATION/temp1.txt" |
	sed -e "s/<50/1 0/g" |
	sed -e "s/>50_1/0 1/g" >> "$LOCATION/heart-train.pat"

# Validation file
/bin/echo "SNNS pattern definition file V3.2"  > "$LOCATION/heart-valid.pat"
/bin/echo "generated at Mon Apr 25 15:58:23 1994"  >> "$LOCATION/heart-valid.pat"
/bin/echo ""  >> "$LOCATION/heart-valid.pat"
/bin/echo ""  >> "$LOCATION/heart-valid.pat"
/bin/echo "No. of patterns : $TRAIN"  >> "$LOCATION/heart-valid.pat"
/bin/echo "No. of input units : $INPUT"  >> "$LOCATION/heart-valid.pat"
/bin/echo "No. of output units : $OUTPUT"  >> "$LOCATION/heart-valid.pat"

FROM=`expr $TRAIN + 1`
tail -n +$FROM "$LOCATION/temp1.txt" | head -$VALID |
	sed -e "s/<50/1 0/g" |
	sed -e "s/>50_1/0 1/g" >> "$LOCATION/heart-valid.pat"

# Test file
/bin/echo "SNNS pattern definition file V3.2"  > "$LOCATION/heart-test.pat"
/bin/echo "generated at Mon Apr 25 15:58:23 1994"  >> "$LOCATION/heart-test.pat"
/bin/echo ""  >> "$LOCATION/heart-test.pat"
/bin/echo ""  >> "$LOCATION/heart-test.pat"
/bin/echo "No. of patterns : $TRAIN"  >> "$LOCATION/heart-test.pat"
/bin/echo "No. of input units : $INPUT"  >> "$LOCATION/heart-test.pat"
/bin/echo "No. of output units : $OUTPUT"  >> "$LOCATION/heart-test.pat"

FROM=`expr $FROM + $VALID`
tail -n +$FROM "$LOCATION/temp1.txt" | head -$TEST |
	sed -e "s/<50/1 0/g" |
	sed -e "s/>50_1/0 1/g" >> "$LOCATION/heart-test.pat"
