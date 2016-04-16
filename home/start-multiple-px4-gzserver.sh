#!/usr/bin/env bash

./kill_sitl.sh
sleep 1

world_file=iris1.world

if [ -f "$1" ]; then
 world_file=$1
fi

sitl_num=`cat $world_file | grep "<uri>model://iris" | wc -l`
./sitl_multiple_run.sh $sitl_num

./gzserver.sh $world_file
