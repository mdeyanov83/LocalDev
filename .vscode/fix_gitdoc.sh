#!/bin/bash

# Redirect all stdout from this script to /dev/null
exec 1>/dev/null

# sleep 1

FILE=".vscode/settings.json"

# Modify "gitdoc.enabled" to false
sed -i 's/"gitdoc.enabled": true,/"gitdoc.enabled": false,/' "$FILE"

sleep 1

# Modify "gitdoc.enabled" back to true
sed -i 's/"gitdoc.enabled": false,/"gitdoc.enabled": true,/' "$FILE"

# No echo, no logs, totally silent
