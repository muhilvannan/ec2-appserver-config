#!/bin/bash
cd /home/
for f in *; do
    if [[ -d $f ]]; then
    _dow="$(date +'%w')"
    backupfile=/backup/daily/$f-$_dow.tar.gz
	echo $backupfile    
	tar -zcf $backupfile $f/public_html 2>>/var/log/backup-log/daily/tar-error-$(date +"%d-%m-%Y").log
	s3File="s3://aws-nix$backupfile"
	echo $s3File
	s3cmd -c /root/.s3cfg --no-progress -v put $backupfile $s3File -f  >> /var/log/backup-log/daily/s3upload-$(date +"%d-%m-%Y").log
	rm -f $backupfile
    fi
done
if [ -s /var/log/backup-log/daily/tar-error-$(date +"%d-%m-%Y").log ] ; then mail -s "Daily Backup Tarring error" support@accentdesign.co.uk < /var/log/backup-log/daily/tar-error-$(date +"%d-%m-%Y").log ; fi
if [ -s /var/log/backup-log/daily/s3upload-$(date +"%d-%m-%Y").log ] ; then mail -s "Daily Backup S3 Upload Log" support@accentdesign.co.uk < /var/log/backup-log/daily/s3upload-$(date +"%d-%m-%Y").log ; fi

