#!/bin/bash
SCRIPT=`realpath -s $0`
SCRIPTPATH=`dirname ${SCRIPT}`
SCRIPTNAME=`basename ${SCRIPT}`
cd ${SCRIPTPATH}
set -euo pipefail

export DISPLAY=$(grep -oP "(?<=nameserver ).+" /etc/resolv.conf):0

xhost +
sudo rm -rf /tmp/.X11-unix

sudo rm -f deepstream-7.0/sources/apps/sample_apps/deepstream-app/supervisord.log
sudo rm -f deepstream-7.0/sources/apps/sample_apps/deepstream-app/supervisord.pid

docker run -d \
  --gpus all \
  --net=host \
  --name=deepstream-kafka \
  -v /tmp/.X11-unix/:/tmp/.X11-unix \
  -v ./deepstream-7.0/samples/models/Tracker/:/opt/nvidia/deepstream/deepstream-7.0/samples/models/Tracker \
  -v ./deepstream-7.0/samples/models/peoplenet/:/opt/nvidia/deepstream/deepstream-7.0/samples/models/peoplenet \
  -v ./deepstream-7.0/samples/models/actionrecognitionnet/:/opt/nvidia/deepstream/deepstream-7.0/samples/models/actionrecognitionnet \
  -v ./deepstream-7.0/samples/models/bodypose3dnet/:/opt/nvidia/deepstream/deepstream-7.0/samples/models/bodypose3dnet \
  -v ./deepstream-7.0/samples/configs/deepstream-app/:/opt/nvidia/deepstream/deepstream-7.0/samples/configs/deepstream-app \
  -v ./deepstream-7.0/sources/includes/:/opt/nvidia/deepstream/deepstream-7.0/sources/includes \
  -v ./deepstream-7.0/sources/apps/:/opt/nvidia/deepstream/deepstream-7.0/sources/apps \
  -v ./deepstream-7.0/sources/objectDetector_Yolo/:/opt/nvidia/deepstream/deepstream-7.0/sources/objectDetector_Yolo \
  -v ./deepstream-7.0/sources/tracker_ReID/:/opt/nvidia/deepstream/deepstream-7.0/sources/tracker_ReID \
  -v ./deepstream_reference_apps/:/opt/nvidia/deepstream/deepstream-7.0/sources/apps/deepstream_reference_apps \
  -e DISPLAY=$DISPLAY \
  -e CUDA_CACHE_DISABLE=0 \
  deepstream-kafka:7.0

docker exec -it deepstream-kafka /bin/bash

docker rm deepstream-kafka

exit $?
