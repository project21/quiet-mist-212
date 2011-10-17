#!/bin/bash

rm screenshots/*
cd ..
# want to be able to just keep running the test server
if ! curl localhost:3333 --connect-timeout 1 2>/dev/null; then
  RAILS_ENV=test RACK_ENV=test bundle exec unicorn -D -E test -p 3333
fi
RAILS_ENV=test RACK_ENV=test bundle exec rails runner -e test script/clean-db.rb
curl localhost:3333
# make sure app is started
