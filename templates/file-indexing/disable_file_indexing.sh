# {{ ansible_managed }}

### Disable tracker file indexing ###
systemctl --user mask {{ desktop_tracker_services | join(" ") }} 2> /dev/null

if [ -x "/usr/bin/tracker" ]; then
  /usr/bin/tracker daemon -t > /dev/null
fi

### Disable baloo file indexing ###
CONFIG_DIR="${HOME}/.config"

if [ -n "${XDG_CONFIG_HOME}" ]; then
  CONFIG_DIR="${XDG_CONFIG_HOME}"
fi

if [ ! -d "${CONFIG_DIR}" ]; then
  mkdir -p "${CONFIG_DIR}"
fi

if [ ! -f "${CONFIG_DIR}/baloofilerc" ]; then
  echo -e "[Basic Settings]\nIndexing-Enabled=false" > "${CONFIG_DIR}/baloofilerc"
fi
