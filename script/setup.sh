#!/bin/bash
set -e # Auto exit on error

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/colors.sh
source $DIR/versions.sh

BASE=$DIR/..
pushd $BASE

mkdir -p cache

pushd cache

if [ ! -f $BASE_IMAGE_VERSION_FILE ]; then
  cecho "-----> Downloading Kitematic base images..." $purple
  curl -L --progress-bar -o $BASE_IMAGE_VERSION_FILE https://s3.amazonaws.com/kite-installer/$BASE_IMAGE_VERSION_FILE
  cp $BASE_IMAGE_VERSION_FILE ../resources/$BASE_IMAGE_FILE
fi

if [ ! -f $BOOT2DOCKER_CLI_VERSION_FILE ]; then
  cecho "-----> Downloading Boot2docker CLI..." $purple
  curl -L -o $BOOT2DOCKER_CLI_VERSION_FILE https://github.com/boot2docker/boot2docker-cli/releases/download/v${BOOT2DOCKER_CLI_VERSION}/boot2docker-v${BOOT2DOCKER_CLI_VERSION}-linux-amd64
fi

if [ ! -f node-webkit-v0.10.3-linux-x64.tar.gz ]; then
  cecho "-----> Downloading node-webkit..." $purple
  curl -L -o node-webkit-v0.10.3-linux-x64.tar.gz http://dl.node-webkit.org/v0.10.3/node-webkit-v0.10.3-linux-x64.tar.gz
  tar -zxf node-webkit-v0.10.3-linux-x64.tar.gz -C .
fi

if [ ! -f mongodb-linux-x86_64-2.6.4.tgz ]; then
  cecho "-----> Downloading mongodb..." $purple
  curl -L -o mongodb-linux-x86_64-2.6.4.tgz https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.6.4.tgz
  tar -zxvf mongodb-linux-x86_64-2.6.4.tgz
  cp mongodb-linux-x86_64-2.6.4/bin/mongod $BASE/resources
  cp mongodb-linux-x86_64-2.6.4/GNU-AGPL-3.0 $BASE/resources/MONGOD_LICENSE.txt
fi

if [ ! -f "node-v0.10.29-linux-x64.tar.gz" ]; then
  cecho "-----> Downloading Nodejs distribution..." $purple
  curl -L -o node-v0.10.29-linux-x64.tar.gz http://nodejs.org/dist/v0.10.29/node-v0.10.29-linux-x64.tar.gz
  mkdir -p node
  tar -xzf node-v0.10.29-linux-x64.tar.gz --strip-components 1 -C node
  cp node/bin/node $BASE/resources/node
  cp node/LICENSE $BASE/resources/NODE_LICENSE.txt
fi

popd

pushd resources

if [ ! -f $VIRTUALBOX_FILE ]; then
  cecho "-----> Downloading virtualbox installer..." $purple
  curl -L --progress-bar -o $VIRTUALBOX_FILE http://download.virtualbox.org/virtualbox/4.3.14/VirtualBox-4.3.14-95030-Linux_amd64.run
fi

cp ../cache/$BOOT2DOCKER_CLI_VERSION_FILE $BOOT2DOCKER_CLI_FILE
chmod +x $BOOT2DOCKER_CLI_FILE

popd

NPM="$BASE/cache/node/bin/npm"
$NPM install

popd
