#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq

curl --get --header 'accept: application/json' 'https://extensions.blender.org/api/v1/extensions/' | jq --compact-output '.data[]' > extensions.json
