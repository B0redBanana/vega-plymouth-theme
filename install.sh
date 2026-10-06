#!/usr/bin/env bash

set -euo pipefail

# Time to start the installer!

clear

## Checking for elevated privileges

if [ "$EUID" -ne 0 ]; then
    echo
    echo "This script requires sudo privileges. Restarting with sudo..."
    sudo "$0" "$@"
    exit
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

#################
### FUNCTIONS ###
#################

                create_new_initramfs() {
                    echo "Refreshing initramfs"
                    
                    if command -v update-initramfs &>/dev/null; then
                        update-initramfs -u 
                    elif command -v mkinitcpio &>/dev/null; then
                        mkinitcpio -P
                    elif command -v dracut &>/dev/null; then
                        dracut -f
                    else
                        echo "Error: Could not rebuild initramfs!"
                        exit 1
                    fi

                        echo
                        echo "Initramfs successfully rebuilt."

                }

                install_theme() {
                echo "Installing $theme"

                if [[ ! -d "$dir/vega/$theme" ]]; then
                echo "Theme directory '$theme' not found."
                exit 1
                fi

                echo "Installing $theme to /usr/share/plymouth/themes/$theme"
                cp -r "$dir/vega/$theme" "/usr/share/plymouth/themes/$theme"
                }

echo "================================="
echo "  VEGA Plymouth Theme Installer  "
echo "================================="
echo

echo "Please choose your Distribution:"
echo "1) Arch"
echo "2) Debian / Ubuntu"
echo "3) Fedora"
echo

### Getting Distro ###

read -rp "Select [1-4]: " DISTRO

case "$DISTRO" in
    1|2|3) ;;
    *)
        echo "Invalid selection"
        exit 1
        ;;
esac

### Getting preferred size ###

echo "Choose a Resolution:"
echo "1) Small  (270x270px)"
echo "2) Medium (540x540px)"
echo "3) Large  (1080x1080px)"
echo

read -rp "Select [1-3] (default 1): " size_select

size_select=${size_select:-1}

case "$size_select" in
    1)
        theme="vega-small"
        ;;
    2)
        theme="vega-medium"
        ;;
    3)
        theme="vega-large"
        ;;
    *)
        echo "Invalid selection. Defaulting to Small (270x270)"
        theme="vega-small"
        ;;
esac

### Starting Installation ###

case $DISTRO in

##############
###  Arch  ###
##############

        1)

            install_theme
            plymouth-set-default-theme "$theme"
            echo
            echo "Setting Theme as Default"
            echo

create_new_initramfs
;;

##############
### Debian ###
##############

        2)

            install_theme
            update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/"$theme"/"$theme".plymouth 100
            echo "Running update-alternatives"
            echo
            echo "Please choose the number corresponding to the installed theme."
            echo 
            update-alternatives --config default.plymouth

create_new_initramfs
;;

##############
### Fedora ###
##############

        3)

            install_theme
            plymouth-set-default-theme "$theme"
            echo
            echo "Setting Theme as Default"
            echo

create_new_initramfs
;;

esac

echo
echo "Done!"