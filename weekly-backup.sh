#!/bin/bash
cd /home/
for f in *; do
    if [[ -d $f ]]; then
     wkno=$(( 1 + $(date +%U) - $(date -d "$(date -d "-$(($(date +%d)-1)) days")" +%U) ))
	backupfile=/backup/weekly/$f-$wkno.tar.gz
        echo $backupfile    
        tar -zcvf $backupfile $f/public_html
        s3File="s3://aws-nix$backupfile"
        echo $s3File
    	s3cmd -c /root/.s3cfg --no-progress -v put $backupfile $s3File -f  > /var/log/backup-log/weekly/s3cmd-$wkno.log	
	rm -f $backupfile
    fi
done
