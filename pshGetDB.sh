#!/bin/sh

backups_folder=/ut01/backups

d=$(date +%Y-%m-%d)
l=$(date +%Y-%m-%dT%H:%M)

# make sure daily exists
if [ ! -d $backups_folder/$1/$d ]; then
  mkdir -p $backups_folder/$1/$d;
fi

platform db:dump --gzip -y -t -f db_dump-$1.sql.gz --directory $backups_folder/$1/$d --project $2 --environment master

echo "$1 Database backed up..."
