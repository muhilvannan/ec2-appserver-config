#!/bin/bash
cd /home/
for f in *; do
if [[ -d $f ]]; then
_mon="$(date +'%m')"	
backupfile=/backup/monthly/$f-$_mon.tar.gz
echo $backupfile   
tar -zcf $backupfile $f/public_html 2>>/var/log/backup-log/monthly/tar-error-$(date +"%d-%m-%Y").log
s3File="s3://aws-nix-backup$backupfile"
echo $s3file
aws s3 cp $backupfile $s3File  >> /var/log/backup-log/monthly/s3upload-$(date +"%d-%m-%Y").log
rm -f $backupfile
fi
done    
