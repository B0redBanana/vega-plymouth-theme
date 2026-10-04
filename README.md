<h1 align="center">VEGA Plymouth Theme</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Maintained%3F-Yes-green?style=for-the-badge">
  <img src="https://img.shields.io/github/issues/B0redBanana/vega-plymouth?color=violet&style=for-the-badge">
</p>

<p align="center">
A Plymouth boot splash theme using <a href="https://steamcommunity.com/groups/VEGA-Gaming-Group">VEGA's</a> logo.
<strong>Preview</strong><br>

<img src="https://github.com/B0redBanana/vega-plymouth/blob/8697b7d5202bf335ef6f1677ece687d5e6515028/preview/logo.gif" alt="preview gif">

</p>

## What is Plymouth?

[Plymouth](http://www.freedesktop.org/wiki/Software/Plymouth) is a project from Fedora and now listed among the [freedesktop.org's official resources](https://www.freedesktop.org/wiki/Software/#graphicsdriverswindowsystemsandsupportinglibraries) providing a flicker-free graphical boot process. It relies on [kernel mode setting](https://wiki.archlinux.org/index.php/Kernel_mode_setting) (KMS) to set the native resolution of the display as early as possible, then provides an eye-candy splash screen leading all the way up to the login manager.

## Prerequisites

To use the theme, you need to have Plymouth installed and configured on your system. For help with that, please refer to your distribution's wiki.

- [ArchWiki: Plymouth](https://wiki.archlinux.org/title/Plymouth) 

- [Ubuntu Wiki: Plymouth](https://wiki.ubuntu.com/Plymouth)

Fedora users can also refer to the ArchWiki.

## Download

Download manually [here](https://github.com/B0redBanana/vega-plymouth-theme/archive/refs/heads/main.zip) and extract the archive.

or clone using:

```bash
git clone https://github.com/B0redBanana/vega-plymouth-theme.git
```

## Installation

### Using the Installation Script

1. Navigate to the downloaded directory:
   
   ```bash
   cd vega-plymouth-theme
   ```

2. Run the installation script
   
   ```bash
   ./install.sh
   ```

3. Follow the on-screen instructions

### Manual installation

This example is using the small version; replace "small" with "medium" or "large" if wanted:

1. Change into the directory containing the themes

```bash
cd vega-plymouth/vega
```

2. Copy the desired theme into the Plymouth folder

```bash
sudo cp -r vega-small /usr/share/plymouth/themes/
```

3. Set the theme as your default:

For *Arch Linux & Fedora*: 

```bash
sudo plymouth-set-default-theme -R vega-small
```

For *Debian & Ubuntu*: 

```bash
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/vega-small/vega-small.plymouth 100

sudo update-alternatives --config default.plymouth
```

4. Update your initramfs (use the one for your system):

```bash 
sudo mkinitcpio -P
```
```bash 
sudo update-initramfs -u
```
```bash 
sudo dracut -f
```

## Important Notes

+ This was created with resolution of 1920x1080
+ Since this is my first Bash script, feedback is welcome.
+ I have not tested this on a LUKS encrypted drive yet
+ This is my first actual GitHub project, so if anyone has tips and feedback and how to properly do things, please let me know :)
