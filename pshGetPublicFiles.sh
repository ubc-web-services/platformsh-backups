#!/bin/sh

backups_folder=/ut01/backups

d=$(date +%Y-%m-%d)
l=$(date +%Y-%m-%dT%H:%M)

# make sure daily exists
if [ ! -d $backups_folder/$1/$d ]; then
  mkdir -p $backups_folder/$1/$d;
fi

# public file master
if [ ! -d $backups_folder/$1/files ]; then
  mkdir -p $backups_folder/$1/files;
fi

root=$(platform --project=$2 --environment=master --property=web.locations./.root app:config-get)

# FILES EXCLUDED
# .css,.css.gz,.js,.js.gz

platform mount:download --project=$2 --environment=master --mount=$root/sites/default/files --target=$backups_folder/$1/files --exclude=*.css --exclude=*.css.gz --exclude=*.js --exclude=*.js.gz --yes 
tar -cvzf $backups_folder/$1/$d/files-$l.tar.gz $backups_folder/$1/files

echo "$1 Public Files backed up..."
