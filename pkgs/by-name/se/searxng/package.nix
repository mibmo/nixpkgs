{
  lib,
  python3,
  fetchFromGitHub,
  nixosTests,
}:

python3.pkgs.toPythonModule (
  python3.pkgs.buildPythonApplication rec {
    pname = "searxng";
    version = "0-unstable-2025-01-10";

    src = fetchFromGitHub {
      owner = "searxng";
      repo = "searxng";
      rev = "94a0b415ef587e013df9e7350667b752a3822e90";
      hash = "sha256-ZeFHsoQXmG2sZXhPY7aRTsAXmFGHNT5ig0c2Hy344vw=";
    };

    postPatch = ''
      sed -i 's/==/>=/' requirements.txt
    '';

    preBuild =
      let
        versionString = lib.concatStringsSep "." (
          builtins.tail (lib.splitString "-" (lib.removePrefix "0-" version))
        );
        commitAbbrev = builtins.substring 0 8 src.rev;
      in
      ''
        export SEARX_DEBUG="true";

        cat > searx/version_frozen.py <<EOF
        VERSION_STRING="${versionString}+${commitAbbrev}"
        VERSION_TAG="${versionString}+${commitAbbrev}"
        DOCKER_TAG="${versionString}-${commitAbbrev}"
        GIT_URL="https://github.com/searxng/searxng"
        GIT_BRANCH="master"
        EOF
      '';

    dependencies =
      with python3.pkgs;
      [
        babel
        brotli
        certifi
        fasttext-predict
        flask
        flask-babel
        isodate
        jinja2
        lxml
        msgspec
        pygments
        python-dateutil
        pyyaml
        redis
        typer
        uvloop
        setproctitle
        httpx
        httpx-socks
        markdown-it-py
      ]
      ++ httpx.optional-dependencies.http2
      ++ httpx-socks.optional-dependencies.asyncio;

    # tests try to connect to network
    doCheck = false;

    postInstall = ''
      # Create a symlink for easier access to static data
      mkdir -p $out/share
      ln -s ../${python3.sitePackages}/searx/static $out/share/

      # copy config schema for the limiter
      cp searx/limiter.toml $out/${python3.sitePackages}/searx/limiter.toml
    '';

    passthru = {
      tests = {
        searxng = nixosTests.searx;
      };
    };

    meta = with lib; {
      homepage = "https://github.com/searxng/searxng";
      description = "Fork of Searx, a privacy-respecting, hackable metasearch engine";
      license = licenses.agpl3Plus;
      mainProgram = "searxng-run";
      maintainers = with maintainers; [
        SuperSandro2000
        _999eagle
      ];
    };
  }
)
