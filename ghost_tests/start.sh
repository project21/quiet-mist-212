#!/bin/bash

cd ..
#RACK_ENV=test exec rails s -p 3333 &
RACK_ENV=test bundle exec unicorn -D -E test -p 3333
curl localhost:3333
