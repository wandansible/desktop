# {{ ansible_managed }}

if [ -z "${CODE_EXTENSIONS_DIR}" ]; then
  CODE_EXTENSIONS_DIR="/var/tmp/vscode-extensions-${USER}"
  export CODE_EXTENSIONS_DIR
fi

if [ ! -d "${CODE_EXTENSIONS_DIR}" ]; then
  mkdir "${CODE_EXTENSIONS_DIR}"
fi

if [ -f "/usr/share/applications/code.desktop" ] && [ ! -f "${HOME}/.local/share/applications/code.desktop" ]; then
  if [ ! -d "${HOME}/.local/share/applications/" ]; then
    mkdir -p "${HOME}/.local/share/applications/"
  fi
  cp "/usr/share/applications/code.desktop" "${HOME}/.local/share/applications/code.desktop"
  sed -i "s;^Exec=/usr/share/code/code --unity-launch;Exec=/usr/share/code/code --unity-launch --extensions-dir=${CODE_EXTENSIONS_DIR};" \
    "${HOME}/.local/share/applications/code.desktop"
  sed -i "s;^Exec=/usr/share/code/code --new-window;Exec=/usr/share/code/code --new-window --extensions-dir=${CODE_EXTENSIONS_DIR};" \
    "${HOME}/.local/share/applications/code.desktop"
fi
