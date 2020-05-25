# {{ ansible_managed }}

SLACK_CACHE_SRC="${HOME}/.config/Slack/Cache"
SLACK_CACHE_HOME="/var/tmp/slackcache-${USER}"

if [ -d "${SLACK_CACHE_HOME}" ]; then
# verify existing dir is suitable
if ! `test -G "${SLACK_CACHE_HOME}" -a -w "${SLACK_CACHE_HOME}"` ; then
# else, make a new/secure one with mktemp
SLACK_CACHE_HOME="$(mktemp -d ${SLACK_CACHE_HOME}-XXXXXX)"
fi
else
mkdir -p "${SLACK_CACHE_HOME}" -m 700
fi

if ! mountpoint -q "${SLACK_CACHE_SRC}"; then
if [ ! -d "${SLACK_CACHE_SRC}" ]; then
mkdir -p "${SLACK_CACHE_SRC}" -m 700
fi
if [ -z "$(ls -A ${SLACK_CACHE_SRC})" ]; then
# only mount if source directory is empty
bindfs -o no-allow-other "${SLACK_CACHE_HOME}" "${SLACK_CACHE_SRC}"
fi
fi
