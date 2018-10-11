#!/bin/bash

# Total number of instances = 592
TRAIN=296
VALID=118
TEST=177
INPUT=26
OUTPUT=2

LOCATION="/Users/mblack/Documents/RMIT/2018 Sem 2/DM/Assignment 2/Files"
FILE="$LOCATION/heart-v1.csv"

# Separate columns into individual files
tail -n +2 "$FILE" | cut -d, -f1 > "$LOCATION/temp-col1.csv"
tail -n +2 "$FILE" | cut -d, -f2 > "$LOCATION/temp-col2.csv"
tail -n +2 "$FILE" | cut -d, -f3 > "$LOCATION/temp-col3.csv"
tail -n +2 "$FILE" | cut -d, -f4 > "$LOCATION/temp-col4.csv"
tail -n +2 "$FILE" | cut -d, -f5 > "$LOCATION/temp-col5.csv"
tail -n +2 "$FILE" | cut -d, -f6 > "$LOCATION/temp-col6.csv"
tail -n +2 "$FILE" | cut -d, -f7 > "$LOCATION/temp-col7.csv"
tail -n +2 "$FILE" | cut -d, -f8 > "$LOCATION/temp-col8.csv"
tail -n +2 "$FILE" | cut -d, -f9 > "$LOCATION/temp-col9.csv"
tail -n +2 "$FILE" | cut -d, -f10 > "$LOCATION/temp-col10.csv"
tail -n +2 "$FILE" | cut -d, -f11 > "$LOCATION/temp-col11.csv"
tail -n +2 "$FILE" | cut -d, -f12 > "$LOCATION/temp-col12.csv"
tail -n +2 "$FILE" | cut -d, -f13 > "$LOCATION/temp-col13.csv"
tail -n +2 "$FILE" | cut -d, -f14 > "$LOCATION/temp-col14.csv"
tail -n +2 "$FILE" | cut -d, -f15 > "$LOCATION/temp-col15.csv"

# Extract MIN and MAX weights from sorted weight file
sort -n "$LOCATION/temp-col2.csv" > "$LOCATION/sorted-weight.csv"
MIN="$(head -1 "$LOCATION/sorted-weight.csv")"
MAX="$(tail -n -1 "$LOCATION/sorted-weight.csv")"

# Perform scaling on weight values, send scaled values to new file
awk '{res = ($1-min)/(max-min) ; print res}'  min="$MIN" max="$MAX" "$LOCATION/temp-col2.csv" > "$LOCATION/scaled-weight.csv"

exit

# Remove preamble, shuffle rows, send to temp1.txt
tail -n +20 "$FILE" | 
	fgrep -v "%" |
	gshuf |
	sed -e "s/,/ /g" | 
	sed -e "s/ male / 1 0 /g" |
	sed -e "s/ female / 0 1 /g" |
	sed -e "s/ typ_angina / 1 0 0 0 /g" |
	sed -e "s/ asympt / 0 1 0 0 /g" |
	sed -e "s/ non_anginal / 0 0 1 0 /g" |
	sed -e "s/ atyp_angina / 0 0 0 1 /g" |
	sed -e "s/ t / 1 0 /g" |
	sed -e "s/ f / 0 1 /g" | 
	sed -e "s/ left_vent_hyper / 1 0 0 /g" |
	sed -e "s/ normal / 0 1 0 /g" |
	sed -e "s/ st_t_wave_abnormality / 0 0 1 /g" |
	sed -e "s/ no / 1 0 /g" |
	sed -e "s/ yes / 0 1 /g" |
	sed -e "s/ down / 1 0 0 /g" |
	sed -e "s/ flat / 0 1 0 /g" |
	sed -e "s/ up / 0 0 1 /g" |
	sed -e "s/ fixed_defect / 1 0 0 /g" |
	sed -e "s/ normal / 0 1 0 /g" |
	sed -e "s/ reversable_defect / 0 0 1 /g" |
	sed -e "s/ <50/ 1 0 /g" |
	sed -e "s/ >50_1/ 0 1 /g" > "$LOCATION/temp1.txt"

# Training file
/bin/echo "SNNS pattern definition file V3.2"  > "$LOCATION/heart-train.pat"
/bin/echo "generated at Mon Apr 25 15:58:23 1994"  >> "$LOCATION/heart-train.pat"
/bin/echo ""  >> "$LOCATION/heart-train.pat"
/bin/echo ""  >> "$LOCATION/heart-train.pat"
/bin/echo "No. of patterns : $TRAIN"  >> "$LOCATION/heart-train.pat"
/bin/echo "No. of input units : $INPUT"  >> "$LOCATION/heart-train.pat"
/bin/echo "No. of output units : $OUTPUT"  >> "$LOCATION/heart-train.pat"

head -$TRAIN "$LOCATION/temp1.txt" >> "$LOCATION/heart-train.pat"

# Validation file
/bin/echo "SNNS pattern definition file V3.2"  > "$LOCATION/heart-valid.pat"
/bin/echo "generated at Mon Apr 25 15:58:23 1994"  >> "$LOCATION/heart-valid.pat"
/bin/echo ""  >> "$LOCATION/heart-valid.pat"
/bin/echo ""  >> "$LOCATION/heart-valid.pat"
/bin/echo "No. of patterns : $VALID"  >> "$LOCATION/heart-valid.pat"
/bin/echo "No. of input units : $INPUT"  >> "$LOCATION/heart-valid.pat"
/bin/echo "No. of output units : $OUTPUT"  >> "$LOCATION/heart-valid.pat"

FROM=`expr $TRAIN + 1`
tail -n +$FROM "$LOCATION/temp1.txt" | head -$VALID >> "$LOCATION/heart-valid.pat"

# Test file
/bin/echo "SNNS pattern definition file V3.2"  > "$LOCATION/heart-test.pat"
/bin/echo "generated at Mon Apr 25 15:58:23 1994"  >> "$LOCATION/heart-test.pat"
/bin/echo ""  >> "$LOCATION/heart-test.pat"
/bin/echo ""  >> "$LOCATION/heart-test.pat"
/bin/echo "No. of patterns : $TEST"  >> "$LOCATION/heart-test.pat"
/bin/echo "No. of input units : $INPUT"  >> "$LOCATION/heart-test.pat"
/bin/echo "No. of output units : $OUTPUT"  >> "$LOCATION/heart-test.pat"

FROM=`expr $FROM + $VALID`
tail -n +$FROM "$LOCATION/temp1.txt" | head -$TEST >> "$LOCATION/heart-test.pat"
