#!/bin/bash
### Install script for atomic host, need to be executed inside container
set -eu

#### 1. Ensure we are running for atomic host
if [[ ! -r $HOST ]];then
    echo "This script need to be triggered in atomic install.  HOST=$HOST is not a directory" > /dev/stderr
    exit 1
fi

#### 2. Copy files to Host /tmp
cp -v sinopia.yaml sinopia.service "$HOST/tmp/"

