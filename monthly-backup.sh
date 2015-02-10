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
_mon="$(date +'%m')"
cd /home/
for f in *; do
	if [[ -d $f ]]; then
		backupfile=$backupdir/monthly/$f-$_mon.tar.gz
		echo $backupfile   
		tar -zcf $backupfile $f/public_html 2>>/var/log/backup-log/monthly/tar-error-$(date +"%d-%m-%Y").log
	fi
done