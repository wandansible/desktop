# {{ ansible_managed }}

# Exit if run as root
[ "$(id -u)" -eq 0 ] && return 0

# could be more paranoid, and not accept any previously defined XDG_CACHE_HOME
if [ -z "${XDG_CACHE_HOME}" ] ; then
    XDG_CACHE_HOME="/var/tmp/xdgcache-${USER}"
    export XDG_CACHE_HOME
fi

if [ -d "${XDG_CACHE_HOME}" ]; then
    # verify existing dir is suitable
    if [ ! -G "${XDG_CACHE_HOME}" ] || [ ! -w "${XDG_CACHE_HOME}" ]; then
        # else, make a new/secure one with mktemp
        XDG_CACHE_HOME="$(mktemp -d "${XDG_CACHE_HOME}-XXXXXX")"
        export XDG_CACHE_HOME
    fi
else
    mkdir -p "${XDG_CACHE_HOME}"
    chmod 700 "${XDG_CACHE_HOME}"
fi
