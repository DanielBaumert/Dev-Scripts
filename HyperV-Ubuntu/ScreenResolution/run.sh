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
RES="video=hyperv_fb:1920x1080"
NEWLINE="
"
file=""

# backup
sudo mv $GRUP_PATH "${GRUP_PATH}.bak"

while IFS= read -r line 
do
    if [[ ${line} =~ ^GRUB_CMDLINE_LINUX_DEFAULT=\"([^\"]*)\" ]]; then
        param="${BASH_REMATCH[1]}"
        if [[ $param =~ .*"${RES}".* ]]; then
            echo "${RES} already exists in '${param}'"
            file="${file}${line}${NEWLINE}"
        else
            echo "added ${RES} to GRUB_CMDLINE_LINUX_DEFAULT"
            file="${file}GRUB_CMDLINE_LINUX_DEFAULT=\"${param} ${RES}\"${NEWLINE}"
        fi
    else 
        file="${file}${line}${NEWLINE}"
    fi
done < "${GRUP_PATH}"

echo "${file}" > $GRUP_PATH

echo "Finish"