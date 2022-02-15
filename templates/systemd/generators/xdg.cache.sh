#!/bin/sh
# {{ ansible_managed }}

. /etc/profile.d/xdg.cache.sh

if [ -n "${XDG_CACHE_HOME}" ]; then
    echo "XDG_CACHE_HOME=${XDG_CACHE_HOME}"
fi
