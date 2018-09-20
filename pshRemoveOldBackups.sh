#!/bin/bash

# Need to keep x days of backups, plus a weekly backup for x months
# If today is a Monday, archive backups from x days ago
# Delete archive from x days ago, if it exists

# set defaults if not passed in
xdays=${1:-5}
xmonths=${2:-30}

backups_folder=/ut01/backups

d=$(date +%Y-%m-%d)
DOW=$(date +%u)

daysago=$(date --date "$d -$xdays days" +%Y-%m-%d)
monthsago=$(date --date "$d -$xmonths days" +%Y-%m-%d)

while IFS= read -r project; 
do 
	if [ "$DOW" == 1 ] && [ -d "$backups_folder/$project/$daysago" ]
	then 
		mv $backups_folder/$project/$daysago $backups_folder/$project/archive/
		echo "moved $project backup from $daysago to archive"
	else
		if [ -d "$backups_folder/$project/$daysago" ]; then
			rm -rf $backups_folder/$project/$daysago
			echo "removed $project backup from $daysago"
		fi	
	fi
		if [ -d "$backups_folder/$project/archive/$monthsago" ]; then
			rm -rf $backups_folder/$project/archive/$monthsago
			echo "removed $project archive from $monthsago"
		fi
done < DIR_LIST.last	
