# Nice to know stuff

## Preview font

Get `xfd`:

`sudo pacman -S xorg-xfd`

Preview your font from the CLI:

`xfd -fa <font-name>`

## Insert unicode into files

Using vim, type ctrl+v, u, then the last four hex digits of the unicode character. For example:

`^vufe54`

## Checking X11 key codes

`sudo pacman -S xorg-xev`

`xev -event keyboard | egrep -o 'keycode.*\)'`

## Fixing random bad startx

This is called early KMS start or something like that.

`sudo nano /etc/mkinitcpio.conf`

```
MODULES=(... amdgpu, ...)
```

## Finding out window names for i3

`xprop | grep -i -e '^wm_name\|^wm_class'`

Then click the window in question.

For `intel` use `intel_agp` and then `i915` instead.

## Installing node.js

Download whatever version of node you want that is suffixed with `-linux-x64.tar.gz`.

`extract node-versionnumber-linux-x64.tar.gz`

`cp node-versionnumber-linux-x64.tar.gz ~/.node`

Add this to your `.zsh_aliases`

```
export PATH=~/.node10/bin:$PATH
```

## Microsoft fonts

This assumes you're dual booting because I know I am.

Grab `ttf-ms-win10`:

`git clone https://aur.archlinux.org/ttf-ms-win10.git`

I'm assuming you're in `~/`, so I'll call the path to this `~/ttf-ms-win10`.

You'll need this library: `sudo pacman -S ntfs-3g`

Find the Windows install point, you can do it using `lsblk` and locating the drive you know has Windows installed on it.

I'm calling the location of it `windows-location`.

`sudo mount /dev/windows-location /mnt`

`cd /mnt/Windows/Fonts`

`cp *.ttf ~/ttf-ms-win10`

`cp *.ttc ~/ttf-ms-win10`

`cp /mnt/Windows/System32/Licenses/neutral/_Default/Core/license.rtf ~/ttf-ms-win10`

`cd ~/ttf-ms-win10`

`makepkg`

Assuming it all goes well... type this:

`makepkg --install`

And finally `sudo umount /mnt`

## Installing steam

First you need to enable multilib:

`sudo nano /etc/pacman.conf`

Find the following lines:

```
#[multilib]
#Include = /etc/pacman.d/mirrorlist
```

Uncomment them so they look like this:

```
[multilib]
Include = /etc/pacman.d/mirrorlist
```

`sudo pacman -Syu`

Next there are some things you need to have fulfilled:

* OpenGL 32-bit drivers:
    * AMD, Intel, and nouveau: `sudo pacman -S lib32-mesa`
    * Nvidia proprietary: `sudo pacman -S lib32-nvidia-utils`
* en_US.UTF-8 locale generated
    * If you haven't, it's in the installing_arch.md file.
* Microsoft fonts installed (check the above header)

`sudo pacman -S steam`
