#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq sed

old_version="1.0.17"
current_version="1.0.18"
new_version="1.0.18"

changelog="https://github.com/haveno-dex/haveno/compare/${current_version}...${new_version}";

# update url in meta.changelog
sed -i 's/' package.nix

# update version.json
jq -n \
    --arg previous "$previous_version" \
    --arg current "$current_version" \
    '{"previous": $previous, "current": $current}' \
    > version.json
