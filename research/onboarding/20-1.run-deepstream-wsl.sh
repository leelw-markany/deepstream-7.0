#!/bin/bash
SCRIPT=`realpath -s $0`
SCRIPTPATH=`dirname ${SCRIPT}`
SCRIPTNAME=`basename ${SCRIPT}`
cd ${SCRIPTPATH}
set -euo pipefail

export DISPLAY=$(grep -oP "(?<=nameserver ).+" /etc/resolv.conf):0

xhost +
sudo rm -rf /tmp/.X11-unix

# docker run -it \
#   --rm \
#   --gpus all \
#   --net=host \
#   --name=deepstream \
#   -v /tmp/.X11-unix/:/tmp/.X11-unix \
#   -e DISPLAY=$DISPLAY \
#   deepstream:7.0

docker run -it \
  --rm \
  --gpus all \
  --net=host \
  --name=deepstream \
  -v /tmp/.X11-unix/:/tmp/.X11-unix \
  -v ./deepstream-7.0/samples/models/Tracker/:/opt/nvidia/deepstream/deepstream-6.4/samples/models/Tracker \
  -v ./deepstream-7.0/samples/models/peoplenet/:/opt/nvidia/deepstream/deepstream-6.4/samples/models/peoplenet \
  -v ./deepstream-7.0/samples/models/actionrecognitionnet/:/opt/nvidia/deepstream/deepstream-6.4/samples/models/actionrecognitionnet \
  -v ./deepstream-7.0/samples/models/bodypose3dnet/:/opt/nvidia/deepstream/deepstream-6.4/samples/models/bodypose3dnet \
  -v ./deepstream_reference_apps/:/opt/nvidia/deepstream/deepstream-7.0/sources/apps/deepstream_reference_apps \
  -e DISPLAY=$DISPLAY \
  deepstream:7.0

exit $?

# cd /opt/nvidia/deepstream/deepstream-7.0/sources/apps/sample_apps/deepstream-test1
# make
# ./deepstream-test1-app dstest1_config.yml
