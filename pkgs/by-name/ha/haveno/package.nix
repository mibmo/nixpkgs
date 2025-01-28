{
  lib,
  fetchFromGitHub,
  stdenv,
  gradle,
  jre,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "haveno";
  version = "1.0.18";

  src = fetchFromGitHub {
    owner = "haveno-dex";
    repo = "haveno";
    rev = finalAttrs.version;
    hash = "sha256-5vk6IJsap0pIemJrgUqI4yi2VR9LqlzQnw9cQGoYtZs=";
  };

  nativeBuildInputs = [ gradle ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  # required for mitm-cache on Darwin
  __darwinAllowLocalNetworking = true;

  gradleFlags = [ "-Dfile.encoding=utf-8" ];
  #gradleBuildTask = "shadowJar";

  doCheck = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/haveno}
    cp build/libs/haveno-all.jar $out/share/haveno
    makeWrapper ${jre}/bin/java $out/bin/haveno \
      --add-flags "-jar $out/share/haveno/haveno-all.jar"
    runHook postInstall
  '';

  meta = {
    description = "A decentralized monero exchange network";
    homepage = "https://haveno.exchange";
    changelog = "https://github.com/haveno-dex/haveno/compare/1.0.17...1.0.18";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    platforms = with lib.platforms; linux;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ mib ];
  };
})
