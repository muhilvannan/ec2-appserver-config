#!/bin/bash
# Script to add a user to Linux system
if [ $(id -u) -eq 0 ]; then
        read -p "Enter username : " username
        read -s -p "Enter password : " password
        egrep "^$username:" /etc/passwd >/dev/null
        if [ $? -eq 0 ]; then
                echo "$username exists!"
                exit 1
        else
                pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
                useradd -m -p $pass $username
                if [ $? -eq 0 ]; then
                    mkdir /var/log/httpd/$username
		    mkdir /home/$username/public_html
                    chmod 711 /home/$username
                    chmod 755 /home/$username/public_html
                    chown -R $username /home/$username/public_html
                    echo "User has been added to system!"
                read -p "Enter domain to be added without www : " domainname
		echo "# DO NOT EDIT. AUTOMATICALLY GENERATED.  IF YOU NEED TO MAKE A CHANGE PLEASE USE THE INCLUDE FILES.
		<VirtualHost *:80>
    		ServerName $domainname
    		ServerAlias www.$domainname
    		DocumentRoot /home/$username/public_html
    		ServerAdmin webmaster@$domainname
    		ErrorLog /var/log/httpd/$username/error_log
    		CustomLog /var/log/httpd/$username/access_log common
    		UseCanonicalName Off
    		UserDir enabled $username
    		<IfModule itk.c>
        	AssignUserID $username $username
    		</IfModule>
    		ScriptAlias /cgi-bin/ /home/$username/public_html/cgi-bin/
		</VirtualHost>" > /etc/httpd/conf.d/vhost-$username.conf
		 service httpd restart
		 echo "virtual host added"
		else
                    echo "Failed to add a user!"
                fi
        fi
else
        echo "Only root may add a user to the system"
        exit 2
fi
