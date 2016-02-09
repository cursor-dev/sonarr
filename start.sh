#!/bin/bash

function handle_signal {
  PID=$!
  echo "received signal. PID is ${PID}"
  kill -s SIGHUP $PID
}

trap "handle_signal" SIGINT SIGTERM SIGHUP

chown -R media:users /volumes/config

echo "starting sonarr"
su - media -c "mono /opt/NzbDrone/NzbDrone.exe --no-browser -data=/volumes/config & wait"
echo "stopping sonarr"
