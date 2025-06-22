{ inputs, lib, config, pkgs, usernames, accountFromUsername, ... }:
let
  trustedUsernames = builtins.filter (username: (accountFromUsername username).trusted) usernames;
in
{
  # Set regonal settings.
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "us";

  users.users.root.hashedPassword = "!"; # Disable root login.

  nix.settings = {
    trusted-users = trustedUsernames;
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
    download-buffer-size = 524288000; # 500MiB
  };

  # Add each input as a flake registry to make nix commands consistent.
  nix.registry = lib.mkOverride 10 ((lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs));

  # Add each input to the system channels, to make nix-command consistent too.
  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc =
    lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

  # Use next-gen nixos switch.
  system.switch = {
    enable = false;
    enableNg = true;
  };

  # Useful base packages for every system to have.
  environment.systemPackages = with pkgs; [
    git
    neovim
    p7zip

    pciutils
    usbutils
    inetutils
    killall
    btop
    dig
  ];

  networking.domain = lib.mkDefault "lan";
}
