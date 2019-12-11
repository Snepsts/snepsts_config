# Laptop specifics

This is a WIP

Install `acpibacklight`:

`pacman -S acpibacklight`

Give yourself `video` access:

`sudo usermod -aG video user_name_here`

Set acpi stuff:

`sudo nano /etc/mkinitcpio.conf`

Locate the `MODULES` section, and add `intel_agp` and `i915` to it:

```
MODULES=(intel_agp i915)
```
