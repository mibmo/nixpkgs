{ lib
, stdenv
, fetchurl
, makeDesktopItem
, unzip
, autoPatchelfHook

  # ? = idk if necessary
, alsa-lib
, at-spi2-atk
, at-spi2-core # ?
, atk # ?
, cairo
, cups
, dbus # ?
, expat
, fontconfig # ?
, freetype # ?
, gdk-pixbuf
, glib # ?
, gtk3
, libXcomposite
, libXdamage
, libXfixes
, libXrandr
, libdrm
, libglvnd
, libnotify # ?
, libuuid
, libz
, mesa
, nspr
, nss
, pango
, wayland

, python3

  # debug
, tree
}:
stdenv.mkDerivation (finalAttrs: rec {
  pname = "m5burner";
  version = "3";

  src = fetchurl {
    url = "https://m5burner.m5stack.com/app/M5Burner-v${version}-beta-linux-x64.zip";
    hash = "sha256-oGLbbav6HiR/k0CLCgoBghe/1ohzO4z2WJCI9OMXYcU=";
  };

  sourceRoot = ".";

  buildInputs = [
    unzip # unpack zips
    autoPatchelfHook # patch stupid propreitary bullshit
    python3
  ];

  nativeBuildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core # ?
    atk # ?
    cairo
    cups
    dbus # ?
    expat
    fontconfig # ?
    freetype # ?
    gdk-pixbuf
    glib # ?
    gtk3
    libXcomposite
    libXdamage
    libXfixes
    libXrandr
    libdrm
    libglvnd
    libnotify # ?
    libuuid
    libz
    mesa
    nspr
    nss
    pango
    wayland

    python3
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,packages}
    ${tree}/bin/tree > $out/tree

    #cp -r bin/m5burner $out/bin/m5burner
    #cp -r packages $out/
    cp -r . $out/

    runHook postInstall
  '';

  /*
    desktopItem = makeDesktopItem {
    name = pname;
    };
  */

  meta = with lib;
    {
      description = "m5stack firmware burning tool";
      homepage = "https://docs.m5stack.com/en/download";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      license = licenses.unfree;
      maintainers = with maintainers; [ mib ];
      platforms = [ "x86_64-linux" ];
    };
})
