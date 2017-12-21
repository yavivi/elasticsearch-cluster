#!/bin/bash

###########################
# GENERIC VARS
###########################
RUNNING_USER=`whoami`
INSTALL_USER="root"
TARGET_USER="ubuntu"
TARGET_USER_HOME=/home/$TARGET_USER
INSTALL_HOME=/opt
KITS_HOME=/vagrant/install/kits
CONFIG_HOME=/vagrant/install/config
BASHRC=$TARGET_USER_HOME/.bashrc

NODE=$1
echo "Installing Node: " $NODE

###########################
# VARS
###########################
export ES_HOME=/usr/share/elasticsearch
export ES_CONF_HOME=/etc/elasticsearch
export KIBANA_CONF_HOME=/etc/kibana

function checkPrereqForInstallation {
  echo running user: $RUNNING_USER
  echo allowed user: $INSTALL_USER
  if [ $RUNNING_USER = $INSTALL_USER ]; then
    echo "user allowed for installation"
    return 0
  else
    echo "user NOT allowed for installation"
    return 1
  fi
}

function installJava {
  add-apt-repository -y ppa:webupd8team/java
  apt-get -qq update
  echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
  echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
  apt-get -qq -y install oracle-java8-installer > /dev/null 2>&1 
}

function installElasticsearch {
  wget --quiet -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
  apt-get -qq install apt-transport-https
  echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
  apt-get update && sudo apt-get -qq install elasticsearch
  /bin/systemctl daemon-reload
  /bin/systemctl enable elasticsearch.service
  echo "Starting Elasticsearch Service..."
  echo "Logs can be viewed on /var/log/elasticsearch/"
  echo "Config localted under: /etc/elasticsearch/elasticsearch.yml"
  echo "System ENV file can be found here: /etc/default/elasticsearch" 
  cp $CONFIG_HOME/jvm.options $ES_CONF_HOME
  cp $CONFIG_HOME/elasticsearch.yml $ES_CONF_HOME
  systemctl start elasticsearch.service
}


function installKibana {
  if [ "$NODE" = "node-1" ]; then
    apt-get -qq install kibana
    /bin/systemctl daemon-reload
    /bin/systemctl enable kibana.service
    cp $CONFIG_HOME/kibana.yml $KIBANA_CONF_HOME/kibana.yml
    echo "Starting Kibana Service"
    systemctl start kibana.service
  fi
}

echo "###############################"
echo "# Start Installation of $NODE #"
echo "###############################"

###################################################################
# Each line that was already performed will not be executed again #
###################################################################

echo "############################"
echo "# JAVA Installation"
echo "############################"
installJava

echo "############################"
echo "# Elasticsearch Installation"
echo "############################"
installElasticsearch

echo "############################"
echo "# Kibana Installation"
echo "############################"
installKibana

echo "Installation Finished Succefully"

