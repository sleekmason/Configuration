#!/bin/bash
### Move the focus to a particular workspace using dmenu.

I3MSG=$(command -v i3-msg) || exit 1
JQ=$(command -v jq) || exit 2

## Using jq to extract the keys from the JSON array returned by i3-msg -t get_workspaces.
$I3MSG workspace $($I3MSG -t get_workspaces | $JQ -M '.[] | .name' | tr -d '"' | sort -u | dmenu -nb '#182026' -nf '#BDCED9' -sb '#325F75' -sf '#E1F4FF' -i "$@")
