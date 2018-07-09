#!/bin/bash

# Need to keep 10 days of backups, plus a weekly backup for 3 months
# If today is a Monday, archive backups from 10 days ago
# Delete archive from 90 days ago, if it exists

backups_folder=/ut01/backups

d=$(date +%Y-%m-%d)
DOW=$(date +%u)

tendaysago=$(date --date "$d -10 days" +%Y-%m-%d)
threemonthsago=$(date --date "$d -90 days" +%Y-%m-%d)

while IFS= read -r project; 
do 
	if [ "$DOW" == 1 ] && [ -d "$backups_folder/$project/$tendaysago" ]
	then 
		mv $backups_folder/$project/$tendaysago $backups_folder/$project/archive/
		echo "moved $project backup from $tendaysago to archive"
	else
		if [ -d "$backups_folder/$project/$tendaysago" ]; then
			rm -rf $backups_folder/$project/$tendaysago
			echo "removed $project backup from $tendaysago"
		fi	
	fi
		if [ -d "$backups_folder/$project/archive/$threemonthsago" ]; then
			rm -rf $backups_folder/$project/archive/$threemonthsago
			echo "removed $project archive from $threemonthsago"
		fi
done < DIR_LIST	
