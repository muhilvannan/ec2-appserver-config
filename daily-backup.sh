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
    fi
done