#!/bin/bash

#kill `ps -Af | grep ruby | grep 3333 | awk '{print $2}'`
kill `ps -Af | grep unicorn | grep 3333 | grep master | awk '{print $2}'`
