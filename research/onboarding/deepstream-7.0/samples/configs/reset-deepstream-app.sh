#!/bin/bash
SCRIPT=`realpath -s $0`
SCRIPTPATH=`dirname ${SCRIPT}`
SCRIPTNAME=`basename ${SCRIPT}`
cd ${SCRIPTPATH}
set -euo pipefail

IMAGE=deepstream:7.0
SOURCE=/opt/nvidia/deepstream/deepstream-7.0/samples/configs/deepstream-app
DESTINATION=./deepstream-app

container=$(docker create $IMAGE)
sudo rm -rf ./$DESTINATION
docker cp $container:$SOURCE $DESTINATION
docker rm $container

exit $?
