#!/bin/bash

########################
####Commands voor updaten van minions met master###
# sudo apt-get update && sudo apt-get upgrade salt-master -y #voor updaten van master zelf
# sudo salt '*' test.version #voor testen van versie 
# sudo salt-run manage.versions # voor kijken of er updates zijn voor de minions
# sudo salt -G 'os:Ubuntu' cmd.run "sudo apt-get update && sudo apt-get upgrade -y" #voor updaten van alle minions en master





#####################
########Salt#########
#####################
sudo apt-get update && sudo apt-get upgrade -y

sudo apt install python3.8 vim net-tools curl -y

if test -f "/etc/salt/"; then
  printf "salt is al geinstalleerd"
else
  sudo curl -o bootstrap_salt.sh -L https://bootstrap.saltstack.com/
  sudo sh bootstrap_salt.sh -A 192.168.178.33 stable
fi


sudo systemctl enable salt-minion
sudo systemctl restart salt-minion
sudo systemctl start salt-minion

#Op de master voor lijst van keys
#sudo salt-key -L
#voor het accepten van de key
#sudo salt-key -A dan Y enter


#####################
#####Monitoring######
#####################


sudo apt install snmp snmpd git-all -y

#correcte snmpd.conf
sudo git clone https://github.com/swolthuis/autoscript.git
sudo mv autoscript/snmpd.conf /etc/snmp


sudo systemctl enable snmpd
sudo systemctl restart snmpd
sudo systemctl start snmpd

#####################
#######docker########
#####################

sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates gnupg lsb-release -y

if test -f "/etc/docker/"; then
  printf "docker is al geinstalleerd"
else
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io -y

fi

sudo docker run hello-world 


#########################
#######wordpress#########
#########################
sudo apt update
sudo apt install apache2 php libapache2-mod-php mysql-server -y
sudo systemctl enable apache2
sudo systemctl restart apache2

sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp-cli

wp-cli core download



#check welke services active zijn
sudo systemctl --type=service --state=active
