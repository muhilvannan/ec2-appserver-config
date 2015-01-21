#!/bin/bash
cd /home/
for f in *; do
if [[ -d $f ]]; then
_mon="$(date +'%m')"	
backupfile=/backup/monthly/$f-$_mon.tar.gz
echo $backupfile    
tar -zcf $backupfile $f/public_html 2>>/var/log/backup-log/monthly/tar-error-$(date +"%d-%m-%Y").log
s3File="s3://aws-nix$backupfile"
echo $s3File
s3cmd -c /root/.s3cfg --no-progress -v put $backupfile $s3File -f  >> /var/log/backup-log/monthly/s3upload-$(date +"%d-%m-%Y").log
rm -f $backupfile    
fi
done
if [ -s /var/log/backup-log/monthly/tar-error-$(date +"%d-%m-%Y").log ] ; then mail -s "Monthly Backup Tarring error" support@accentdesign.co.uk < /var/log/backup-log/monthly/tar-error-$(date +"%d-%m-%Y").log ; fi
if [ -s /var/log/backup-log/monthly/s3upload-$(date +"%d-%m-%Y").log ] ; then mail -s "Monthly Backup S3 Upload Log" support@accentdesign.co.uk < /var/log/backup-log/monthly/s3upload-$(date +"%d-%m-%Y").log ; fi
