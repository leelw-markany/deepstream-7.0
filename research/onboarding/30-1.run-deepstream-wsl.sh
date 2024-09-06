#!/bin/bash
SCRIPT=`realpath -s $0`
SCRIPTPATH=`dirname ${SCRIPT}`
SCRIPTNAME=`basename ${SCRIPT}`
cd ${SCRIPTPATH}
set -euo pipefail

export DISPLAY=$(grep -oP "(?<=nameserver ).+" /etc/resolv.conf):0

xhost +
sudo rm -rf /tmp/.X11-unix

docker run -it \
  --rm \
  --gpus all \
  --net=host \
  --name=deepstream \
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
  -p 8554:8554 \
  -p 5400:5400 \
  -e DISPLAY=$DISPLAY \
  -e CUDA_CACHE_DISABLE=0 \
  deepstream:7.0

exit $?
