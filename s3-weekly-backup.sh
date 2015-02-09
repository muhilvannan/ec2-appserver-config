#!/bin/bash
cd /home/
for f in *; do
    if [[ -d $f ]]; then
	DAY_OF_WEEK=$((`date +%u`-1))
	DAY_OF_MONTH=`date +%e` 
	OFFSET=$(((${DAY_OF_WEEK} + 36 - ${DAY_OF_MONTH}) % 7 ))
	wkno=$(((${DAY_OF_MONTH} + ${OFFSET} - 1) / 7))	
	backupfile=/backup/weekly/$f-$wkno.tar.gz
        echo $backupfile
	tar -zcf $backupfile $f/public_html 2>>/var/log/backup-log/weekly/tar-error-$(date +"%d-%m-%Y").log
        s3File="s3://aws-nix-backup$backupfile"
	echo $s3file
	aws s3 cp $backupfile $s3File  >> /var/log/backup-log/weekly/s3upload-$(date +"%d-%m-%Y").log
	rm -f $backupfile
    fi
done
