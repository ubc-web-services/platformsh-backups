
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

	echo "getting platform logs for ${NAME} ${PROJECT_ID}"
	
	if [ ! -d $logs_folder/${NAME} ]; then
	  mkdir -p $logs_folder/${NAME};
	fi
	echo "destination $logs_folder/${NAME} "

	#TODO run in pipeline instead?
 	BUILD_ID=dontKillMe platform log access --project=${PROJECT_ID}  --environment=master > $logs_folder/${NAME}/access.log &
	BUILD_ID=dontKillMe platform log app --project=${PROJECT_ID}  --environment=master > $logs_folder/${NAME}/app.log &
	BUILD_ID=dontKillMe platform log cron --project=${PROJECT_ID}  --environment=master > $logs_folder/${NAME}/cron.log &
	BUILD_ID=dontKillMe platform log deploy --project=${PROJECT_ID}  --environment=master > $logs_folder/${NAME}/deploy.log &
	BUILD_ID=dontKillMe platform log error --project=${PROJECT_ID}  --environment=master > $logs_folder/${NAME}/error.log &
	BUILD_ID=dontKillMe platform log php.access --project=${PROJECT_ID}  --environment=master > $logs_folder/${NAME}/php.access.log &
	#BUILD_ID=dontKillMe platform log post-deploy --project=${PROJECT_ID}  --environment=master > $logs_folder/${NAME}/post-deploy.log &
	
done < ID_LIST_RAW
