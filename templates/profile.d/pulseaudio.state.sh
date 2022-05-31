# {{ ansible_managed }}

# Exit if run as root
[ "$(id -u)" -eq 0 ] && return 0

pulseaudio_local_path="/var/tmp/pulseaudio-${USER}"

if [ -d "${pulseaudio_local_path}" ]; then
    # verify existing dir is suitable
    if [ ! -G "${pulseaudio_local_path}" ] || [ ! -w "${pulseaudio_local_path}" ]; then
        # else, make a new/secure one with mktemp
        pulseaudio_local_path="$(mktemp -d "${pulseaudio_local_path}-XXXXXX")"
    fi
else
    mkdir -p "${pulseaudio_local_path}"
    chmod 700 "${pulseaudio_local_path}"
fi

export PULSE_CONFIG_PATH="${pulseaudio_local_path}"
export PULSE_STATE_PATH="${pulseaudio_local_path}"
export PULSE_COOKIE="${pulseaudio_local_path}/cookie"
