#!/bin/bash

# Need to keep 10 days of backups, plus a weekly backup for 3 months
# If today is a Monday, archive backups from 10 days ago
# Delete archive from 90 days ago, if it exists

backups_folder=/ut01/backups

d=$(date +%Y-%m-%d)
DOW=$(date +%u)

tendaysago=$(date -j -v-10d -f "%Y-%m-%d" $d "+%Y-%m-%d")
threemonthsago=$(date -j -v-90d -f "%Y-%m-%d" $d "+%Y-%m-%d")

while IFS= read -r project; 
do 
	if [ "$DOW" == 1 ]
	then 
		mv $backups_folder/$project/$tendaysago $backups_folder/$project/archive/
	else
		if [ -n "$tendaysago" ]; then
			rm -rf $backups_folder/$project/$tendaysago
		fi	
	fi
		if [ -n "$threemonthsago" ]; then
			rm -rf $backups_folder/$project/archive/$threemonthsago
		fi
done < DIR_LIST	
