#!/bin/bash

# PATH_INFO=/tileserver/info /tileserver/tileserver

# actionDirname="$(dirname $PATH_INFO)"
action="$(basename ${PATH_INFO})"

case $action in
  info)
    reply='{"api":"tileserver", "country":"xxx"}'
    echo "Content-type: application/json"
    echo ""
    echo "${reply}"
    exit 0
    ;;
    # https://api.openindoor.io/mbtiles/country/status/france
  # update)
  #   tileServerPID=$(ps x | grep "node /usr/src/app/" | grep -v "grep" | awk '{print $1}')
  #   kill -SIGHUP ${tileServerPID}
  #   reply='{"api":"tileserver", "status":"update"}'
  #   echo "Content-type: application/json"
  #   echo ""
  #   echo "${reply}"
  #   exit 0
  #   ;;

  *)              
esac 








