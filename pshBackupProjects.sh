#!/bin/sh

#rm DIR_LIST
#rm ID_LIST
#rm ID_LIST_RAW

#platform project:list --host=ca-1.platform.sh --format=tsv > ID_LIST_RAW
FIRST=1

while IFS= read -r line; 
do 
	if [ "$FIRST" == 1 ]
	then 
		FIRST=0
		continue
	fi

	IFS=$'\t' read -r -a parts <<< "$line"

	PROJECT_ID="${parts[0]}" 
	echo "${PROJECT_ID}" >> ID_LIST;
	
	NAME="${parts[1]}"
	NAME="${NAME%\"}"
	NAME="${NAME#\"}"
	NAME="${NAME// /_}"
	NAME="${NAME//./_}"
	NAME="${NAME//\'/_}"

	echo "${NAME}" >> DIR_LIST;
	#BUILD_ID=dontKillMe bash -ex pshGetBackups.sh "${NAME}" "${PROJECT_ID}"

	echo "Creating Local Backups for ${NAME} Project ID ${PROJECT_ID}";

	backups_folder=/ut01/backups

	d=$(date +%Y-%m-%d)
	l=$(date +%Y-%m-%dT%H:%M)

	if [ ! -d $backups_folder/$1/archive ]; then
	  mkdir -p $backups_folder/$1/archive;
	fi

	if [ ! -d $backups_folder/$1/$d/files ]; then
	  mkdir -p $backups_folder/$1/$d/files;
	fi

	if [ ! -d $backups_folder/$1/$d/private ]; then
	  mkdir -p $backups_folder/$1/$d/private;
	fi

	platform db:dump --gzip -y -t -f db_dump-${NAME}.sql.gz --directory $backups_folder/${NAME}/$d --project ${PROJECT_ID} --environment master
	echo "${NAME} DB backed up..."

	sleep 10

#	BUILD_ID=dontKillMe sh pshGetBackups.sh "${NAME}" "${PROJECT_ID}"
#	BUILD_ID=dontKillMe sh pshGetBackups.sh "${NAME}" "${PROJECT_ID}" &

done < ID_LIST_RAW

#exit
