{ lib
, stdenv
, fetchFromGitHub
, boost
, openssl
, zlib
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "i2pd-tools";
  version = "a5eed1682e679457ba402585ddf588a2be2eed4e";

  src = fetchFromGitHub {
    owner = "PurpleI2P";
    repo = "i2pd-tools";
    rev = finalAttrs.version;
    hash = "sha256-rYeq0sbP/1Ztya3ONxFi/ciA3b9V08MCah+CQIS/WJM=";
    deepClone = true;
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    boost
    openssl
    zlib
  ];

  outputs = [
    "out"
    "routerinfo"
    "keygen"
    "vain"
    "keyinfo"
    "regaddr"
    "regaddr_3ld"
    "x25519"
    "famtool"
  ];

  installPhase =
    let
      binaries = builtins.filter (e: e != "out") finalAttrs.outputs;
      allBinaries = builtins.foldl' (acc: output: "${acc} ${output}") "" binaries;
      copyBinariesToOutputs = builtins.foldl'
        (acc: output:
          let bin = "\$${output}/bin"; in acc + ''
            mkdir -p ${bin} && install -Dm755 ${output} ${bin};
          '')
        ""
        binaries;
    in
    ''
      runHook preInstall

      mkdir -p $out/bin
      install -Dm755 ${allBinaries} $out/bin

      ${copyBinariesToOutputs}

      runHook postInstall
    '';

  meta = with lib; {
    description = "A mod manager for FTL: Faster Than Light";
    homepage = "https://github.com/Vhati/Slipstream-Mod-Manager";
    license = licenses.gpl2;
    maintainers = with maintainers; [ mib ];
  };
})
