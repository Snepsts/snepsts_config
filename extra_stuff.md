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

`sudo nano /etc/mkinitcpio.conf`

```
MODULES=(... amdgpu, ...)
```
