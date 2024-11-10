{ pkgs, ... }: {
  services.usbmuxd.enable = true;
  environment.systemPackages = with pkgs; [
    libimobiledevice
    ifuse # optional, to mount using 'ifuse'
    arduino
    audacity
    clonehero
    firefox
    gimp
    google-chrome
    kicad
    libreoffice
    unstable.musescore
    spotify
    unstable.rpi-imager
    vlc
  ];
}
