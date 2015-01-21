#!/bin/bash
cd /home/
for f in *; do
if [[ -d $f ]]; then
_mon="$(date +'%m')"	
backupfile=/backup/monthly/$f-$_mon.tar.gz
echo $backupfile    
tar -zcvf $backupfile $f/public_html
s3File="s3://aws-nix$backupfile"
echo $s3File
s3cmd -c /root/.s3cfg --no-progress -v put $backupfile $s3File -f  > /var/log/backup-log/monthly/s3cmd-$_mon.log
rm -f $backupfile    
fi
done
