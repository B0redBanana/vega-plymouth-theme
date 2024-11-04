#!/usr/bin/env bash

## Checking for elevated privileges

if [ "$EUID" -ne 0 ]; then
    echo
    echo "This script requires sudo privileges. Restarting with sudo..."
    sudo "$0" "$@"
    exit
fi

## Function for initramfs regeneration

create_new_initramfs() {
    if type update-initramfs &>/dev/null; then
        update-initramfs -u &>/dev/null
    elif type mkinitcpio &>/dev/null; then
        mkinitcpio -P &>/dev/null
    elif type dracut &>/dev/null; then
        dracut --force --verbose --kver "$(uname -r)"
    else
        echo "Warning: Could not rebuild initramfs!"
    fi
}

# Time to start the installer!

clear

# Looking for Plymouth's directory

while true; do
    echo
    echo "Enter Plymouth Directory Path"
    read -erp "Press Return for the Default - /usr/share/plymouth/: " location
    if test -z "$location"; then
        location="/usr/share/plymouth/themes"
    fi
    if test "${location: -1}" != "/"; then
        location="$location/"
    fi

    # Check if the directory exists and is not empty
    if [[ -d "$location" && "$(ls -A "$location")" ]]; then
        echo "Valid location! Continuing with installation to: $location"
        break
    else
        echo "Invalid path. Please check your input."
        sleep 1
    fi

done

DIR=$(pwd)

#clear

while true; do
    read -rp "
1: ArchLinux
2: Debian/Ubuntu
3: Fedora

Please choose your base distribution: " DISTRO

    case $DISTRO in

    1 | 3)
        echo
        echo "Pick your preferred resolution:"
        read -rp "
    1: Small (270x270px)
    2: Medium (540x540px)
    3: Large (1080x1080px): " size_select
        if test -z "$size_select"; then
            size_select=1
        fi
        case "$size_select" in
        1)
            echo
            echo "Installing 270x270px Option"
            echo
            cd "$DIR/vega" || exit
            cp -r vega-small "$location/"
            sleep 1
            echo "Files moved. Setting chosen theme as default."
            echo
            plymouth-set-default-theme -R vega-small
            sleep 1
            echo "Theme set. Updating initramfs"
            echo
            sleep 1
            create_new_initramfs
            ;;
        2)
            echo
            echo "Installing 540x540px Option"
            echo
            cd "$DIR/vega" || exit
            cp -r vega-medium "$location/"
            sleep 1
            echo "Files moved. Setting chosen theme as default."
            echo
            plymouth-set-default-theme -R vega-medium
            sleep 1
            echo "Theme set. Updating initramfs"
            echo
            sleep 1
            create_new_initramfs
            ;;
        3)
            echo
            echo "Installing 1080x1080px Option"
            echo
            cd "$DIR/vega" || exit
            cp -r vega-large "$location/"
            sleep 1
            echo "Files moved. Setting chosen theme as default."
            echo
            plymouth-set-default-theme -R vega-large
            sleep 1
            echo "Theme set. Updating initramfs"
            echo
            sleep 1
            create_new_initramfs
            ;;
        esac
        ;;

    2)
        echo
        echo "Pick your preferred resolution:"
        read -rp "
    1: Small (270x270px)
    2: Medium (540x540px)
    3: Large (1080x1080px): " size_select
        if test -z "$size_select"; then
            size_select=1
        fi

        case "$size_select" in
        1)
            echo
            echo "Installing 270x270px Option"
            echo
            cd "$DIR/vega" || exit
            cp -r vega-small "$location/"
            sleep 1
            echo "Files moved. Setting chosen theme as default."
            echo
            update-alternatives --install $location/default.plymouth default.plymouth $location/vega-small/vega-small.plymouth 100
            sleep 1
            echo "Theme set. Updating initramfs"
            echo
            sleep 1
            create_new_initramfs
            ;;
        2)
            echo
            echo "Installing 540x540px Option"
            echo
            cd "$DIR/vega" || exit
            cp -r vega-medium "$location/"
            sleep 1
            echo "Files moved. Setting chosen theme as default."
            echo
            update-alternatives --install $location/default.plymouth default.plymouth $location/vega-medium/vega-medium.plymouth 100
            sleep 1
            echo "Theme set. Updating initramfs"
            echo
            sleep 1
            create_new_initramfs
            ;;
        3)
            echo
            echo "Installing 1080x1080px Option"
            echo
            cd "$DIR/vega" || exit
            cp -r vega-large "$location/"
            sleep 1
            echo "Files moved. Setting chosen theme as default."
            echo
            update-alternatives --install $location/default.plymouth default.plymouth $location/vega-large/vega-large.plymouth 100
            sleep 1
            echo "Theme set. Updating initramfs"
            echo
            sleep 1
            create_new_initramfs
            ;;
        esac
        ;;

    *)
        echo
        echo "Invalid option. Please enter 1, 2, or 3."
        continue
        ;;

    esac
    break
done

echo
read -rp "Do you want to go back and install another default resolution? (y/n): " continue_choice
if [[ ! "$continue_choice" =~ ^[Yy]$ ]]; then
    echo
    echo "Bye!"
    echo
    echo "Thank you for downloading! :)"
    echo
    sleep 1
    exit 0
fi
