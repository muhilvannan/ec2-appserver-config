#!/bin/bash
if [ ! -d "/root/.backup_config" ]; then
        mkdir /root/.backup_config
fi
read -p "Enter local backup directory name : " DIRECTORY
read -p "Enter bucket name to backup to : " awsbucket
read -p "Enter Mysql username : " mysqlusername
read -s -p "Enter password : " mysqlpwd
echo "backupdir=\"$DIRECTORY\"
username=\"$mysqlusername\"
pass=\"$mysqlpwd\"
awsbucketname=\"$awsbucket\"">/root/.backup_config/backup

if [ ! -d "$DIRECTORY" ]; then
 	mkdir $DIRECTORY
	chmod 777 $DIRECTORY
fi
if [ ! -d "$DIRECTORY/daily" ]; then
	mkdir $DIRECTORY/daily
fi
if [ ! -d "$DIRECTORY/weekly" ]; then
        mkdir $DIRECTORY/weekly
fi
if [ ! -d "$DIRECTORY/monthly" ]; then
        mkdir $DIRECTORY/monthly
fi

if [ ! -d "/var/log/backup-log" ]; then
        mkdir /var/log/backup-log
fi
if [ ! -d "/var/log/backup-log/daily" ]; then
        mkdir /var/log/backup-log/daily
fi
if [ ! -d "/var/log/backup-log/weekly" ]; then
        mkdir /var/log/backup-log/weekly
fi
if [ ! -d "/var/log/backup-log/monthly" ]; then
        mkdir /var/log/backup-log/monthly
fi

chmod 600 -Rf /root/.backup_config
chmod 744 -Rf /var/log/backup-log

echo -e "Configured backups - please setup cron tasks"

