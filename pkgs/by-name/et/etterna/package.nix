{ lib
, stdenv
, fetchgit
, fetchFromGitHub
, python2
, writeShellScriptBin
, git
, cmake
, pkg-config
, openssl
, curl
, xorg
, libGLU
, libogg
, libpulseaudio
, alsa-lib
, libjack2
, ninja

, tree
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "etterna";
  version = "0.72.3";

  src = fetchFromGitHub {
    owner = "etternagame";
    repo = "etterna";
    rev = "v${finalAttrs.version}";
    hash = "sha256-t+orXcnEZWotFWTum1t5SRpnBG+Lx5pRz91VkFk/z2M=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    git
    openssl
    curl
    xorg.libX11
    xorg.libXrandr
    xorg.libXext
    libogg
    libGLU
    python2
    ninja
  ];

  propagatedBuildInputs = [
    libpulseaudio
    alsa-lib
    libjack2
  ];

  cmakeFlags = [ "-DWITH_CRASHPAD=OFF" "-G Ninja" ];

  #dontConfigure = true;
  #dontBuild = true;
  installPhase = ''
    ${tree}/bin/tree .
  '';

  meta = with lib; {
    description = "";
    homepage = "https://etternaonline.com";
    license = licenses.mit;
    maintainers = with maintainers; [ mib ];
  };
})
