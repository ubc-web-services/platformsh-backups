#!/bin/bash

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
	
	NAME="${parts[1]}"
	NAME="${NAME%\"}"
	NAME="${NAME#\"}"
	NAME="${NAME// /_}"
	NAME="${NAME//./_}"
	NAME="${NAME//\'/_}"

	echo "Creating Snapshot of master for ${NAME} Project ID ${PROJECT_ID}";

#	BUILD_ID=dontKillMe bash -ex pshGetBackups.sh "${NAME}" "${PROJECT_ID}" &
# platform snapshot:create --environment=master --project="${PROJECT_ID}" --no-wait --yes
	sleep 10

done < ID_LIST_RAW

#exit
