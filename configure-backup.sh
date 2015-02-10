#!/bin/bash
if [ ! -d "/root/.backup_config" ]; then
        mkdir /root/.backup_config
fi
read -p "Enter local backup directory name [/backup]: " DIRECTORY
read -p "Enter bucket name to backup to [NONE]: " awsbucket
read -p "Enter Mysql username [NONE]: " mysqlusername
read -s -p "Enter password [NONE]: " mysqlpwd

echo -e '\n configuring backup directory .....'

if [[ -z "$DIRECTORY" ]]; then
    DIRECTORY="/backup"
fi
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

echo -e '\n configuring backup logs directory .....'

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

echo -e '\n configuring scripts .....'

if [[ -z "$awsbucket" ]]; then
    cp daily-backup.sh /root/
    cp weekly-backup.sh /root/
    cp monthly-backup.sh /root/
else
    cp s3-daily-backup.sh /root/
    cp s3-weekly-backup.sh /root/
    cp s3-monthly-backup.sh /root/
fi

if [[ -z "$mysqlusername" ]]; then
    echo -e ' \n no db backups configured'
else
    if [[ -z "$awsbucket" ]]; then
        cp db-daily-backup.sh /root/
        cp db-weekly-backup.sh /root/
        cp db-monthly-backup.sh /root/        
    else
        cp s3-db-daily-backup.sh /root/
        cp s3-db-weekly-backup.sh /root/
        cp s3-db-monthly-backup.sh /root/
    fi
fi

echo -e "\n Configured backups - please setup cron tasks"

