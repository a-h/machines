{ pkgs, lib, accounts, ... }:
{
  programs.dconf = {
    enable = true;
    profiles = {
      user.databases = [
        {
          settings = {
            "org/gnome/shell" = {
              disabled-extentions = [
                "window-list@gnome-shell-extensions.gcampax.github.com"
                "apps-menu@gnome-shell-extensions.gcampax.github.com"
              ];
            };
            "org/gnome/desktop/background" = {
              picture-uri = "file://${pkgs.nixos-artwork.wallpapers.dracula.gnomeFilePath}";
              picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.dracula.gnomeFilePath}";
            };
            "org/gnome/nautilus/list-view" = {
              default-zoom-level = "small";
              use-tree-view = false;
              default-column-order = [
                "name"
                "size"
                "type"
                "owner"
                "group"
                "permissions"
                "mime_type"
                "where"
                "date_modified"
                "date_modified_with_time"
                "date_accessed"
                "date_created"
                "recency"
                "starred"
              ];
              default-visible-columns = [ "name" "size" "date_modified" ];
            };
            "org/gnome/settings-daemon/plugins/color" = {
              night-light-enabled = true;
              night-light-schedule-automatic = true;
              night-light-temperature = lib.gvariant.mkUint32 2700;
            };
            "org/gnome/terminal/legacy" = {
              default-show-menubar = false;
              schema-version = lib.gvariant.mkUint32 3;
              theme-variant = "default";
            };
            "org/gnome/terminal/legacy/profiles:" = {
              default = "5ddfe964-7ee6-4131-b449-26bdd97518f7";
              list = [ "5ddfe964-7ee6-4131-b449-26bdd97518f7" ];
            };
            "org/gnome/terminal/legacy/profiles:/:5ddfe964-7ee6-4131-b449-26bdd97518f7" = {
              audible-bell = true;
              background-color = "#000000";
              backspace-binding = "ascii-delete";
              bold-color-same-as-fg = true;
              cursor-blink-mode = "system";
              cursor-colors-set = false;
              cursor-shape = "block";
              delete-binding = "delete-sequence";
              font = "SauceCodePro Nerd Font 12";
              foreground-color = "#FFFFFF";
              highlight-colors-set = false;
              login-shell = false;
              palette = [ "#000000" "#aa0000" "#00aa00" "#aa5500" "#0000aa" "#aa00aa" "#00aaaa" "#aaaaaa" "#555555" "#ff5555" "#55ff55" "#ffff55" "#5555ff" "#ff55ff" "#55ffff" "#ffffff" ];
              scrollback-lines = lib.gvariant.mkInt32 10000;
              scrollbar-policy = "never";
              scroll-on-output = false;
              use-custom-command = false;
              use-system-font = false;
              use-theme-colors = false;
              visible-name = "NixOS";
            };
            "org/gnome/desktop/interface" = {
              clock-format = "24h";
              gtk-theme = "Adwaita-dark";
              color-scheme = "prefer-dark";
              clock-show-weekday = true;
              show-battery-percentage = true;
              clock-show-seconds = true;
            };
            "org/gnome/desktop/privacy" = {
              old-files-age = lib.gvariant.mkInt32 7;
              recent-files-max-age = lib.gvariant.mkInt32 7;
              remove-old-temp-files = true;
              remove-old-trash-files = true;
            };
            "org/gnome/settings-daemon/plugins/media-keys" = {
              custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
            };
            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
              name = "Terminal";
              command = "gnome-terminal";
              binding = "<Control><Alt>t";
            };
            "org/gnome/nautilus/preferences" = {
              default-folder-viewer = "list-view";
            };
            "org/gnome/nautilus/compression" = {
              default-compression-format = "7z";
            };
            "org/gnome/nautilus/icon-view" = {
              default-zoom-level = "small-plus";
            };
          };
        }
      ];
    };
  };

  services.xserver = {
    enable = true;
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
    desktopManager.gnome = {
      enable = true;
    };
  };

  # Set default desktopManager type to gnome-wayland, and add user icon.
  systemd.tmpfiles.rules =
    lib.forEach accounts (account: "f+ /var/lib/AccountsService/users/${account.username} 0600 root root - [User]\\nSession=gnome\\nIcon=/var/lib/AccountsService/icons/${account.username}\\nSystemAccount=false\\n")
    ++
    lib.forEach accounts (account: "L+ /var/lib/AccountsService/icons/${account.username} - - - - ${account.profileicon}");

  boot = {
    consoleLogLevel = 0;
    kernelParams = [
      "quiet"
      "splash"
      "plymouth.use-simpledrm=1"
    ];
    initrd.verbose = false;
    loader.timeout = 0;
    plymouth.enable = true;
  };

  # Touchpad/touchscreen support.
  services.libinput.enable = true;
  services.touchegg.enable = true; # x11-gestures support

  # Bluetooth support.
  hardware.bluetooth.enable = true;

  # Exclude certain xserver packages.
  services.xserver.excludePackages = [ pkgs.xterm ];

  environment.systemPackages = with pkgs; [
    dconf-editor
    adwaita-icon-theme
    adwaita-qt
  ];

  # GNOME terminal - replaces the console.
  programs.gnome-terminal.enable = true;

  services.gnome = {
    gnome-online-accounts.enable = true;
    gnome-keyring.enable = true;
    gnome-settings-daemon.enable = true;
  };

  # Exclude certain default gnome apps.
  # See https://github.com/NixOS/nixpkgs/blob/127579d6f40593f9b9b461b17769c6c2793a053d/nixos/modules/services/x11/desktop-managers/gnome.nix#L468 for a list of apps.
  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour # Tour
    gnome-logs # Logs
    yelp # Help
    epiphany # Web
    gnome-console # Console - basic terminal emulator, not very good
  ]);

  # Add udev rules.
  services.udev.packages = with pkgs; [
    gnome-settings-daemon
  ];

  qt = {
    enable = true;
    style = "adwaita";
    platformTheme = "gnome";
  };

  # Symlink fonts into /run/current-system/sw/share/X11/fonts
  fonts.fontDir.enable = true;

  # Install fonts
  fonts.packages = [
    pkgs.unstable.nerd-fonts.sauce-code-pro
    pkgs.unstable.nerd-fonts.blex-mono
  ];

  disabledModules = [ "services/ttys/kmscon.nix" ];
  imports = [
    ./kmscon.nix
  ];

  services.kmscon = {
    enable = true;
    fonts = [
      { name = "SauceCodePro Nerd Font"; package = pkgs.unstable.nerd-fonts.sauce-code-pro; }
    ];
    extraConfig = ''
      font-size=12
      hwaccel
    '';
    hwRender = true;
  };

  # High-performance version of D-Bus
  services.dbus.implementation = "broker";

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GSK_RENDERER = "ngl";
  };
}
