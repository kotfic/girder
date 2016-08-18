#!/bin/bash

# Show the memory state; this lets us more quickly determine when the
# travis environment is bad
vmstat
if [ ${TRAVIS_PYTHON_VERSION:0:1} == "3" ]; then export PY3="true"; else export PY2="true"; fi
if [ -n "${PY3}" ]; then export MONGO_VERSION=3.0.7; export PY_COVG="OFF"; else export MONGO_VERSION=2.6.11; export PY_COVG="ON"; export DEPLOY=true; fi
if [ -n "${PY3}" ]; then export IGNORE_PLUGINS=hdfs_assetstore,metadata_extractor; fi
CACHE=$HOME/.cache source ./devops/scripts/install_mongo.sh
mkdir /tmp/db
(mongod --dbpath=/tmp/db >/dev/null 2>/dev/null || true ) &
mongod --version || true
CACHE=$HOME/.cache CMAKE_VERSION=3.4.3 CMAKE_SHORT_VERSION=3.4 source ./devops/scripts/install_cmake.sh
cmake --version
mkdir -p $HOME/.cache/node_modules || true
ln -sf $HOME/.cache/node_modules .
nvm install v2.3.3
npm install -g npm
node --version
npm --version
npm prune
pip install -U pip virtualenv
