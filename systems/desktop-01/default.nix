{ inputs, nixosModules, useCustomNixpkgsNixosModule, accountsForSystem, accountFromUsername, hostname, ... }:
let
  system = "x86_64-linux";
  canLogin = [ "adrian" ];
  hasHomeManager = true;
in
{
  nixosConfiguration = inputs.nixpkgs.lib.nixosSystem {
    inherit system;

    specialArgs = {
      inherit inputs accountFromUsername;
      accounts = accountsForSystem canLogin;
      usernames = canLogin;
    };

    modules = with nixosModules; [
      useCustomNixpkgsNixosModule

      {
        networking.hostName = hostname;
        system.stateVersion = "25.05";
      }

      ./config.nix
      ./hardware.nix

      basicConfig
      bootloader
      desktop
      desktopApps
      development
      fileSystems
      fonts
      git
      gpg
      network
      printer
      sdr
      sound
      ssd
      ssh
      users
      virtualisation
      yubikey
      zsh
    ] ++ (if hasHomeManager then [ nixosModules.homeManager ] else [ ]);
  };
  inherit system canLogin hasHomeManager;
}
