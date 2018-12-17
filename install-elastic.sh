#!/bin/bash

###########################
# GENERIC VARS
###########################
CONFIG_HOME=/vagrant/install/config

NODE=$1
echo "Installing Node: " $NODE

###########################
# VARS
###########################
export ES_HOME=/usr/share/elasticsearch
export ES_CONF_HOME=/etc/elasticsearch
export KIBANA_CONF_HOME=/etc/kibana

export OPEN_JDK_FILENAME=openjdk-11.0.1_linux-x64_bin.tar.gz
export OPEN_JDK_DOWNLOAD_URL=https://download.java.net/java/GA/jdk11/13/GPL/$OPEN_JDK_FILENAME
export JAVA_HOME=/usr/lib/java/jdk-11.0.1/
export PATH=$PATH:$JAVA_HOME/bin

yum install -y wget

function installJava {
  echo "############################"
  echo "# JAVA Installation"
  echo "############################"
  
  wget -q $OPEN_JDK_DOWNLOAD_URL -O /tmp/$OPEN_JDK_FILENAME
  mkdir -p /usr/lib/java
  cd /tmp
  tar xfvz /tmp/$OPEN_JDK_FILENAME --directory /usr/lib/java
  java -version
  ln -s $JAVA_HOME/bin/java /usr/bin/java 
}

function installElasticsearch {
  echo "############################"
  echo "# Elasticsearch Installation"
  echo "############################"
  cp /vagrant/elasticsearch.repo /etc/yum.repos.d/
  yum install -y elasticsearch
  /bin/systemctl daemon-reload
  /bin/systemctl enable elasticsearch.service
  echo "Starting Elasticsearch Service..."
  echo "Logs can be viewed on /var/log/elasticsearch/"
  echo "Config located under: /etc/elasticsearch/elasticsearch.yml"
  echo "System ENV file can be found here: /etc/default/elasticsearch" 
  cp $CONFIG_HOME/jvm.options $ES_CONF_HOME
  cp $CONFIG_HOME/elasticsearch.yml $ES_CONF_HOME
  systemctl start elasticsearch.service
}


function installKibana {
  if [ "$NODE" = "node-1" ]; then
    echo "############################"
    echo "# Kibana Installation"
    echo "############################"

    yum install -y kibana
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

installJava

installElasticsearch

installKibana

echo "Installation Finished Succefully"

