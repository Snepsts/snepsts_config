# Installing Arch Linux

All of this is based on the ArchWiki, it's a great resource.

I'm just trying to get a smooth guide to quickly follow to install Arch on all of my computers.

## After booting to cli

Make sure it's running efi:

`ls /sys/firmware/efi/efivars`

### Setting up wifi

To view your controllers:

`lspci -vnn | grep -i net`

To find your interface name:

`ip link`

Find the wifi interface name, I'm calling it `wlan0`.

Activate it:

`ip link set wlan0 up`

To find your ssid:

`iw dev wlan0 scan | less`

I'm giving it the name `ssid`.

#### WPA/WPA2 password protection

`wpa_passphrase ssid >> /etc/wpa_supplicant.conf`

Upon hitting enter you will have to input the wifi password.

After that is done, run the following:

`wpa_supplicant -B -D nl80211 -i wlan0 -c /etc/wpa_supplicant.conf`

You are now set up for your WPA2 protected wifi network!

Connect to `ssid`:

`iw dev wlan0 connect ssid`

You may have to enable dhcp:

`dhclient wlan0`

To ensure it connected correctly:

`iw wlan0 link`

To test the connection:

`ping archlinux.org`

### Set the time

Run the command:

`timedatectl set-ntp true`

### Install a basic tool

It _might_ come in handy later:

`pacman -S dosfstools`

## Partitioning disks

Use this to identify your disks:

`fdisk -l`

### Create partitions

If your disk has no partitions on it yet, you will need to create some partitions.

If your drive isn't sda, replace it with something else.

`fdisk /dev/sda`

If there is no table, or you want to completely wipe the drive, use g to create a new GPT.

`g`

To make new partitions use:

`n`

Since I make very few partitions they will all be primary types, so when asked for the type enter `p`.

To ask for partition type ids, use `l`.

Each partition should start on the closest sector to the last, the first starting at 0.

You can use `+[number][M|G|T]` to add from there.

For example: `+2G` will make the partition 2 gigabytes in size.

Make each partition:

* EFI patition, roughly 512 MB - 1 GB. It will be `EFI System`. This should be the first partition & bootable.

* Root partition, roughly 20-30 GB, give yourself plenty of space to scale. It will be `Linux filesystem`.

* Home partition. Make this as large as you want. It will be `Linux filesystem`.

* Optionally, a swap partition. I always make it the size of my RAM or 8 GB, whichever is smaller. It will be `Linux swap`.

Afterwards, you will format each partition accordingly:

* EFI is `mkfs.fat -F32 /dev/drive#`
	* Note: if you see this `WARNING: Not enough clusters for a 32 bit FAT!` try `mkfs.fat -s2 -F32 ...`

* Root and Home are `mkfs.ext4 /dev/drive#`

* Swap has two commands:
	* `mkswap /dev/drive#`
	* `swapon /dev/drive#`

### Mounting partitions

If `/mnt` does not exist, create it:

`mkdir /mnt`

Mounting works like so:

`mount /dev/drive# /mnt`

You have to do a few steps here:

1. Mount root to `/mnt`.
2. `mkdir /mnt/boot`.
3. Mount EFI to `/mnt/boot`.
4. `mkdir /mnt/home`
5. Mount home to `/mnt/home`

Okay, your system is now mounted!

### Pacstrap in

Make sure the mirrorlist has a couple United States mirrors at the top. It's located in `/etc/pacman.d/mirrorlist`.

If you don't, the downloads might take a _bit_ longer.

Now run the following to prepare your arch linux filesystem:

`pacstrap /mnt base linux linux-firmware`

### One last thing

Generate your fs table:

`genfstab -U /mnt >> /mnt/etc/fstab`

Now jump in:

`arch-chroot /mnt`

## Configuration

You'll need to install a text editor. Might I suggest `nano`?

`pacman -S nano`

### Time

Set your time zone, the pattern is: `/usr/share/zoneinfo/Region/City /etc/localtime`.

I'm going to run this:

`ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime`

Then, adjust your time:

`hwclock --systohc`

### Language

We need to generate the locale. Uncomment the locales you need from `/etc/locale.gen`. All I need is `en_US_UTF-8 UTF-8`.

Then run this:

`locale-gen`

Afterwards, type your locale of choice in `/etc/locale.conf` like so:

```
LANG=en_US.UTF-8
```

### Networking

Edit your `/etc/hostname` file to give your computer a name, I'm gonna name mine `snepsts-laptop`.

```
snepsts-laptop
```

Edit `/etc/hosts` and type the following:

```
127.0.0.1       localhost
::1             localhost
127.0.1.1       myhostname.localdomain myhostname
```

