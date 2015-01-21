#!/bin/bash
cd /home/
for f in *; do
    if [[ -d $f ]]; then
    _dow="$(date +'%w')"
    backupfile=/backup/daily/$f-$_dow.tar.gz
	echo $backupfile    
	tar -zcvf $backupfile $f/public_html
	s3File="s3://aws-nix$backupfile"
	echo $s3File
	s3cmd -c /root/.s3cfg --no-progress -v put $backupfile $s3File -f  > /var/log/backup-log/daily/s3cmd-$_dow.log
	rm -f $backupfile
    fi
done
