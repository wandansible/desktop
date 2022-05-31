#!/bin/sh
# {{ ansible_managed }}

. /etc/profile.d/pulseaudio.state.sh

if [ -n "${PULSE_CONFIG_PATH}" ]; then
    echo "PULSE_CONFIG_PATH=${PULSE_CONFIG_PATH}"
fi

if [ -n "${PULSE_STATE_PATH}" ]; then
    echo "PULSE_STATE_PATH=${PULSE_STATE_PATH}"
fi

if [ -n "${PULSE_COOKIE}" ]; then
    echo "PULSE_COOKIE=${PULSE_COOKIE}"
fi
