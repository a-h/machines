{
  description = "NixOS configuration for my desktops, laptops, and local network.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi";
    disko.url = "github:nix-community/disko";
    agenix.url = "github:ryantm/agenix";

    edwardh-dev.url = "github:headblockhead/edwardh.dev";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, nixos-raspberrypi, disko, agenix, edwardh-dev, ... }@inputs:
    let
      # Which accounts can access which systems is handled per-system.
      accounts = [
        {
          username = "adrian";
          realname = "Adrian Hesketh";
          sshkeys = [
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4ZYYVVw4dsNtzOnBCTXbjuRqOowMOvP3zetYXeE5i+2Strt1K4vAw37nrIwx3JsSghxq1Qrg9ra0aFJbwtaN3119RR0TaHpatc6TJCtwuXwkIGtwHf0/HTt6AH8WOt7RFCNbH3FuoJ1oOqx6LZOqdhUjAlWRDv6XH9aTnsEk8zf+1m30SQrG8Vcclj1CTFMAa+o6BgGdHoextOhGMlTx8ESAlgIXCo+dIVjANE2qbfAg0XL0+BpwlRDJt5OcgzrILXZ1jSIYRW4eg/JBcDW/WqorEummxhB26Y6R0jeswRF3DOQhU2fAhbsCWdairLam42rFGlKfWyTbgjRXl/BNR"
          ];
          trusted = true; # Root access (trusted-user, wheel)
        }
      ];

      # Packages in nixpkgs that I want to override.
      nixpkgs-overlay = (
        final: prev: {
          # Make pkgs.unstable.* point to nixpkgs unstable.
          unstable = import inputs.nixpkgs-unstable {
            system = final.system;
            config = {
              allowUnfree = true;
            };
          };

          google-chrome = prev.google-chrome.overrideAttrs (oldAttrs: {
            commandLineArgs = [
              "--ozone-platform=wayland"
              "--disable-features=WaylandFractionalScaleV1"
            ];
          });
          gnome-keyring = prev.gnome-keyring.overrideAttrs (oldAttrs: {
            mesonFlags = (builtins.filter (flag: flag != "-Dssh-agent=true") oldAttrs.mesonFlags) ++ [
              "-Dssh-agent=false"
            ];
          });

          # Set pkgs.home-manager to be the flake version.
          home-manager = inputs.home-manager.packages.${final.system}.default;
        }
      );

      # Configuration for nixpkgs.
      nixpkgs-config = {
        allowUnfree = true;
      };

      # An array of every system folder in ./systems.
      systemNames = builtins.attrNames (inputs.nixpkgs.lib.filterAttrs (path: type: type == "directory") (builtins.readDir ./systems));

      # An array of all the NixOS modules in ./modules/nixos.
      nixosModuleNames = map (name: inputs.nixpkgs.lib.removeSuffix ".nix" name) (builtins.attrNames (builtins.readDir ./modules/nixos));
      # An attribute set of all the NixOS modules in ./modules/nixos.
      nixosModules = inputs.nixpkgs.lib.genAttrs nixosModuleNames (module: ./modules/nixos/${module}.nix);

      # An array of all the home-manager modules in ./modules/home-manager.
      homeManagerModuleNames = map (name: inputs.nixpkgs.lib.removeSuffix ".nix" name) (builtins.attrNames (builtins.readDir ./modules/home-manager));
      # An attribute set of all the home-manager modules in ./modules/home-manager.
      homeManagerModules = inputs.nixpkgs.lib.genAttrs homeManagerModuleNames (module: ./modules/home-manager/${module}.nix);

      # A filtered array of system names that have a home-manager module.
      systemNamesWithHomeManager = builtins.filter (system: (callSystem system).hasHomeManager) systemNames;
      # A function that takes a username and a system name and returns whether that user can log in to that system.
      canLoginToSystem = username: system: builtins.elem username (callSystem system).canLogin;

      # An array of the username of every account.
      usernames = builtins.map (account: account.username) accounts;
      # An array of every username@hostname pair that has home-manager enabled.
      usernamesAtHostsWithHomeManager = inputs.nixpkgs.lib.flatten (builtins.map (username: builtins.map (system: if canLoginToSystem username system then "${username}@${system}" else null) systemNamesWithHomeManager) usernames);

      # A mini-module that configures nixpkgs to use our custom overlay and configuration.
      useCustomNixpkgsNixosModule = {
        nixpkgs = {
          overlays = [ nixpkgs-overlay ];
          config = nixpkgs-config;
        };
      };

      # A function that returns for a given system's name:
      # - its NixOS configuration (nixosConfiguration)
      # - its system architecture (system)
      # - the accounts that can log in to it (canLogin)
      # - if the system uses home-manager (hasHomeManager)
      callSystem = (hostname: import ./systems/${hostname} {
        # Pass on the inputs and nixosModules.
        inherit inputs nixosModules hostname useCustomNixpkgsNixosModule;

        # Pass on a function that returns a filtered list of accounts based on an array of usernames.
        accountsForSystem = canLogin: builtins.filter (account: builtins.elem account.username canLogin) accounts;
        # Pass on a function that returns the account for a given username.
        accountFromUsername = username: builtins.elemAt (builtins.filter (account: account.username == username) accounts) 0;
      });
    in
    rec {
      inherit nixosModules homeManagerModules;

      # Gets the NixOS configuration for every system in ./systems.
      nixosConfigurations = inputs.nixpkgs.lib.genAttrs systemNames (hostname: (callSystem hostname).nixosConfiguration);

      # Generate a home-manager configuration for every user that can log in to a system with home-manager enabled.
      homeConfigurations = inputs.nixpkgs.lib.genAttrs usernamesAtHostsWithHomeManager (username-hostname:
        let
          username-hostname-split = builtins.split "@" username-hostname;
          username = builtins.elemAt username-hostname-split 0;
          hostname = builtins.elemAt username-hostname-split 2;
          architecture = (callSystem (builtins.head (builtins.filter (system: system == hostname) systemNames))).system;
        in
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.${architecture};
          extraSpecialArgs = { inherit inputs homeManagerModules username useCustomNixpkgsNixosModule; };
          modules = [ ./users/${username}.nix ];
        });
    };
}
