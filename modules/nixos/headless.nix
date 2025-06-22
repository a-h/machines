{ lib, usernames, ... }:
{
  # Allow passwordless sudo for the wheel group.
  security.sudo.wheelNeedsPassword = false;

  # Disable password-based login to the user accounts.
  users.users = lib.genAttrs usernames (username: { hashedPassword = "!"; });

  # --- Minimal profile options below ---
  documentation = {

    enable = lib.mkDefault false;
    doc.enable = lib.mkDefault false;
    info.enable = lib.mkDefault false;
    man.enable = lib.mkDefault false;
    nixos.enable = lib.mkDefault false;
  };

  environment = {
    # Perl is a default package.
    defaultPackages = lib.mkDefault [ ];
    stub-ld.enable = lib.mkDefault false;
  };

  programs = {
    # The lessopen package pulls in Perl.
    less.lessopen = lib.mkDefault null;
    command-not-found.enable = lib.mkDefault false;
  };

  # This pulls in nixos-containers which depends on Perl.
  boot.enableContainers = lib.mkDefault false;

  services = {
    logrotate.enable = lib.mkDefault false;
    udisks2.enable = lib.mkDefault false;
  };

  xdg = {
    autostart.enable = lib.mkDefault false;
    icons.enable = lib.mkDefault false;
    mime.enable = lib.mkDefault false;
    sounds.enable = lib.mkDefault false;
  };
}
