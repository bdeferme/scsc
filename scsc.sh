#!/bin/bash

#
# Check for OS and store in $OS / $DIST
#
OS=$(uname -s)
if [ $OS = "SunOS" ];
  then
  OS=Solaris
elif [ $OS = "Linux" ];
  then
  if [ -f /etc/redhat-release ];
    then
    DIST="Redhat"
    REV=$(cat /etc/redhat-release)
  elif [ -f /etc/debian_version ];
    then
    DIST="Debian"
    REV=$(cat /etc/debian_version)
  fi
fi

if [ $OS != "Redhat" ];
then
    echo "This script can only be used on CentOS / Red Hat"
    exit 1
fi

if [ $(rpm -qa yum-changelog|wc -l) -lt 1 ];
then
    echo -e "This script needs the yum-changelog package to function correctly, please install it using:\n  yum install yum-changelog"
    exit 1
fi

for i in $(yum check-update|awk '{print $1}'|tail -n+9);
do
    result=$(echo n|yum --changelog update $i|grep -i cve|wc -l)
    if [ $result -gt 0 ];
    then
          echo $i has security updates
    fi
done
