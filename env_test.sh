#!/bin/bash

# configure environment for mHL
echo "Setting environment variables..."
echo "export MHL_ROOT=/home/vagrant/mhealthlab-deployable" >> ~/.profile
source ~/.profile
echo MHL_ROOT: $MHL_ROOT

echo "export MHL_LIBS=${MHL_ROOT}/libs" >> ~/.profile
source ~/.profile
echo MHL_LIBS: $MHL_LIBS

echo "export KAFKA_ROOT=${MHL_LIBS}/kafka" >> ~/.profile
source ~/.profile
echo KAFKA_ROOT: $KAFKA_ROOT

echo "export ELASTIC_ROOT=${MHL_LIBS}/elasticsearch" >> ~/.profile
source ~/.profile
echo ELASTIC_ROOT: $ELASTIC_ROOT

echo "Done"