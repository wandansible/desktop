Ansible role: Desktop
=====================

Setup a desktop environment.
Install and configure a desktop environment: install up to
date browsers via snap, install slack and dropbox, configure
printers, manage sudoers to allow desktop owner to run some
commands with sudo, and apply optimisations to make NFS home
mounts work.

Requirements
------------

To use this role, the python package `jmespath` must be installed on the host running ansible.

Role Variables
--------------

```
ENTRY POINT: main - Setup a desktop environment

        Install and configure a desktop environment: install up to
        date browsers via snap, install slack and dropbox, configure
        printers, manage sudoers to allow desktop owner to run some
        commands with sudo, and apply optimisations to make NFS home
        mounts work.

OPTIONS (= is mandatory):

- desktop_bind_mounts
        Local home filesystem bind mounts to move individual
        directories off NFS
        [Default: (null)]
        elements: dict
        type: list

        OPTIONS:

        = dst
            Path for bind mount destination

            type: str

        = src
            Path for bind mount source

            type: str

- desktop_browser_snaps
        List of browser snap packages to install
        [Default: ['firefox', 'chromium', 'chromium-ffmpeg']]
        elements: str
        type: list

- desktop_dm
        Desktop display manager to install and configure
        [Default: (null)]
        type: str

- desktop_dm_configs
        Configuration for each display manager
        [Default: (null)]
        elements: dict
        type: list

        OPTIONS:

        = config
            Configuration for the display manager
            Top-level = name of the section
            Second-level = options and their values

            type: dict

        = dm
            Display manager

            type: str

- desktop_dm_paths
        List of display managers and their paths
        [Default: (null)]
        elements: dict
        type: list

        OPTIONS:

        = binary
            Path to display manager binary

            type: str

        = config_file
            Path to display manager configuration

            type: str

        = dm
            Display manager

            type: str

- desktop_dropbox_apt_key_fingerprint
        The apt key fingerprint for the dropbox repo
        [Default: (null)]
        type: str

- desktop_dropbox_install
        If true, install dropbox
        [Default: False]
        type: bool

- desktop_env
        Desktop environment to install and use. Use 'tasksel --list-
        tasks' to get list of possible desktop environments. Defaults
        to ubuntu-desktop on Ubuntu and gnome-desktop on Debian.
        [Default: (null)]
        type: str

- desktop_env_default_dms
        List of desktop environments and their default display
        managers
        [Default: (null)]
        elements: dict
        type: list

        OPTIONS:

        = dm
            Default display manager

            type: str

        = env
            Desktop environment

            type: str

- desktop_env_sessions
        List of desktop environments and their session names
        [Default: (null)]
        elements: dict
        type: list

        OPTIONS:

        = env
            Desktop environment

            type: str

        = session
            Session name (where name is the name of the session
            .desktop file from /usr/share/xsessions/*.desktop)

            type: str

- desktop_nfs_home
        If true, apply NFS home mount optimisations
        [Default: False]
        type: bool

- desktop_printer_drivers
        List of printer drivers to download and install
        [Default: (null)]
        elements: dict
        type: list

        OPTIONS:

        = checksum
            Checksum of the driver

            type: str

        - checksum_type
            Type of checksum
            [Default: sha256]
            type: str

        - extract_file
            Path for the file to extract if the driver is compressed
            [Default: (null)]
            type: str

        - file_extension
            File extension added to the driver
            [Default: .ppd]
            type: str

        = name
            Name of the driver

            type: str

        = url
            URL for the driver

            type: str

- desktop_printers
        List of printers to configure
        [Default: (null)]
        elements: dict
        type: list

        OPTIONS:

        - auth
            Authentication required for printing
            [Default: none]
            type: str

        - driver
            Driver path (use paths from the command 'lpinfo -m')
            [Default: everywhere]
            type: str

        - model
            Additional model name if the driver supports multiple
            models
            [Default: (null)]
            type: str

        = name
            Name of the printer

            type: str

        - page_size
            Default page size
            [Default: A4]
            type: str

        = uri
            URI for the printer

            type: str

- desktop_slack_apt_key_fingerprint
        The apt key fingerprint for the slack repo
        [Default: (null)]
        type: str

- desktop_slack_install
        If true, install slack
        [Default: False]
        type: bool

- desktop_slack_parameters
        Configuration for the slack defaults file
        [Default: {'repo_add_once': 'false',
        'repo_reenable_on_distupgrade': 'false'}]
        type: dict

- desktop_tracker_services
        List of GNOME File Indexing systemd services to disable when
        NFS optimisations are enabled
        [Default: (null)]
        elements: str
        type: list

- samba_workgroup
        The samba workgroup
        [Default: WORKPLACE]
        type: str

- snap_packages_install
        List of snap packages to install
        [Default: (null)]
        elements: dict
        type: list

        OPTIONS:

        - channel
            The release that is installed and tracked for updates
            [Default: stable]
            type: str

        - classic
            If true, put the snap in classic mode and disable security
            confinement
            [Default: False]
            type: bool

        = name
            Name of snap package

            type: str

- sudoers
        Configuration for sudoers
        [Default: (null)]
        elements: dict
        type: list

        OPTIONS:

        = contents
            Contents for the sudoers file

            type: str

        = file
            Name for file in the sudoers.d directory

            type: str
```

