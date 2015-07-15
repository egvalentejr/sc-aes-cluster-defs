#!/bin/bash
# Script to create a new user account for this starcluster server
# Requires that the current user have a .starcluster directory with a config.compact file
# as template for the new user's starcluster config file.
# Also requires that the current user have sudo privileges

u=$1
c=$2
pkey=$3

if [ 1"$u"1 == 11 ] ; then
  echo "Usage: $0 <user> <comment> <public key>"  
  exit 1
fi
sudo useradd -m -c "$c" $u
cp ~/.starcluster/config.compact /tmp/starcluster_config
chmod 666 /tmp/starcluster_config
sudo su - $u -c "starcluster"
sudo su - $u -c "cp /tmp/starcluster_config ~/.starcluster/config"
rm /tmp/starcluster_config

if [ 1"$pkey"1 != 11 ] ; then
  sudo su - $u -c "mkdir .ssh"
  sudo su - $u -c "chmod 700 .ssh"
  cp ./$pkey /tmp/temp_$pkey
  chmod 666 /tmp/temp_$pkey
  sudo su - $u -c "cp /tmp/temp_$pkey .ssh"
  sudo su - $u -c "cat .ssh/temp_$pkey >> .ssh/authorized_keys"
  sudo su - $u -c "chmod 600 .ssh/authorized_keys"
  rm /tmp/temp_$pkey
fi

