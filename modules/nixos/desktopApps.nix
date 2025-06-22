{ pkgs, ... }: {
  services.usbmuxd.enable = true;
  environment.systemPackages = with pkgs; [
    arduino
    audacity
    firefox
    fractal # matrix messenger
    furnace # chiptune tracker
    gimp
    google-chrome
    ifuse # optional, to mount using 'ifuse'
    inkscape
    kicad
    libimobiledevice
    libreoffice
    musescore
    obs-studio
    openscad-unstable
    rpi-imager
    slack
    spotify
    thonny
    vlc
    zoom-us
  ];
}
