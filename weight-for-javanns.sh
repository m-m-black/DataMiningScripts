#!/bin/bash

# Total number of instances = 592
TRAIN=296
VALID=118
TEST=177
INPUT=27
OUTPUT=1

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

paste -d, "$LOCATION/temp-col1.csv" "$LOCATION/temp-col3.csv" "$LOCATION/temp-col4.csv" "$LOCATION/temp-col5.csv" \
	"$LOCATION/temp-col6.csv" "$LOCATION/temp-col7.csv" "$LOCATION/temp-col8.csv" "$LOCATION/temp-col9.csv" \
	"$LOCATION/temp-col10.csv" "$LOCATION/temp-col11.csv" "$LOCATION/temp-col12.csv" "$LOCATION/temp-col13.csv" \
	"$LOCATION/temp-col14.csv" "$LOCATION/temp-col15.csv" "$LOCATION/scaled-weight.csv" > "$LOCATION/heart-scaled.csv"

# Shuffle rows, send to temp1.txt
tail -n +0 "$LOCATION/heart-scaled.csv" | 
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
	sed -e "s/ <50/ 1 0/g" |
	sed -e "s/ >50_1/ 0 1/g" > "$LOCATION/temp1.txt"

# Training file
/bin/echo "SNNS pattern definition file V3.2"  > "$LOCATION/weight-train.pat"
/bin/echo "generated at Mon Apr 25 15:58:23 1994"  >> "$LOCATION/weight-train.pat"
/bin/echo ""  >> "$LOCATION/weight-train.pat"
/bin/echo ""  >> "$LOCATION/weight-train.pat"
/bin/echo "No. of patterns : $TRAIN"  >> "$LOCATION/weight-train.pat"
/bin/echo "No. of input units : $INPUT"  >> "$LOCATION/weight-train.pat"
/bin/echo "No. of output units : $OUTPUT"  >> "$LOCATION/weight-train.pat"

head -$TRAIN "$LOCATION/temp1.txt" >> "$LOCATION/weight-train.pat"

# Validation file
/bin/echo "SNNS pattern definition file V3.2"  > "$LOCATION/weight-valid.pat"
/bin/echo "generated at Mon Apr 25 15:58:23 1994"  >> "$LOCATION/weight-valid.pat"
/bin/echo ""  >> "$LOCATION/weight-valid.pat"
/bin/echo ""  >> "$LOCATION/weight-valid.pat"
/bin/echo "No. of patterns : $VALID"  >> "$LOCATION/weight-valid.pat"
/bin/echo "No. of input units : $INPUT"  >> "$LOCATION/weight-valid.pat"
/bin/echo "No. of output units : $OUTPUT"  >> "$LOCATION/weight-valid.pat"

FROM=`expr $TRAIN + 1`
tail -n +$FROM "$LOCATION/temp1.txt" | head -$VALID >> "$LOCATION/weight-valid.pat"

# Test file
/bin/echo "SNNS pattern definition file V3.2"  > "$LOCATION/weight-test.pat"
/bin/echo "generated at Mon Apr 25 15:58:23 1994"  >> "$LOCATION/weight-test.pat"
/bin/echo ""  >> "$LOCATION/weight-test.pat"
/bin/echo ""  >> "$LOCATION/weight-test.pat"
/bin/echo "No. of patterns : $TEST"  >> "$LOCATION/weight-test.pat"
/bin/echo "No. of input units : $INPUT"  >> "$LOCATION/weight-test.pat"
/bin/echo "No. of output units : $OUTPUT"  >> "$LOCATION/weight-test.pat"

FROM=`expr $FROM + $VALID`
tail -n +$FROM "$LOCATION/temp1.txt" | head -$TEST >> "$LOCATION/weight-test.pat"
