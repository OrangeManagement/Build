#!/bin/bash

strindex() {
  x="${1%%$2*}"
  [[ "$x" = "$1" ]] && echo -1 || echo "${#x}"
}

orgpath="$(pwd)"
repository="Karaka"
pos=$(strindex "$orgpath" "$repository")
length=$pos+${#repository}
rootpath=${orgpath:0:length}

. ${rootpath}/Build/Hooks/delegator.sh
