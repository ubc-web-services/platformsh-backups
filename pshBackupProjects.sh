#!/bin/sh

#rm DIR_LIST
#rm ID_LIST
#rm ID_LIST_RAW

# fetch list of projects
#platform project:list --host=ca-1.platform.sh --format=tsv > ID_LIST_RAW

# set defaults if not passed in
backuptype=${1:-db}
itemcount=${2:-20}
sleepduration=${3:-20}

# remove header if above
#sed '1d' ID_LIST_RAW > tmpFile
#mv tmpFile ID_LIST_RAW

# remove old processed files
rm ID_LIST*.process

# split into smaller files of 20 projects each
split -l $itemcount ID_LIST_RAW ID_LIST --additional-suffix=.process

# loop through each file
for file in "$WORKSPACE"/ID_LIST*.process; do

  echo "Processing File $file.....";

  while IFS= read -r line; do

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

	case "$backuptype" in
		"db")
			echo "Creating DB Backups for ${NAME} Project ID ${PROJECT_ID}"
			#BUILD_ID=dontKillMe bash -ex pshGetDB.sh "${NAME}" "${PROJECT_ID}" &
			;;
		"files")
			echo "Creating Public File Backups for ${NAME} Project ID ${PROJECT_ID}"
			#BUILD_ID=dontKillMe bash -ex pshGetPublicFiles.sh "${NAME}" "${PROJECT_ID}" &
			;;
		"private")
			echo "Creating Private Backups for ${NAME} Project ID ${PROJECT_ID}"
			#BUILD_ID=dontKillMe bash -ex pshGetPrivateFiles.sh "${NAME}" "${PROJECT_ID}" &
			;;
	esac

  done < $file

# wait a while for next batch
sleep $sleepduration

done