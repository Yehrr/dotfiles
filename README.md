# dotfiles

- manage config files
- uses GNU stow
  - by default stow set the target to the parent dir of the stow directory

## Usage

1. clone the repo in the home folder
2. `stow <package name>` to load a package (ex: `stow zsh` inside `dotfiles`)
   - `stow -t <target-dir> <package name>` to select target dir (ex: `stow -t /etc/coolercontrol cooler-control`)

# Install

## SDDM

### keyboard layout

```
localectl set-x11-keymap ch
```

### theme

- copy the dir `dotfiles/esthetic/themes/sddm/abstractdark-sddm-theme` to `/usr/share/sddm/themes`
- edit the file `/etc/sddm.conf` and set to:

```
[Theme]
Current=abstractdark-sddm-theme
```

## Grub

- copy the right dir in `dotfiles/esthetic/themes/grub` to `/boot/grub/themes` and rename it to `yorha`
- edit the file `/etc/default/grub` and set `GRUB_THEME="/boot/grub/themes/yorha/theme.txt"`
- update grub `sudo grub-mkconfig -o /boot/grub/grub.cfg`

## Hyprland specific

- install xorg-xhost and hyprpolkitagent for process that need privilege (ex: timeshift)

## UWSM
- TODO clean
```
sudo systemctl --user enable --now hyprpolkitagent.service
sudo systemctl --user enable --now input-remapper
```

# Other

## Downgrade package
```
sudo pacman -U ~/.cache/yay/xpadneo-dkms/xpadneo-dkms-0.9.8-1-any.pkg.tar.zst
```

## Make

set `MAKEFLAGS="--jobs=$(nproc)"` in /etc/makepkg.conf to use all core

## Kernel config

- to control amd gpu fan : add `amdgpu.ppfeaturemask=0xffffffff` to GRUB_CMDLINE_LINUX_DEFAULT in /etc/default/grub
  - mmh.. looks like it's the cause of gpu hang. flags : https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/amd/include/amd_shared.h#n178
  - apparently 0x4000 should be sufficient. (source : https://wiki.archlinux.org/title/AMDGPU#Boot_parameter)
- to disable split lock detection : add `split_lock_detect=off` to GRUB_CMDLINE_LINUX_DEFAULT in /etc/default/grub

## BTRFS. Booting into read-only snapshots

- https://wiki.archlinux.org/title/Snapper#Booting_into_read-only_snapshots
- add `grub-btrfs-overlayfs` to the end of the `HOOKS` array in `/etc/mkinitcpio.conf`, then `mkinitcpio -P` to regenerate initramfs

## Polkit
- https://wiki.archlinux.org/title/Polkit#Bypass_password_prompt
