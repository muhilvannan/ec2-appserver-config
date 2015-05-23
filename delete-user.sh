#!/bin/bash
# Script to add a user to Linux system
if [ $(id -u) -eq 0 ]; then
        read -p "Enter username : " username
        
        egrep "^$username:" /etc/passwd >/dev/null
        if [ $? -eq 0 ]; then
                echo "$username exists!"
                userdel -r $username
                rm -f /etc/httpd/conf.d/vhost-$username*

        else
               echo "$username does not exist!"
               exit 1
        fi
else
        echo "Only root may delete a user to the system. Use SUDO"
        exit 2
fi