### Root password

To set your password:

`passwd`

### Bootloading

Install the following:

* `grub`

* `efibootmgr`

* `intel-ucode` or `amd-ucode` depending on your processor.

* If you're dual-booting, you'll want `os-prober`

So, if you have an AMD cpu and Windows instaled, you should run the following:

`pacman -S grub efibootmgr amd-ucode os-prober`

Now run these in the order as they appear:

`grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB`

`grub-mkconfig -o /boot/grub/grub.cfg`

Everything should be done now.

### Last things

We'll probably need `acpid` later, install it:

`pacman -S acpid`

If you have wifi, run the following:

`pacman -S networkmanager`

### Leave your chroot

Goodbye chroot:

`exit`

Unmount all your partitions:

`umount -R /mnt`

Reboot:

`reboot`

## Settling into Arch Linux

### Wifi

You remember how this goes:

`ip link`

Find the wifi interface name, I'm calling it `wlan0`.

Activate it once again:

`ip link set wlan0 up`

#### NetworkManager

We're gonna activate `NetworkManager`!

`systemctl enable NetworkManager.service`

`systemctl start NetworkManager.service`

Now network manager has been enabled!

To get the commands for it:

`nmcli --help`

To find our new wifi interface name (which could also just be the same):

`nmcli d`

Mine is listed as `wlp58s0` instead of `wlan0`. So that's what I'll refer to it as.

If your wifi interface name is listed as `wifi` you can omit the interface name.

Now find your endpoint:

`nmcli d wifi list`

I'm going to refer to it as `ssid`.

You can use `nmcli d wifi connect ssid` to connect to endpoints.

If you have a password (let's call it `hunter2`) for your wifi endpoint, you have to provide it like so:

`nmcli d wifi connect ssid password hunter2`

* If you're having issues, try deleting your connection and trying again: `nmcli c delete ssid`

Test that your connection works:

`ping archlinux.org`

### Permissions n shell stuffs

Add `zsh`, `sudo` and `vi`:

`pacman -S zsh sudo vi`

Now we're going to edit the `sudoers` file:

`visudo`

Locate the following entry:

```
## Uncoment to allow members of group wheel to execute any command
# %wheel ALL=(ALL) ALL
```

Hit `i` to go into insert mode and uncomment it so it looks like this:

```
## Uncoment to allow members of group wheel to execute any command
%wheel ALL=(ALL) ALL
```

Cool. Now head to the bottom of the file and type the following:

```
## Disable password timeout
Defaults passwd_timeout=0
## Environment variables
Defaults env_keep += "ftp_proxy http_proxy https_proxy no_proxy"
```

`esc` to exit insert mode and type `:x` to exit.

Now, you're still logged in as root, so it's time to set up a generic user account for yourself. I'm naming my user `snepsts`:

`useradd -m -G wheel -s /bin/zsh snepsts`

Give them a password:

`passwd snepsts`

Logout:

`logout`

Now login as your user.

### AUR and zsh enhancements

Install `yay` to get a pacman wrapper for AUR packages.

But first we need `git`, `fakeroot`, `go` and `base-devel`:

`sudo pacman -S git fakeroot base-devel go`

```
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

You should be able to use `yay` now. Let's use it to install oh-my-zsh:

`yay -S oh-my-zsh-git`

## GUI

Install video drivers:

* Intel: `sudo pacman -S xf86-video-intel mesa`

* AMD: `sudo pacman -S xf86-video-amdgpu mesa`

* Nvidia: `sudo pacman -S nvidia-390xx nvidia-390xx-utils`

Install `xorg-server` and `xorg-xinit`:

`sudo pacman -S xorg-server xorg-xinit`

Now install `polybar`:

`yay -S polybar`

Now install some packages we need for i3:

`sudo pacman -S i3-gaps feh dmenu xterm xorg-xbacklight picom`

Now, starting from your home folder (`/home/<username>/` or `/~`) copy all things from `directory_files` there.

`reboot`, login and run `startx`

### Settling in to GUI

Install a web browser:

`sudo pacman -S firefox`

Install some font stuff:

`yay -S ttf-material-design-icons-git`

Install some sound stuff:

`sudo pacman -S pulseaudio pulseaudio-alsa`

and then `reboot` for the sound to start up.

Lockscreen stuff:

`sudo pacman -S i3lock-color xss-lock`

VPN stuff:

Download pia-linux.run from PIA's site

`chmod +x pia-linux.run`

`./pia-linux.run`

Rofi:

`sudo pacman -S rofi`

`yay -S rofi-dmenu`
