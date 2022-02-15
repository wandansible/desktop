# {{ ansible_managed }}

# Exit if run as root
[ "$(id -u)" -eq 0 ] && return 0

xdg_cache_local_path="/var/tmp/xdgcache-${USER}"

if [ -d "${xdg_cache_local_path}" ]; then
    # verify existing dir is suitable
    if [ ! -G "${xdg_cache_local_path}" ] || [ ! -w "${xdg_cache_local_path}" ]; then
        # else, make a new/secure one with mktemp
        xdg_cache_local_path="$(mktemp -d "${xdg_cache_local_path}-XXXXXX")"
    fi
else
    mkdir -p "${xdg_cache_local_path}"
    chmod 700 "${xdg_cache_local_path}"
fi

export XDG_CACHE_HOME="${xdg_cache_local_path}"
