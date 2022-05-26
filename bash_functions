#!/usr/bin/env bash -x

function path() {
    echo -e ${PATH//:/\\n}
}

function show_large_dpkg() {
# Show the largest installed dpkg packages
dpkg-query --show --showformat='${Package;-50}\t${Installed-Size}\n' | sort -k 2 -n | grep -v deinstall | awk '{printf "%.3f MB \t %s\n", $2/(1024), $1}'
}

function clean {
    set -x
    #Taken from https://askubuntu.com/a/1161181
    # Show free space
    sudo df -Th | grep -v fs
    # Will need English output for processing
    LANG=en_GB.UTF-8

    ## Clean apt cache
    sudo apt-get update
    sudo apt-get -f install
    sudo apt-get -y autoremove
    sudo apt-get clean

    ## Remove old versions of snap packages
    sudo snap list --all | while read snapname ver rev trk pub notes; do
        if [[ $notes = *disabled* ]]; then
            sudo snap remove "$snapname" --revision="$rev"
        fi
    done
    ## Set snap versions retain settings
    if [[ $(sudo snap get system refresh.retain) -ne 2 ]]; then sudo snap set system refresh.retain=2; fi
    sudo rm -f /var/lib/snapd/cache/*

    ## Remove old versions of Linux Kernel
    # This one-liner is deprecated since 18.04
    # dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs apt-get -y purge
    # New 2 lines to remove old kernels
   sudo dpkg --list | grep 'linux-image' | awk '{ print $2 }' | sort -V | sed -n '/'"$(uname -r | sed "s/\([0-9.-]*\)-\([^0-9]\+\)/\1/")"'/q;p' | sudo xargs apt-get -y purge
   sudo dpkg --list | grep 'linux-headers' | awk '{ print $2 }' | sort -V | sed -n '/'"$(uname -r | sed "s/\([0-9.-]*\)-\([^0-9]\+\)/\1/")"'/q;p' | sudo xargs apt-get -y purge

    ## Rotate and delete old logs
    sudo /etc/cron.daily/logrotate
    sudo find /var/log -type f -iname *.gz -delete
    sudo journalctl --rotate
    sudo journalctl --vacuum-time=1s

    sudo df -Th | grep -v fs
    set +x
}

function partition_space() {
    # Show available space on all partitions
    df -Th | grep -v fs
}

function copy() {
    xclip
}

function paste () {
    xclip -o
}

function penv () {
    source $(poetry env info --path)/bin/activate
}

# Add this to .bashrc or .zshrc or its equivalent
transfer(){ if [ $# -eq 0 ];then printf "No arguments specified.\nUsage:\n transfer <file|directory>\n ... | transfer <file_name>\n">&2;return 1;fi;if tty -s;then file="$1";file_name=$(basename "$file");if [ ! -e "$file" ];then printf "$file: No such file or directory\n">&2;return 1;fi;if [ -d "$file" ];then file_name="$file_name.zip" ,;(cd "$file"&&zip -r -q - .)|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null,;else cat "$file"|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;fi;else file_name=$1;curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;fi;}



