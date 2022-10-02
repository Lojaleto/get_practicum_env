#!/bin/bash

env="practicum"

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

docker start practicum

sleep 3
while true; do
    miniconda3=`docker ps | grep 'practicum' | awk '{ print $1 }'`
    if [ -n "$miniconda3" ]; then
        echo "miniconda3 is running"
        break;
    else sleep 3; echo "miniconda3 is not running"
    fi
done

nohup docker exec $miniconda3 conda run -n $env --no-capture-output jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser --allow-root > ./jupyter.log &

sleep 5
while true; do
    lsize=`wc -c ./jupyter.log | awk '{ print $1 }'`
    if [[ $lsize > 1000 ]]; then
        cat ./jupyter.log
        echo 'other ip:'
        ip route get 8.8.8.8 |awk '{ print $7 }'
        echo '' > ./jupyter.log
        break;
    else sleep 3; echo "jupyter is not running"
    fi
done

while true; do
    echo $jpid
    read -p "Do you wish to S top miniconda3 or R estart jupyter?  " yn
    case $yn in
        [Ss]* ) docker stop $miniconda3; break;;
        [Rr]* ) pkill -f jupyter; nohup docker exec $miniconda3 conda run -n $env --no-capture-output jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser --allow-root > ./jupyter.log &;;
        * ) echo "Please answer S to close or R to restart";;
    esac
done

exit;
