#!/bin/sh

#################################################
#sudo dpkg-reconfigure debconf
export DEBIAN_FRONTEND=noninteractive

#################################################
## install postfix, mailutils for sending mails ###
sudo apt-get update
echo postfix postfix/mailname string $HOSTNAME="machine2localhost" | debconf-set-selections 
echo postfix postfix/main_mailer_type string 'Internet Site' | debconf-set-selections 

#debconf-set-selections <<< "postfix postfix/mailname string machine2localhost"
#debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"

sudo apt-get install -y postfix mailutils
sudo service postfix reload
#################################################
## cron is running, otherwise start ####

sudo service cron restart
#################################################
### Schedule to check if the server is up every minute and notify ###

(crontab -u vagrant -l ; echo "* * * * * /usr/bin/wget 192.168.33.10/current_time.php --timeout 30 -O - | grep "Normal operation string" || echo "The server is down" | /usr/bin/mail  -s "Server down" ashutosh.bharti@hotmail.com") | crontab -


###################################################
