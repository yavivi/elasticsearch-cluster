#!/bin/bash

echo "node $1 is starting..."
#sudo apt-get update

cd /vagrant
./install-elastic.sh $1

