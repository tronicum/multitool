#!/bin/bash

function binary() {
    # https://stackoverflow.com/questions/592620/how-can-i-check-if-a-program-exists-from-a-bash-script
    type $1 >/dev/null 2>&1 || { echo >&2 "I wanted $1 but it's not installed."; exit 0; }
    echo found $1
    export binary_uname=1
}

function run() {
   ``$1`` $2
}

function install() {
    echo i need brew
}

function discover() {
    binary $1
}

function export_var() {
    export $1=$2
}


if [ $# -eq 0 ]
  then
    echo "I am the werfty multitool"
else
  if  [[ $1 -eq "discover" ]]
    then
    discover uname
  fi
  if [[ "$binary_uname" -eq 1 ]]
    then
      echo -n "you appear to be running "
      run uname
      run uname -a
      run uname -m
      run uname -r
       #we need an conditional if we want to persist binary_* and uname_*
      export_var uname_a `uname -a`
      export_var uname_m `uname -m`
      export_var uname_r `uname -r`
  fi
echo ok
fi
