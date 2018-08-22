#!/bin/sh

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

platform db:dump --gzip -y -f db_dump-$l.sql.gz --directory $backups_folder/$1/$d --project $2 --environment master

echo "$1 DB dump started..." >> out.txt

sleep 10

  size=0
  prevSize=-1
  for i in `seq 1 30`;
        do
  
            echo "size is $size" >> out.txt
  
              if [ -e $backups_folder/$1/$d/db_dump-$l.sql.gz ]; then
                backupFile="${backups_folder}/${1}/${d}/db_dump-${l}.sql.gz"
                size=$(du -sh ${backupFile})

                echo "size is $size" >> out.txt
                echo "prevSize is $prevSize" >> out.txt

                if [ "$size" = "$prevSize" ]; then
                  echo "** size = prevSize" >> out.txt
                  break
                else
                  sleep 1
                  prevSize=$size
                  sleep 1
                  echo "echo sleep $i"
                  #if ["$i" -ge "5"]; then
                  #  echo "** breaking i > 5"
                  #  break
                  #fi
                fi
              fi

        done    

echo "$1 DB dump ended..." >> out.txt

#root=$(platform --project=$2 --environment=master --property=web.locations./.root app:config-get)

#platform --project=$2 --environment=master --mount=$root/sites/default/files --target=$backups_folder/$1/$d/files --yes mount:download
#tar -cvzf $backups_folder/$1/$d/files-$l.tar.gz $backups_folder/$1/$d/files
#rm -rf $backups_folder/$1/$d/files

#echo "$1 Public Files backed up..." >> out.txt

#platform --project=$2 --environment=master --mount=private --target=$backups_folder/$1/$d/private --yes mount:download
#tar -cvzf $backups_folder/$1/$d/private-$l.tar.gz $backups_folder/$1/$d/private
#rm -rf $backups_folder/$1/$d/private
#echo "$1 Private files backed up..."

#exit
