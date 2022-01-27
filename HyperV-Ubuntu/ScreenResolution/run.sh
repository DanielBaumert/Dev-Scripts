#!/bin/sh

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

sudo cp $GRUP_PATH "${GRUP_PATH}.bak"

file=""

while IFS= read -r line 
do
    if [[ $line =~ "^GRUB_CMDLINE_LINUX_DEFAULT=\"([^\"]+)\"" ]]; then
        echo "line"
    else 
        file="${file}${line}" 
    fi
done < "${GRUP_PATH}"


echo "${file}"


