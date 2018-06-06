#!/bin/bash

# Need to keep 10 days of backups, plus a weekly backup for 3 months
# If today is a Monday, archive backups from 10 days ago
# Delete archive from 90 days ago, if it exists

d=$(date +%Y-%m-%d)
DOW=$(date +%u)

tendaysago=$(date -j -v-10d -f "%Y-%m-%d" $d "+%Y-%m-%d")
threemonthsago=$(date -j -v-90d -f "%Y-%m-%d" $d "+%Y-%m-%d")

while IFS= read -r project; 
do 
	if [ "$DOW" == 1 ]
	then 
		mv backups/$project/$tendaysago backups/$project/archive/
	else
		rm -rf backups/$project/$tendaysago
	fi

	rm -rf backups/$project/archive/$threemonthsago

done < DIR_LIST	
