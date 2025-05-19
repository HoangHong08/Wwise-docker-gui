#!/bin/bash

IMAGE_NAME="wwise-authoring-docker"
CONTAINER_NAME="wwise-container"
DOWNLOADS_DIR="$(pwd)/data"
WWISE_PROJECTS_DIR="$(pwd)/wwise_projects"
USER_ID=$(id -u)
PULSE_SOCKET="$XDG_RUNTIME_DIR/pulse/native"
PULSE_COOKIE="$HOME/.config/pulse/cookie"

mkdir -p "$DOWNLOADS_DIR" "$WWISE_PROJECTS_DIR"

docker stop $CONTAINER_NAME 2>/dev/null && docker rm $CONTAINER_NAME 2>/dev/null

docker run -it --rm \
    --name $CONTAINER_NAME \
    --security-opt seccomp=unconfined \
    --shm-size=2g \
    -e PULSE_SERVER=unix:"$PULSE_SOCKET" \
    -v "$PULSE_SOCKET":"$PULSE_SOCKET" \
    -v "$PULSE_COOKIE":"/home/docker/.config/pulse/cookie" \
    -v /etc/machine-id:/etc/machine-id:ro \
    --group-add $(getent group audio | cut -d: -f3) \
    -v "$DOWNLOADS_DIR":"/home/docker/Downloads" \
    -v "$WWISE_PROJECTS_DIR":"/home/docker/WwiseProjects" \
    -p 8080:8080 -p 5901:5901 \
    $IMAGE_NAME
