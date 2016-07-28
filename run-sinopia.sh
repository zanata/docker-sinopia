#!/bin/bash -eu
StorageDir=$HOME/.cache/sinopia
mkdir -p $StorageDir
sudo chcon -Rt svirt_sandbox_file_t $StorageDir
docker run -d --name sinopia -p 4873:4873 -v $StorageDir:/opt/sinopia/storage zanata/sinopia
