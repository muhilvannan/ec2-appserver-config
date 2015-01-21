#Configuration Scripts for Amazon Linux EC2 Server#
	
This repo is a collection of configuration scripts to add user and setup a virtual hosts in a Amazon Linux Instance

###Notes###

* Clone this repo with sudo to home directory of default ec2-user
* Check if there is execute permission
* Need to execute this as root. For security reasons execute with a user who is not root with sudo command

###To add user and vhost together###
		 sudo ./configure-user.sh
###To Only Add user###
		sudo ./create-user.sh
###To Add Vhost to existing User###
		sudo ./vhost-adder.sh

###To Setup an SSL website or to add SSL to an existing website###
* The private key should be stored in /etc/httpd/ssl/keys/ with 600 permissions
* The ca bundle is to be stored in /etc/httpd/ssl/cabundles/ with 644 permissions
* The crt file is to be stored in /etc/httpd/ssl/certs/ with 644 permissions
* Make sure you note down all the names to enter when prompted
* Now Execute
		
```
#!shell

	sudo ./ssl-vhost-adder.sh
```

###To Setup Backup scripts###
* create backup folders and backup log folders if not present already
```
#!shell

	mkdir /backup
	mkdir /backup/daily
	mkdir /backup/weekly
	mkdir /backup/monthly
	mkdir /var/log/backup-log
	mkdir /var/log/backup-log/daily
	mkdir /var/log/backup-log/weekly
	mkdir /var/log/backup-log/monthly

```
*  copy the backup scripts to the root users home folder
```
#!shell

	cp daily-backup.sh /root/daily-backup.sh
	cp weekly-backup.sh /root/weekly-backup.sh
	cp monthly-backup.sh /root/monthly-backup.sh

```
* Setup cron jobs
```
#!shell

15 1 * * * root sh /root/daily-backup.sh 1>/var/log/backup-log/daily/full-$(date +\%d-\%m-\%Y).log; 2>/var/log/backup-log/daily/error-$(date +\%d-\%m-\%Y).log;
15 5 * * 0 root sh /root/weekly-backup.sh 1>/var/log/backup-log/weekly/full-$(date +\%d-\%m-\%Y).log; 2>/var/log/backup-log/weekly/error-$(date +\%d-\%m-\%Y).log;
15 3 1 * * root sh /root/monthly-backup.sh 1>/var/log/backup-log/monthly/full-$(date +\%d-\%m-\%Y).log; 2>/var/log/backup-log/monthly/error-$(date +\%d-\%m-\%Y).log;
10 0 * * 0 root rm -rf /var/log/backup-log/daily/*
12 0 1 * * root rm -rf /var/log/backup-log/weekly/*
15 0 31 12 * root rm -rf /var/log/backup-log/monthly/*

```

*  PLEASE NOTE : Requirement: s3cmd tools need to have been installed and configured beforehand on the server