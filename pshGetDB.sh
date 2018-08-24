#!/bin/sh

backups_folder=/ut01/backups

d=$(date +%Y-%m-%d)
l=$(date +%Y-%m-%dT%H:%M)

platform db:dump --gzip -y -t -f db_dump-$1.sql.gz --directory $backups_folder/$1/$d --project $2 --environment master

echo "$1 Database backed up..."
