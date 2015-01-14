#!/bin/bash
# Script to add a user to Linux system
read -p "Enter the existing username to which you want to add a virtual host: " username
egrep "^$username:" /etc/passwd >/dev/null
        if [ $? -eq 0 ]; then
                echo "awesome the $username exists!"

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
                        <IfModule mod_suphp.c>
                                suPHP_UserGroup $username $username
                        </IfModule>
                        <IfModule !mod_disable_suexec.c>
                                <IfModule !mod_ruid2.c>
                                        SuexecUserGroup $username $username
                                </IfModule>
                        </IfModule>
                        <IfModule mod_ruid2.c>
                                RMode config
                                RUidGid $username $username
                        </IfModule>
                        <IfModule itk.c>
                                AssignUserID $username $username
                        </IfModule>
                        ScriptAlias /cgi-bin/ /home/$username/public_html/cgi-bin/
                        </VirtualHost>" > /etc/httpd/conf.d/vhost-$username.conf
		service httpd restart
		echo "virtual host $domainname host added succesfully"
	else
		echo "please add user first"
		exit 1
	fi
