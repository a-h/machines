# nixos

## Installation

### Set up internet

> [!NOTE]
> If you already have a wired connection, you can skip this step.

```bash
sudo systemctl start wpa_supplicant
sudo wpa_cli
> add_network
> set_network 0 ssid "your_ssid_here"
> set_network 0 psk "your_password_here"
> enable_network 0
> save_config
> quit
```

### Set password and lock root

Use a TTY shell to login as root, then set the user password.

```bash
passwd headb
```

Finally, delete the password for the root user and lock the root account.

```bash
sudo passwd -dl root
sudo usermod -L root
```

### Post-installation

#### GNOME theme for Firefox

source: [firefox-gnome-theme](https://github.com/rafaelmardojai/firefox-gnome-theme)

```bash
curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash
```

#### GPG

```bash
gpg --card-edit
> fetch
> quit
```

#### Gopass

Complete the first half of the setup form, then quit when reaching 'generating new key pair'.

```bash
gopass clone git@github.com:a-h/pass
```

## Troubleshooting

### No display output after GRUB

Try adding `nomodeset` to the kernel parameters in GRUB.

## Tasks

### nixos

Switch to the new nixos configuration.

```bash
sudo nixos-rebuild switch --flake .# --accept-flake-config
```

### home-manager

Switch to the new home-manager configuration for the current user.

```bash
home-manager switch --flake ".#$USER@`hostname`" 
```