Installation
------------

This role can either be installed manually with the ansible-galaxy CLI tool:

    ansible-galaxy install git+https://github.com/wandansible/desktop,main,wandansible.desktop
     
Or, by adding the following to `requirements.yml`:

    - name: wandansible.desktop
      src: https://github.com/wandansible/desktop

Roles listed in `requirements.yml` can be installed with the following ansible-galaxy command:

    ansible-galaxy install -r requirements.yml

Example Playbook
----------------

    - hosts: desktops
      roles:
         - role: wandansible.desktop
           become: true
           vars:
             desktop_owner: example_user

             desktop_env: ubuntu-desktop

             desktop_dm_configs:
               - dm: gdm3
                 config:
                   org/gnome/login-screen:
                     disable-user-list: "true"
               - dm: sddm
                 config:
                   Users: {}
                   X11:
                     SessionLogFile: ""
               - dm: lightdm
                 config:
                   Seat:*:
                     allow-guest: "false"
                     greeter-hide-users: "true"
                     greeter-show-manual-login: "true"
                     user-session: "{{ (desktop_env_sessions | selectattr('env', 'equalto', desktop_env) | first).session }}"
             
             desktop_nfs_home: true

             samba_workgroup: example
             
             desktop_printers:
               - name: follow-me-queue
                 uri: smb://print.example.org/follow-me
                 driver: lsb/local/konica_minolta_bizhub_colour_series.ppd
                 model: C368
                 auth: username,password
             desktop_printer_drivers:
               - name: konica_minolta_bizhub_colour_series
                 url: https://p.knova.konicaminolta.com/PublicDownload/download?fileId=D637401A-F5F0-46D1-A37D-CECD4A338713
                 file_extension: .zip
                 checksum: d16a4cdce996c6a63376b6a9c4d33280ac0ff3bdbd88a006af88ebd3627accbb
                 extract_file: IT5PPDLinux_1100010000MU/English/CUPS1.2/KOC759UX.ppd

             sudoers:
               - file: cmnd_aliases
                 contents: |
                   Cmnd_Alias SOFTWARE = /usr/bin/apt-get, /usr/bin/apt, /usr/bin/snap
                   Cmnd_Alias SERVICES = /usr/sbin/service, /bin/systemctl
                   Cmnd_Alias PROCESSES = /usr/bin/renice, /bin/kill, /usr/bin/killall
                   Cmnd_Alias DOCKER = /usr/bin/docker
               - file: owner
                 contents: |
                   {{ desktop_owner }} ALL=(root) SOFTWARE, SERVICES, PROCESSES, DOCKER
