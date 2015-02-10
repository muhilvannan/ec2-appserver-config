#Configuration Scripts for Amazon Linux EC2 Server#
	
This repo is a collection of configuration scripts to add user and setup a virtual hosts in a Amazon Linux Instance

###Notes###
* The user data scripts should be helpful for initial ec2 server role configuration.  Either supply them when building the instance or execute them after building the default instance
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

	./configure-backup.sh

```
*  copy the file backup scripts to the root users home folder
```
#!shell

	cp s3-daily-backup.sh /root/s3-daily-backup.sh
	cp s3-weekly-backup.sh /root/s3-weekly-backup.sh
	cp s3-monthly-backup.sh /root/s3-monthly-backup.sh

```
*  copy the db backup scripts to the root users home folder
```
#!shell

	cp s3-daily-backup.sh /root/s3-daily-backup.sh
	cp s3-weekly-backup.sh /root/s3-weekly-backup.sh
	cp s3-monthly-backup.sh /root/s3-monthly-backup.sh

```
* Setup cron jobs
```
#!shell

15 1 * * * root sh /root/s3-daily-backup.sh 1>/var/log/backup-log/daily/full-$(date +\%d-\%m-\%Y).log; 2>/var/log/backup-log/daily/error-$(date +\%d-\%m-\%Y).log;
15 5 * * 0 root sh /root/s3-weekly-backup.sh 1>/var/log/backup-log/weekly/full-$(date +\%d-\%m-\%Y).log; 2>/var/log/backup-log/weekly/error-$(date +\%d-\%m-\%Y).log;
15 3 1 * * root sh /root/s3-monthly-backup.sh 1>/var/log/backup-log/monthly/full-$(date +\%d-\%m-\%Y).log; 2>/var/log/backup-log/monthly/error-$(date +\%d-\%m-\%Y).log;
15 2 * * * root sh /root/s3-db-daily-backup.sh 1>/var/log/backup-log/daily/full-db-$(date +\%d-\%m-\%Y).log; 2>/var/log/backup-log/daily/error-db-$(date +\%d-\%m-\%Y).log;
15 6 * * 0 root sh /root/s3-db-weekly-backup.sh 1>/var/log/backup-log/weekly/full-db-$(date +\%d-\%m-\%Y).log; 2>/var/log/backup-log/weekly/error-db-$(date +\%d-\%m-\%Y).log;
15 4 1 * * root sh /root/s3-db-monthly-backup.sh 1>/var/log/backup-log/monthly/full-db-$(date +\%d-\%m-\%Y).log; 2>/var/log/backup-log/monthly/error-db-$(date +\%d-\%m-\%Y).log;
10 0 * * 0 root rm -rf /var/log/backup-log/daily/*
12 0 1 * * root rm -rf /var/log/backup-log/weekly/*
15 0 31 12 * root rm -rf /var/log/backup-log/monthly/*

```

*  PLEASE NOTE : Requirement: aws cli tools need to have been installed and configured beforehand on the server