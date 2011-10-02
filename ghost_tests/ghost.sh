#!/bin/bash

pushd ..
RACK_ENV=test unicorn -p 3333 &
popd
sleep 8
curl localhost:3333
ghostbuster
#kill -9 `ps -Af | grep ruby | grep 3333 | awk '{print $2}'`
kill `ps -Af | grep unicorn | grep 3333 | grep master | awk '{print $2}'`
