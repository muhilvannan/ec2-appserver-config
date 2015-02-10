#!/bin/bash
configfile='/root/.backup_config/backup'
configfile_secured='/tmp/backup'

if egrep -q -v '^#|^[^ ]*=[^;]*' "$configfile"; then
  echo "Config file is unclean, cleaning it..." >&2
  egrep '^#|^[^ ]*=[^;&]*'  "$configfile" > "$configfile_secured"
  configfile="$configfile_secured"
fi

echo "Reading config...." >&2
source "$configfile"
_dow="$(date +'%w')"
cd /home/
for f in *; do
    if [[ -d $f ]]; then
    backupfile=$backupdir/daily/$f-$_dow.tar.gz
	echo $backupfile    
	tar -zcf $backupfile $f/public_html 2>>/var/log/backup-log/daily/tar-error-$(date +"%d-%m-%Y").log
	s3File="s3://$awsbucketname$backupfile"
	echo $s3File
    	aws s3 cp $backupfile $s3File  >> /var/log/backup-log/daily/s3upload-$(date +"%d-%m-%Y").log
	rm -f $backupfile
    fi
done
databases=`mysql --user=$username -p$pass -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)"`
for db in $databases; do
        if [ $db != "mysql" ]; then
                echo $db  
                dbbackupfile=$backupdir/daily/$db-$_dow.tar.gz
                s3DBFile="s3://$awsbucketname$dbbackupfile"
                echo $dbbackupfile
                echo $s3DBFile
                mysqldump --force -u $username -p$pass --databases $db > /tmp/$db.sql
                tar -zcf  $dbbackupfile /tmp/$db.sql 2>>/var/log/backup-log/daily/tar-db-error-$(date +"%d-%m-%Y").log
                aws s3 cp $dbbackupfile $s3DBFile  >> /var/log/backup-log/daily/s3upload-db-$(date +"%d-%m-%Y").log
        	rm -f /tmp/$db.sql
		rm -f $dbbackupfile
	fi
done
