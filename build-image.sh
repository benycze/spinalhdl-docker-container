#!/usr/bin/env bash
# Copyright 2023 by the SpinalHDL Docker contributors
# SPDX-License-Identifier: GPL-3.0-only
#
# Author(s): Pavel Benacek <pavel.benacek@gmail.com>

set -e 

# Check if docker/podman is available
CONTAINER_TOOL=""
if command -v docker > /dev/null; then
    CONTAINER_TOOL="docker"
elif command -v podman > /dev/null; then
    CONTAINER_TOOL="podman"
else
    echo "No container tool (podman, docker has been found)!"
    exit 1
fi

echo "${CONTAINER_TOOL} tool has been found ..."

# Clean the directory and buld the image
echo "Cleaning the folder ..."
git clean -d -f -f -x .

SPINAL_DIR="SPINAL"
echo "Downloading all repos ..."
if [ -e ${SPINAL_DIR} ];then
    echo "Removing previous ${SPINAL_DIR} folder ..."
    rm -rf ${SPINAL_DIR}
fi

mkdir ${SPINAL_DIR} && cd ${SPINAL_DIR}
git clone --recursive https://github.com/SpinalHDL/SpinalHDL
git clone --recursive https://github.com/SpinalHDL/SpinalTemplateSbt
git clone --recursive https://github.com/SpinalHDL/SpinalWorkshop.git
cd ..

echo "Building the Spinal docker image ..."
$CONTAINER_TOOL build --rm -t localhost/spinal-compiler --build-arg USER=$USER \
    --build-arg UID=`id -u` --build-arg GID=`id -g` --build-arg SPINAL_DIR=$SPINAL_DIR .

echo "Done!"
