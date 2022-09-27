#!/bin/bash

service docker stop

sleep 1
while true; do
    st=`service docker status | grep "is running"`
    if [ -n "$st" ]; then
        echo "docker is running"
        break;
    else service docker start; sleep 3; echo "docker is not running"
    fi
done

docker run -i -d -p 8888:8888 \
--hostname practicum \
--mount type=bind,source=/opt/notebooks,target=/opt/notebooks \
--name practicum continuumio/miniconda3 /bin/bash


docker exec practicum wget "https://code.s3.yandex.net/data-analyst/ds_practicum_env.yml"
docker exec practicum /opt/conda/bin/conda env create -f ./ds_practicum_env.yml
docker exec practicum /opt/conda/bin/conda activate prakticum
docker exec practicum /opt/conda/bin/conda install jupyter -y --quiet && mkdir /opt/notebooks

docker stop practicum

exit;
