# dotfiles

- install packages
- configure sddm/grub theme
- enable some service
- manage config files
- uses GNU stow
  - by default stow set the target to the parent dir of the stow directory

# Other

## Downgrade package
```
sudo pacman -U ~/.cache/yay/xpadneo-dkms/xpadneo-dkms-0.9.8-1-any.pkg.tar.zst
```

## Pi sandboxing
```
ln --symbolic /home/yehrol/dotfiles/scripts/pi/docker/pi-dock /home/yehrol/.local/bin/pi-dock
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
