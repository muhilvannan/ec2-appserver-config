#!/bin/bash
cd /home/
for f in *; do
    if [[ -d $f ]]; then
    _dow="$(date +'%w')"
    backupfile=/backup/daily/$f-$_dow.tar.gz
	echo $backupfile    
	tar -zcf $backupfile $f/public_html 2>>/var/log/backup-log/daily/tar-error-$(date +"%d-%m-%Y").log
	s3File="s3://aws-nix-backup$backupfile"
	echo $s3File
    	aws s3 cp $backupfile $s3File  >> /var/log/backup-log/daily/s3upload-$(date +"%d-%m-%Y").log
	rm -f $backupfile
    fi
done
