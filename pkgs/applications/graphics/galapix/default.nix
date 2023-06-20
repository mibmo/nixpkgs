{
  lib,
  stdenv,
  fetchFromGitLab,
  mesa,
  rar,
  librsvg,
  p7zip,
  gnutar,
  nufraw,
  xcftools,
  unzip,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "galapix";
  version = "0.2.1";

  src = fetchFromGitLab {
    owner = finalAttrs.pname;
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-76F5d+A8yeFqL4FEcAy3SRRUWyYIBId6tgkB17sROjM=";
  };

  sconsFlags = [
    "GALAPIX_SDL=True"
    "GALAPIX_GTK=False"
  ];

  installPhase = "install -D build/galapix.sdl -t $out/bin/";

  # missing vidthumb package
  # --set GALAPIX_VIDTHUMB "${vidthumb}/bin/vidthumb" \
  postFixup = ''
    wrapProgram $out/bin/galapix.sdl \
      --prefix LIBGL_DRIVERS_PATH ":" "${mesa.drivers}/lib/dri" \
      --prefix LD_LIBRARY_PATH ":" "${mesa.drivers}/lib" \
      --set LIBGL_DRIVERS_PATH "${mesa.drivers}/lib/dri" \
      --set GALAPIX_RAR "${rar}/bin/rar" \
      --set GALAPIX_RSVG "${librsvg}/bin/rsvg" \
      --set GALAPIX_7ZR "${p7zip}/bin/7zr" \
      --set GALAPIX_TAR "${gnutar}/bin/tar" \
      --set GALAPIX_UFRAW_BATCH "${nufraw}/bin/nufraw-batch" \
      --set GALAPIX_XCFINFO "${xcftools}/bin/xcfinfo" \
      --set GALAPIX_XCF2PNG "${xcftools}/bin/xcf2png" \
      --set GALAPIX_UNZIP "${unzip}/bin/unzip"
  '';


  meta = with lib; {
    description = "Zoomable image viewer for large collections of images";
    homepage = "https://gitlab.com/galapix/galapix";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mib ];
    platforms = lib.platforms.linux;
  };
})
