# {{ ansible_managed }}

# Exit if run as root
[ "$(id -u)" -eq 0 ] && return 0

# Exit if there isn't a DISPLAY attached
[ -z "${DISPLAY}" ] && return 0

SLACK_CACHE_SRC="${HOME}/.config/Slack/Cache"
SLACK_CACHE_HOME="/var/tmp/slackcache-${USER}"

if [ -d "${SLACK_CACHE_HOME}" ]; then
    # verify existing dir is suitable
    if [ ! -G "${SLACK_CACHE_HOME}" ] || [ ! -w "${SLACK_CACHE_HOME}" ]; then
        # else, make a new/secure one with mktemp
        SLACK_CACHE_HOME="$(mktemp -d "${SLACK_CACHE_HOME}-XXXXXX")"
    fi
else
    mkdir -p "${SLACK_CACHE_HOME}"
    chmod 700 "${SLACK_CACHE_HOME}"
fi

if ! mountpoint -q "${SLACK_CACHE_SRC}"; then
    if [ ! -d "${SLACK_CACHE_SRC}" ]; then
        mkdir -p "${SLACK_CACHE_SRC}"
        chmod 700 "${SLACK_CACHE_SRC}"
    fi

    if [ -z "$(ls -A "${SLACK_CACHE_SRC}")" ]; then
        # only mount if source directory is empty
        bindfs -o no-allow-other "${SLACK_CACHE_HOME}" "${SLACK_CACHE_SRC}"
    fi
fi
