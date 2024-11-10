{
  basicconfig = import ./basicconfig.nix;
  bluetooth = import ./bluetooth.nix;
  bootloader = import ./bootloader.nix;
  desktop = import ./desktop.nix;
  desktopapps = import ./desktopapps.nix;
  development = import ./development.nix;
  docker = import ./docker.nix;
  filesystems = import ./filesystems.nix;
  firewall = import ./firewall.nix;
  fonts = import ./fonts.nix;
  fzf = import ./fzf.nix;
  git = import ./git.nix;
  gpg = import ./gpg.nix;
  homemanager = import ./homemanager.nix;
  network = import ./network.nix;
  printer = import ./printer.nix;
  sdr = import ./sdr.nix;
  sound = import ./sound.nix;
  ssd = import ./ssd.nix;
  ssh = import ./ssh.nix;
  users = import ./users.nix;
  virtualbox = import ./virtualbox.nix;
  yubikey = import ./yubikey.nix;
  zsh = import ./zsh.nix;
}
