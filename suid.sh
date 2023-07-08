#!/bin/bash

defSUIDBinaries=("arping" "at" "bwrap" "chfn" "chrome-sandbox" "chsh" "dbus-daemon-launch-helper" "dmcrypt-get-device" "exim4" "fusermount" "gpasswd" "helper" "kismet_capture" "lxc-user-nic" "mount" "mount.cifs" "mount.ecryptfs_private" "mount.nfs" "newgidmap" "newgrp" "newuidmap" "ntfs-3g" "passwd" "ping" "ping6" "pkexec" "polkit-agent-helper-1" "pppd" "ssh-keysign" "su" "sudo" "traceroute6.iputils" "ubuntu-core-launcher" "umount" "VBoxHeadless" "VBoxNetAdpCtl" "VBoxNetDHCP" "VBoxNetNAT" "VBoxSDL" "VBoxVolInfo" "VirtualBoxVM" "vmware-authd" "vmware-user-suid-wrapper" "vmware-vmx" "vmware-vmx-debug" "vmware-vmx-stats" "Xorg.wrap")

gtfoBinsList=("aria2c" "arp" "ash" "awk" "base64" "bash" "busybox" "cat" "chmod" "chown" "cp" "csh" "curl" "cut" "dash" "date" "dd" "diff" "dmsetup" "docker" "ed" "emacs" "env" "expand" "expect" "file" "find" "flock" "fmt" "fold" "ftp" "gawk" "gdb" "gimp" "git" "grep" "head" "iftop" "ionice" "ip" "irb" "jjs" "jq" "jrunscript" "ksh" "ld.so" "ldconfig" "less" "logsave" "lua" "make" "man" "mawk" "more" "mv" "mysql" "nano" "nawk" "nc" "netcat" "nice" "nl" "nmap" "node" "od" "openssl" "perl" "pg" "php" "pic" "pico" "python" "readelf" "rlwrap" "rpm" "rpmquery" "rsync" "ruby" "run-parts" "rvim" "scp" "script" "sed" "setarch" "sftp" "sh" "shuf" "socat" "sort" "sqlite3" "ssh" "start-stop-daemon" "stdbuf" "strace" "systemctl" "tail" "tar" "taskset" "tclsh" "tee" "telnet" "tftp" "time" "timeout" "ul" "unexpand" "uniq" "unshare" "vi" "vim" "watch" "wget" "wish" "xargs" "xxd" "zip" "zsh")

cyan="\e[0;96m"
green="\e[0;92m"
white="\e[0;97m"
red="\e[0;91m"
blue="\e[0;94m"
yellow="\e[0;33m"
magenta="\e[0;35m"
reset="\e[0m"

barLine="------------------------------"

banner="${magenta}  ___ _   _ _ ___    _____  _ _   _ __  __ \n"
banner+="${yellow} / __| | | / |   \\  |__ / \\| | | | |  \\/  |\n"
banner+="${blue} \\__ \\ |_| | | |) |  |_ \\ .\` | |_| | |\\/| |\n"
banner+="${red} |___/\\___/|_|___/  |___/_|\\_|\\___/|_|  |_| ${cyan}@sicario\n"

listAllSUIDBinaries() {
    echo -e "${white}[${blue}#${white}] ${yellow}Finding/Listing all SUID Binaries .."
    echo -e "${white}$barLine"

    result=$(find / -perm /4000 2>/dev/null)

    while IFS= read -r bins; do
        echo -e "${yellow}$bins"
    done <<< "$result"

    echo -e "${white}$barLine\n\n"
    echo "$result"
}

doSomethingPlis() {
    _bins=()
    binsInGTFO=()
    customSuidBins=()
    defaultSuidBins=()

    while IFS= read -r bins; do
        _binName=$(basename "$bins")

        if [[ ! " ${defSUIDBinaries[@]} " =~ " ${_binName} " ]]; then
            customSuidBins+=("$bins")

            if [[ " ${gtfoBinsList[@]} " =~ " ${_binName} " ]]; then
                binsInGTFO+=("$bins")
            fi

        else
            defaultSuidBins+=("$bins")
        fi
    done <<< "$1"

    echo -e "${white}[${red}!${white}] Default Binaries (Don't bother)"
    echo "$barLine"
    for bins in "${defaultSuidBins[@]}"; do
        echo -e "${blue}$bins"
    done
    echo -e "${white}$barLine\n\n"

    echo -e "${white}[${cyan}~${white}] ${cyan}Custom SUID Binaries (Interesting Stuff)"
    echo -e "${white}$barLine"
    for bins in "${customSuidBins[@]}"; do
        echo -e "${cyan}$bins"
    done
    echo -e "${white}$barLine\n\n"

    if [[ ${#binsInGTFO[@]} -ne 0 ]]; then
        echo -e "[${green}#${white}] ${green}SUID Binaries in GTFO bins list (Hell Yeah!)"
        echo -e "${white}$barLine"

        for bin in "${binsInGTFO[@]}"; do
            pathOfBin=$(command -v "$bin")
            gtfoUrl="https://gtfobins.github.io/gtfobins/$(basename "$bin")/#suid"
            echo -e "${green}$pathOfBin${white} -~> ${magenta}$gtfoUrl"
        done

        echo -e "${white}$barLine\n\n"

    else
        echo -e "[${green}#${white}] ${green}SUID Binaries found in GTFO bins.."
        echo -e "${white}$barLine"
        echo -e "[${red}!${white}] ${magenta}None ${red}:("
        echo -e "${white}$barLine\n\n"
    fi
}

note() {
    echo -e "${white}[${green}+${white}] ${green}Note: ${yellow}Might take some time depending on the system.${reset}"
}

clear
echo -e "$banner"

note
echo -e "${white}[${green}+${white}] ${green}Starting.."
echo -e "${white}$barLine\n"

allSUIDBinaries=$(listAllSUIDBinaries)
doSomethingPlis "$allSUIDBinaries"

echo -e "${white}[${green}+${white}] ${green}Done.${reset}"

exit 0
