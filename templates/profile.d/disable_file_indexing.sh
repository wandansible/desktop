# {{ ansible_managed }}

# Exit if run as root
[ "$(id -u)" -eq 0 ] && return 0

# Exit if there isn't a DISPLAY attached
[ -z "${DISPLAY}" ] && return 0

if [ -x "/usr/bin/tracker" ]; then
    /usr/bin/tracker daemon -t > /dev/null
fi

### Disable baloo file indexing ###
if [ -x "/usr/bin/balooctl" ]; then
    if ! /usr/bin/balooctl status 2>&1 | grep "Baloo is currently disabled" >/dev/null; then
        /usr/bin/balooctl disable
    fi
fi
