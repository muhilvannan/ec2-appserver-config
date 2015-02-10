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
DAY_OF_WEEK=$((`date +%u`-1))
DAY_OF_MONTH=`date +%e`
OFFSET=$(((${DAY_OF_WEEK} + 36 - ${DAY_OF_MONTH}) % 7 ))
wkno=$(((${DAY_OF_MONTH} + ${OFFSET} - 1) / 7))
cd /home/
for f in *; do
    if [[ -d $f ]]; then
	backupfile=$backupdir/weekly/$f-$wkno.tar.gz
        echo $backupfile
	tar -zcf $backupfile $f/public_html 2>>/var/log/backup-log/weekly/tar-error-$(date +"%d-%m-%Y").log
    fi
done