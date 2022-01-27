#!/bin/bash

error() {
  printf '\e[31m'; 
  printf "$@"; 
  echo '\e[0m'
}

is_user_root() { [ "$(id -u)" -eq 0 ]; }

if !(is_user_root); then 
    error "Please run as root"
    exit 1
fi

GRUP_PATH="/etc/default/grub"
NEWLINE="
"

sudo cp $GRUP_PATH "${GRUP_PATH}.bak"

file=""

while IFS= read -r line 
do
    if [[ "${line}" =~ ^GRUB_CMDLINE_LINUX_DEFAULT=\"([^\"]*)\" ]]; then
        param="${BASH_REMATCH[1]}"
        echo param
        if [[ "${param}" != *"video=hyperv_fb:1920×1080"* ]]; then
            file="${file}GRUB_CMDLINE_LINUX_DEFAULT=\"${param} video=hyperv_fb:1920×1080\"${NEWLINE}"
        else
            file="${file}${line}${NEWLINE}"
        fi
    else 
        file="${file}${line}${NEWLINE}"
    fi
done < "${GRUP_PATH}"

echo "${file}"


