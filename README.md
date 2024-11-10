## Tasks

### switch

Requires: switch-nixos, switch-home-manager

Switch to the new nixos and home-manager configurations.

### switch-nixos

Switch to the new nixos configuration.

```bash
sudo nixos-rebuild switch --flake .# --accept-flake-config
```

### switch-home-manager

Switch to the new home-manager configuration for the current user.

```bash
home-manager switch --flake ".#$USER@`hostname`" 
```

### garbage-collect

Cleanup unused nix store paths, then print a summary.

```bash
nix-collect-garbage --quiet
```

### garbage-collect-delete

Deletes all but the current generation of NixOS and cleanup leftovers, then print a summary.

```bash
sudo nix-collect-garbage -d --quiet
```
