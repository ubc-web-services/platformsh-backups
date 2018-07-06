
FIRST=1
logs_folder=/ut01/logs

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

#	BUILD_ID=dontKillMe bash -ex pshGetBackups.sh "${NAME}" "${PROJECT_ID}" &

	echo "getting platform log for ${NAME} ${PROJECT_ID}"
	echo "destination $logs_folder/${NAME} "


	if [ ! -d $logs_folder/${NAME} ]; then
	  mkdir -p $logs_folder/${NAME};
	fi

	#if [ -n "${NAME}" ]
	#then
 	platform log access --project=${PROJECT_ID}  --environment=master > $logs_folder/${NAME}/access.log &
	#fi

done < ID_LIST_RAW
