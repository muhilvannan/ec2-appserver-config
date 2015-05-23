#!/bin/bash
yum update -y
yum install -y gcc make gcc-c++ git
yum install -y httpd24 mod24_ssl
yum install -y php54 php54-devel php54-mysql php54-pdo php54-mbstring php54-gd php54-imap php54-intl php54-pdo php54-process php54-pspell php54-pgsql php54-xml php-pear pcre-devel php54-pecl*
pear install Log
cp /etc/httpd/conf.d/userdir.conf /etc/httpd/conf.d/userdir.conf.bak
echo "
    <IfModule mod_userdir.c>
    #
    # UserDir is disabled by default since it can confirm the presence
    # of a username on the system (depending on home directory
    # permissions).
    #
    UserDir enabled all
    #
    # To enable requests to /~user/ to serve the user's public_html
    # directory, remove the "UserDir disabled" line above, and uncomment
    # the following line instead:
    #
    UserDir public_html
</IfModule>
<Directory /home/*/public_html>
    AllowOverride All
    Options MultiViews SymLinksIfOwnerMatch IncludesNoExec
</Directory>" > /etc/httpd/conf.d/userdir.conf
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak
cp /etc/httpd/conf.d/welcome.conf /etc/httpd/conf/welcome.conf.bak.bak
sed -i.bak -e "s/^Alias /#Alias /g" /etc/httpd/conf.d/welcome.conf
echo  "ServerTokens ProductOnly
ServerSignature Off
Header unset X-Powered-By
Header unset X-Pingback
" >>/etc/httpd/conf/httpd.conf
service httpd start
chkconfig httpd on
echo 'apache and php installed and configured'
mkdir /backup
mkdir /backup/daily
mkdir /backup/weekly
mkdir /backup/monthly
mkdir /var/log/backup-log
mkdir /var/log/backup-log/daily
mkdir /var/log/backup-log/weekly
mkdir /var/log/backup-log/monthly
echo 'backup folder structure configured'

mkdir /etc/httpd/ssl
mkdir /etc/httpd/ssl/bundles
mkdir /etc/httpd/ssl/certs
mkdir /etc/httpd/ssl/keys
mkdir /etc/httpd/ssl/csr
chmod 644 /etc/httpd/ssl/bundles
chmod 644 /etc/httpd/ssl/certs
chmod 600 /etc/httpd/ssl/keys
chmod 644 /etc/httpd/ssl/csr

echo 'SSL folders configured ....'