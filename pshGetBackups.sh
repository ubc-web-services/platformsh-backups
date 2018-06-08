#!/bin/bash

backups_folder=/ut01/backups

d=$(date +%Y-%m-%d)
l=$(date +%Y-%m-%d::%H:%M)

if [ ! -d $backups_folder/$1/archive ]; then
  mkdir -p $backups_folder/$1/archive;
fi

if [ ! -d $backups_folder/$1/$d/files ]; then
  mkdir -p $backups_folder/$1/$d/files;
fi

if [ ! -d $backups_folder/$1/$d/private ]; then
  mkdir -p $backups_folder/$1/$d/private;
fi

platform db:dump --gzip -y -t -f db_dump-$l.sql.gz --directory $backups_folder/$1/$d --project $2 --environment master
echo "DB backed up..."

root=$(platform --project=$2 --environment=master --property=web.locations./.root app:config-get)

platform --project=$2 --environment=master --mount=$root/sites/default/files --target=$backups_folder/$1/$d/files --yes mount:download
tar -cvzf $backups_folder/$1/$d/files-$l.tar.gz $backups_folder/$1/$d/files
rm -rf $backups_folder/$1/$d/files
echo "Files backed up..."

platform --project=$2 --environment=master --mount=private --target=$backups_folder/$1/$d/private --yes mount:download
tar -cvzf $backups_folder/$1/$d/private-$l.tar.gz $backups_folder/$1/$d/private
rm -rf $backups_folder/$1/$d/private
echo "Private files backed up..."

#exit
