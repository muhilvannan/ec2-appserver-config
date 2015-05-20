#!/bin/bash
# Script to add a user to Linux system
read -p "Enter the existing username to which you want to add a virtual host: " username
egrep "^$username:" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
echo "awesome the $username exists!"

read -p "Enter domain to be added without www : " domainname
read -p "Enter Directory name where the subdomain files are located : " subdomainfolder
read -p "Enter certificate name : " certname
read -p "Enter key name : " keyname
read -p "Enter certificate bundle name : " bundlename

echo "# DO NOT EDIT. AUTOMATICALLY GENERATED.  IF YOU NEED TO MAKE A CHANGE PLEASE USE THE INCLUDE FILES.
<VirtualHost *:80>
    ServerName $domainname
    ServerAlias www.$domainname
    DocumentRoot /home/$username/public_html/$subdomainfolder
    ServerAdmin webmaster@$domainname
    ErrorLog /var/log/httpd/$username/error_log
    CustomLog /var/log/httpd/$username/access_log common
    UseCanonicalName Off
    UserDir enabled $username
    <IfModule itk.c>
        AssignUserID $username $username
    </IfModule>
    ScriptAlias /cgi-bin/ /home/$username/public_html/cgi-bin/
</VirtualHost>
<VirtualHost *:443>
    ServerName $domainname
    ServerAlias www.$domainname
    DocumentRoot /home/$username/public_html/$subdomainfolder
    ServerAdmin webmaster@$domainname    
    ErrorLog /var/log/httpd/$username/ssl-error_log
    CustomLog /var/log/httpd/$username/ssl-access_log common
    UseCanonicalName Off
    UserDir enabled $username
    <IfModule itk.c>
        # For more information on MPM ITK, please read:
        #   http://mpm-itk.sesse.net/
        AssignUserID $username $username
    </IfModule>
    ScriptAlias /cgi-bin/ /home/$username/public_html/cgi-bin/
    SSLEngine on
    SSLCertificateFile /etc/httpd/ssl/certs/$certname
    SSLCertificateKeyFile /etc/httpd/ssl/keys/$keyname
    SSLCACertificateFile /etc/httpd/ssl/bundles/$bundlename
    
    SetEnvIf User-Agent ".*MSIE.*" nokeepalive ssl-unclean-shutdown
    
    <Directory "/home/$username/public_html/cgi-bin">
        SSLOptions +StdEnvVars
    </Directory>
</VirtualHost>
" > /etc/httpd/conf.d/vhost-$username-$subdomainfolder.conf
service httpd restart
echo "virtual host $domainname host added succesfully"
else
echo "please add user first"
exit 1
fi