{ stdenv, lib, fetchurl, dpkg,
autoPatchelfHook, makeDesktopItem, makeWrapper, patchelfUnstable, ffmpeg-full, wrapGAppsHook, p7zip,
libvaDriverName, pkgs
}:

stdenv.mkDerivation {
  pname = "Immersed";
  version = "6.3";

  src = fetchurl {
    url = "https://immersedvr.com/dl/Immersed-x86_64.AppImage";
    sha256 = "TiMhIuMMf+7zT7k0FyNmY7I+iXKMSRKE7dcG2Hwgd9Q=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook 
    p7zip
  ];

  buildInputs = with pkgs; [
    webkitgtk
    libpulseaudio
    gtk3
    pango
    gdk-pixbuf
    glib
    fontconfig
    cairo
    zlib
    glibc
    libva
    libGL
    mesa

    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXinerama
    xorg.libXtst
    xorg.libXxf86vm
    xorg.libSM
  ];

  unpackPhase = ''
    7z x $src 
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/va2

    install -Dm755 usr/bin/Immersed $out/bin/Immersed

    ln -s ${ffmpeg-full}/lib/libavcodec.so $out/lib/va2
    ln -s ${ffmpeg-full}/lib/libavdevice.so $out/lib/va2
    ln -s ${ffmpeg-full}/lib/libavfilter.so $out/lib/va2
    ln -s ${ffmpeg-full}/lib/libavformat.so $out/lib/va2
    ln -s ${ffmpeg-full}/lib/libavutil.so $out/lib/va2
    ln -s ${ffmpeg-full}/lib/libswresample.so $out/lib/va2
    ln -s ${ffmpeg-full}/lib/libswscale.so $out/lib/va2
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib
      --set-default LIBVA_DRIVER_NAME ${libvaDriverName} 
    )
  '';

  meta = {
    description = "Immersed VR agent for Linux";
    homepage = "https://immersedvr.com/";
    downloadPage = "https://immersedvr.com/dl/Immersed-x86_64.AppImage";
    license = lib.licenses.unfree;
    maintainers = [lib.maintainers.noneucat ];
    platforms = [ "x86_64-linux" ];
  };
}
