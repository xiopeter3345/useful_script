#!/bin/bash

if test -d /tmp/changeworkerconfig 
then
  rm -rf /tmp/changeworkerconfig
fi

mkdir /tmp/changeworkerconfig
cd /tmp/changeworkerconfig

wget -q -O /tmp/changeworkerconfig/change_worker_config.py https://raw.githubusercontent.com/xiopeter3345/useful_script/master/change_worker_config.py

chmod u+x /tmp/changeworkerconfig/change_worker_config.py

sudo ./change_worker_config.py
