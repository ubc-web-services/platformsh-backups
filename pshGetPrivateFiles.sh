#!/bin/sh

backups_folder=/ut01/backups

d=$(date +%Y-%m-%d)
l=$(date +%Y-%m-%dT%H:%M)

# make sure daily exists
if [ ! -d $backups_folder/$1/$d ]; then
  mkdir -p $backups_folder/$1/$d;
fi

# private file master
if [ ! -d $backups_folder/$1/private ]; then
  mkdir -p $backups_folder/$1/private;
fi

root=$(platform --project=$2 --environment=master --property=web.locations./.root app:config-get)

# FILES EXCLUDED
# .mysql,.mysql.gz,.mysql.gz.info

platform mount:download --project=$2 --environment=master --mount=private --target=$backups_folder/$1/private --exclude=*.mysql --exclude=*.mysql.gz --exclude=*.mysql.gz.info --yes
tar -cvzf $backups_folder/$1/$d/private-$l.tar.gz $backups_folder/$1/private

echo "$1 Private files backed up..."
