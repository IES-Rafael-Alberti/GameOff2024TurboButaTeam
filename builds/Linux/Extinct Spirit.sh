#!/bin/sh
echo -ne '\033c\033]0;gameoff2024\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Extinct Spirit.x86_64" "$@"
