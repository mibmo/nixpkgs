{ lib
, stdenv
, fetchFromGitHub
, cmake
, qtbase
, qttools
, wrapQtAppsHook
}:
stdenv.mkDerivation (final: {
  pname = "klatexformula";
  version = "4.1.0";

  src = let
    tag = "KLF_${builtins.replaceStrings ["."] ["-"] final.version}";
  in fetchFromGitHub {
    owner = "klatexformula";
    repo = "klatexformula";
    rev = tag;
    hash = "sha256-0w9JlJoJz3EBkdxIGXPK1UsirGjX+fsc0Mf+hc5ZT4k=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ];

  doCheck = true;
  dontWrapQtApps = true;

  meta = with lib; {
    description = "Easy-to-use graphical application for generating
images from LaTeX equations";
    longDescription = ''
      This application provides an easy-to-use graphical user interface
      for generating images from LaTeX equations. These images can be
      dragged and dropped or copied and pasted into external applications
      (presentations, text documents, graphics...), or can be saved to
      disk in a variety of formats (PNG, JPG, BMP, EPS, PDF, etc.). In
      addition to the graphical user interface, a command-line interface
      and a C++ library is provided to perform the same job.
    '';
    homepage = "https://github.com/klatexformula/klatexformula";
    license = licenses.gpl2;
    maintainers = with maintainers; [ mib ];
  };
})
