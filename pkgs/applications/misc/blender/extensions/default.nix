# maintainers: mib
{ lib
, pkgs
, stdenv
, fetchurl
, unzip
}:
let
  inherit (builtins) elemAt;
  inherit (lib.strings) replaceStrings splitString;

  data = map
    builtins.fromJSON
    (lib.lists.filter
      (jsonl: jsonl != "")
      (splitString "\n" (builtins.readFile ./extensions.json)));

  mkBlenderExtension =
    { type
    , name
    , version
    , hash ? ""
    , passthru ? { }
    }:
      assert hash != "" || throw "hash cannot be automatically derived. This is a limitation of the Blender extension CDN URL scheme";

      stdenv.mkDerivation {
        pname = name;
        inherit version;

        src =
          let
            hashType = elemAt (splitString ":" hash) 0;
          in
          fetchurl {
            url = "https://extensions.blender.org/download/${hash}/${type}-${replaceStrings [ "_" ] [ "-" ] name}-v${version}.zip";
            ${hashType} = hash;
          };

        inherit passthru;

        nativeBuildInputs = [ unzip ];

        dontUnpack = true;
        dontConfigure = true;
        dontBuild = true;
        dontPatch = true;

        installPhase = ''
          LANG=en_US.UTF-8 unzip -qq $src -d $out
        '';
      };

  extensions =
    builtins.listToAttrs
      (map
        (data: {
          name = replaceStrings [ "_" ] [ "-" ] data.id;
          value = mkBlenderExtension {
            inherit (data) type version;
            name = data.id;
            hash = data.archive_hash;
            passthru = {
              #inherit (data) tags;
            };
          };
        })
        data);
in
lib.makeScope pkgs.newScope (_: extensions)
