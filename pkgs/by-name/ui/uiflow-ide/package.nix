{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uiflow-ide";
  version = "dunno";

  src = fetchFromGitHub {
    owner = "";
    repo = "a4";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AX5psz9+bLdFFeDR55TIrAWDAkhDygw6289OgIfOJTg=";
  };

  buildInputs = [
  ];

  meta = with lib; {
    description = "A dynamic terminal window manager";
    homepage = "https://www.a4term.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ mib ];
    platforms = platforms.linux;
  };
})
