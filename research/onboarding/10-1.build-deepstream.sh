#!/bin/bash
SCRIPT=`realpath -s $0`
SCRIPTPATH=`dirname ${SCRIPT}`
SCRIPTNAME=`basename ${SCRIPT}`
cd ${SCRIPTPATH}
set -euo pipefail

sudo docker build \
    -f deepstream.dockerfile \
    -t deepstream:7.0 \
    .

exit $?
