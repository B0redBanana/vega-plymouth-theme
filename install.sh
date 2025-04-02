#!/usr/bin/env bash

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

read -p "1: Arch, 2: Debian, 3: Ubuntu, 4: Fedora: " DISTRO

case $DISTRO in

############
### ARCH ###
############

        1)
            echo "Choose a Resolution:"
            read -p "1: Small (270x270px), 2: Medium (540x540px), 3: Large (1080x1080px): " size_select
            if test -z "$size_select";
            then
                size_select=1
            fi
            case "$size_select" in
            1)
                echo "Installing Small Resolution"
                cd $DIR/vega
                sudo cp -r vega-small /usr/share/plymouth/themes/
                sudo plymouth-set-default-theme -R vega-small
                ;;
            2)
                echo "Installing Medium Resolution"
                cd $DIR/vega
                sudo cp -r vega-medium /usr/share/plymouth/themes/
                sudo plymouth-set-default-theme -R vega-medium
                ;;
            3)
                echo "Installing Large Resolution"
                cd $DIR/vega
                sudo cp -r vega-large /usr/share/plymouth/themes/
                sudo plymouth-set-default-theme -R vega-large
                ;;
            esac

            create_new_initramfs

            ;;

##############
### DEBIAN ###
##############

        2)

            echo "Choose a Resolution:"
            read -p "1: Small (270x270px), 2: Medium (540x540px), 3: Large (1080x1080px): " size_select
            if test -z "$size_select";
            then
                size_select=1
            fi

            case "$size_select" in
                1)
                    echo "Installing Small Resolution"
                    cd $DIR/vega
                    sudo cp -r vega-small /usr/share/plymouth/themes/
                    sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/vega-small/vega-small.plymouth 100
                    ;;
                2)
                    echo "Installing Medium Resolution"
                    cd $DIR/vega
                    sudo cp -r vega-medium /usr/share/plymouth/themes/
                    sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/vega-medium/vega-medium.plymouth 100
                    ;;
                3)
                    echo "Installing Large Resolution"
                    cd $DIR/vega
                    sudo cp -r vega-large /usr/share/plymouth/themes/
                    sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/vega-large/vega-large.plymouth 100
                    ;;
            esac
            
            
                echo "Running update-alternatives"
                sudo update-alternatives --config default.plymouth

create_new_initramfs

##############
### Ubuntu ###
##############

        3)

            echo "Choose a Resolution:"
            read -p "1: Small (270x270px), 2: Medium (540x540px), 3: Large (1080x1080px): " size_select
            if test -z "$size_select";
            then
                size_select=1
            fi

            case "$size_select" in
                1)
                    echo "Installing Small Resolution"
                    cd $DIR/vega
                    sudo cp -r vega-small /usr/share/plymouth/themes/
                    sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/vega-small/vega-small.plymouth 100
                    ;;
                2)
                    echo "Installing Medium Resolution"
                    cd $DIR/vega
                    sudo cp -r vega-medium /usr/share/plymouth/themes/
                    sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/vega-medium/vega-medium.plymouth 100
                    ;;
                3)
                    echo "Installing Large Resolution"
                    cd $DIR/vega
                    sudo cp -r vega-large /usr/share/plymouth/themes/
                    sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/vega-large/vega-large.plymouth 100
                    ;;
            esac
            
            
                echo "Running update-alternatives"
                sudo update-alternatives --config default.plymouth

create_new_initramfs

##############
### Fedora ###
##############

        4)

            echo "Choose a Resolution:"
            read -p "1: Small (270x270px), 2: Medium (540x540px), 3: Large (1080x1080px): " size_select
            if test -z "$size_select";
            then
                size_select=1
            fi

            case "$size_select" in
                1)
                    echo "Installing Small Resolution"
                    cd $DIR/vega
                    sudo cp -r vega-small /usr/share/plymouth/themes/
                    sudo plymouth-set-default-theme vega-small -R
                    ;;
                2)
                    echo "Installing Medium Resolution"
                    cd $DIR/vega
                    sudo cp -r vega-medium /usr/share/plymouth/themes/
                    sudo plymouth-set-default-theme vega-medium -R
                    ;;
                3)
                    echo "Installing Large Resolution"
                    cd $DIR/vega
                    sudo cp -r vega-large /usr/share/plymouth/themes/
                    sudo plymouth-set-default-theme vega-large -R
                    ;;
            esac
            
                echo "Setting Theme as Default"
                sudo update-alternatives --config default.plymouth

create_new_initramfs

esac

echo "Done!"


#################
### FUNCTIONS ###
#################

                
                create_new_initramfs() {
                echo "Refreshing Initramfs"
                if type update-initramfs &>/dev/null; then
                    update-initramfs -u &>/dev/null  
                elif type mkinitcpio &>/dev/null; then
                    mkinitcpio -P &>/dev/null
                elif type dracut &>/dev/null; then
                    dracut -f &>/dev/null
                else
                    echo "Warning: Could not rebuild initramfs!"
                fi
                }