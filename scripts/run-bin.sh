#!/bin/bash
#
# Runs Processing sketch binary
# (assumes binary has already been produced, using export.sh)
#
# Restarts process if it dies for any reason.

PROCESSING_JAVA=/usr/local/bin/processing-java

BASE_DIR=/home/pi/Augenlicht/
LOG_DIR="${BASE_DIR}logs/"
SKETCH_DIR="${BASE_DIR}Processing/"

SKETCH_NAME=Augenlicht

SKETCH_FULL=$SKETCH_DIR$SKETCH_NAME

BIN_DIR=application.linux-armv6hf/

BIN_FULL="${SKETCH_FULL}/$BIN_DIR$SKETCH_NAME"

COMMAND=$BIN_FULL

echo "Running sketch binary from:"
echo "${SKETCH_FULL}/$BIN_DIR"
echo ""

while true
do

LOG_FILE=$LOG_DIR$(date -d "today" +"%Y%m%d-%H%M").log

if pgrep $SKETCH_NAME > /dev/null
then
	echo "Sketch already running"
else
	echo "Running..."
	echo $COMMAND
	echo ""

	echo "Logging to:"
	echo $LOG_FILE
	echo ""

	$COMMAND > $LOG_FILE
fi

sleep 1

echo ""
echo "xXx"
echo "died."
echo ""
echo "Restarting..."
echo ""

killall java

sleep 1

done
