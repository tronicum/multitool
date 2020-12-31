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
    echo discovering uname
    binary $1
    # autosave to env?
    # in binary() or discover() ?
}

function export_var() {
    export $1=$2
}

if [ $# -eq 0 ]
  then
    echo "I am the werfty multitool 0.1.0

do you want to run 

wmt discover

to detect the environment?

if have been called via '$0'"
else
  if  [ "$1" == "discover" ]
  then
    discover uname
  fi
  # we need an conditional for verbose output
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

  if  [ $1 == "install" ]
    then
    discover brew
    export_var binary_brew 1
    echo $binary_brew
    if [[ "$binary_brew" -eq 1 ]]
    then
    echo "I can install stuff via brew

use $1 install tool <tool name>"
    fi
    install
  fi

  # brew install tool something
  # we need a better parameter parser and check for the tools to be installed better
  #if  [[ $1 -eq "install" ]] && [[ $2 -eq "tools" ]]
  #installer_brew=1
  export_var installer_brew 1
echo $2
  if  [ $2 == "tool" ]
  then
   echo "2nd is tool" #debug
  fi
  if  [ $2 == "tool" ] && [[ $installer_brew -eq 1 ]]
  # we need to check for $3
  then
   echo "i will use brew" #debug
   brew install $3
  fi

echo ok
fi
