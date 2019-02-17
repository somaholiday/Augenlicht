#!/bin/bash
#
# Exports a Processing sketch as a Linux binary

PROCESSING_JAVA=/usr/local/bin/processing-java

BASE_DIR=/home/pi/Augenlicht/
SKETCH_DIR="${BASE_DIR}Processing/"
SKETCH_NAME=Augenlicht

SKETCH_FULL=$SKETCH_DIR$SKETCH_NAME

BIN_DIR=application.linux-armv6hf/

BIN_FULL="${SKETCH_FULL}/$BIN_DIR$SKETCH_NAME"

COMMAND="$PROCESSING_JAVA --sketch=$SKETCH_FULL --export --platform=linux"

echo "Exporting application to:"
echo $BIN_FULL
echo ""

$COMMAND

echo "Done."
echo ""