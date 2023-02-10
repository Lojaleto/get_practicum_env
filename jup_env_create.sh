#!/bin/bash

env="practicum"

#uncomment for WSL
#service docker stop

#sleep 1
#while true; do
#    st=`service docker status | grep "is running"`
#    if [ -n "$st" ]; then
#       echo "docker is running"
#        break;
#    else service docker start; sleep 3; echo "docker is not running"
#    fi
#done

mkdir /opt/notebooks
ln -s "$(pwd)"/start_jupyter.sh ~/sj.sh

docker run -i -d -p 8888:8888 \
--hostname $env \
--mount type=bind,source=/opt/notebooks,target=/opt/notebooks \
--name $env continuumio/miniconda3 /bin/bash


docker exec $env wget "https://code.s3.yandex.net/data-analyst/ds_practicum_env.yml"
docker exec $env /opt/conda/bin/conda env create -f ./ds_practicum_env.yml
docker exec $env /opt/conda/bin/conda activate $env
docker exec $env /opt/conda/bin/conda install jupyter -y --quiet && mkdir /opt/notebooks

docker stop $env

exit;
