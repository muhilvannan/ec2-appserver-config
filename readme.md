# Configuration Scripts for Amazon Linux EC2 Server #
	
This repo is a collection of configuration scripts to add user and setup a virtual hosts in a Amazon Linux Instance

	### Notes ###

	*Clone this repo with sudo to home directory of default ec2-user
	*Check if there is execute permission
	*Need to execute this as root. For security reasons execute with a user who is not root with sudo command

	### To add user and vhost together use ###
		``` sudo ./configure-user.sh```
	### To Only Add user ###
		```sudo ./create-user.sh```
	### To Add Vhost to existing User ###
		```sudo ./vhost-adder.sh```
