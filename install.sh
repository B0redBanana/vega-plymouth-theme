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
                        echo "Using update-initramfs..."
                        update-initramfs -u

                    elif command -v mkinitcpio &>/dev/null; then
                        echo "Using mkinitcpio..."
                        mkinitcpio -P

                    elif command -v dracut &>/dev/null; then
                        echo "Using dracut..."
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

                    if [[ ! -d "$SCRIPT_DIR/vega/$theme" ]]; then
                        echo "Error: Theme directory '$theme' not found."
                        exit 1
                    fi

                    echo "Installing $theme to /usr/share/plymouth/themes/$theme"
                    cp -r "$SCRIPT_DIR/vega/$theme" "/usr/share/plymouth/themes/$theme"
                }

echo
echo "================================="
echo "  VEGA Plymouth Theme Installer  "
echo "================================="
echo

echo
echo "Choose your Distribution:"
echo "1) Arch"
echo "2) Debian / Ubuntu"
echo "3) Fedora"
echo

### Getting Distro ###

read -rp "Select [1-3]: " distro

case "$distro" in
    1)
        distro_name="Arch"
        ;;

    2)
        distro_name="Debian / Ubuntu"
        ;;

    3)
        distro_name="Fedora"
        ;;

    *)
        echo "Invalid selection."
        exit 1
        ;;
esac

### Getting preferred size ###

echo
echo "Preferred resolution:"
echo "1) Small  (270x270px)"
echo "2) Medium (540x540px)"
echo "3) Large  (1080x1080px)"
echo

read -rp "Select [1-3] (default 1): " size_select

size_select=${size_select:-1}

case "$size_select" in
    1)
        theme="vega-small"
        resolution="270x270px"
        ;;

    2)
        theme="vega-medium"
        resolution="540x540px"
        ;;

    3)
        theme="vega-large"
        resolution="1080x1080px"
        ;;

    *)
        echo "Invalid selection. Defaulting to Small (270x270px)"
        theme="vega-small"
        resolution="270x270px"
        ;;
esac

echo
echo "==========="
echo "  Summary  "
echo "==========="
echo
echo "Distribution : $distro_name"
echo "Resolution   : $resolution"
echo

read -rp "Continue with installation? [Y/n]: " confirm
confirm=${confirm:-Y}

case "$confirm" in
    [Yy]|[Yy][Ee][Ss])
        ;;
    [Nn]|[Nn][Oo])
        echo
        echo "Installation cancelled."
        exit 0
        ;;
    *)
        echo
        echo "Invalid choice. Installation cancelled."
        exit 1
        ;;
esac

### Starting Installation ###

case $distro in

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
                update-alternatives \
                    --install \
                    /usr/share/plymouth/themes/default.plymouth \
                    default.plymouth \
                    /usr/share/plymouth/themes/"$theme"/"$theme".plymouth \
                    100

                echo    
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