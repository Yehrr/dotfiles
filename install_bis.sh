#!/usr/bin/env bash
# ============================================================================ #
#                        install_bis.sh - full setup script                    #
# Installs and configures everything present in this repo:                    #
#   - packages (repo + AUR, base + optional desktop)                          #
#   - dotfiles via GNU stow (~ and /etc)                                      #
#   - SDDM / GRUB themes, locale, makepkg, services                           #
# Based on install.sh + README.md.                                            #
# ============================================================================ #

set -uo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
LOG_FILE="$SRC/install_bis.log"
DESKTOP_MODE=0        # 1 if "desktop" mode is requested (gaming/desktop packages)

# ---------------------------------------------------------------------------- #
#                                  HELPERS                                     #
# ---------------------------------------------------------------------------- #
_info()    { printf '\033[32m[INFO]\033[0m %s\n' "$*"; }
_warning() { printf '\033[33m[WARNING]\033[0m %s\n' "$*"; }
_error()   { printf '\033[31m[ERROR]\033[0m %s\n' "$*"; }
_step()    { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }

prompt() {
    local CHOICE=""
    read -r -p "$1"$'\033[32m [Y/n] \033[0m' CHOICE
    if [ -z "$CHOICE" ]; then
        echo 1
    else
        case "$CHOICE" in
            n|N|No|no) echo 0 ;;
            *)         echo 1 ;;
        esac
    fi
}

prompt_choice() {
    local CHOICE=""
    read -r -p "$1"$'\033[32m \033[0m' CHOICE
    echo "$CHOICE"
}

# list the packages from $1 that are not installed
check_packages() {
    local PKG
    while IFS= read -r LINE; do
        [[ -z "${LINE// }" || "${LINE# }" == \#* ]] && continue
        PKG="${LINE//[[:space:]]/}"
        pacman -Q "$PKG" >/dev/null 2>&1 || echo -n "$PKG "
    done < "$1"
}

log() { tee -a "$LOG_FILE" | cat; }

# ---------------------------------------------------------------------------- #
#                                 PREREQUISITES                                #
# ---------------------------------------------------------------------------- #
preflight() {
    _step "Pre-flight checks"

    if ! command -v pacman >/dev/null 2>&1; then
        _error "pacman not found: this script is meant for Arch/Arch-based distros. Aborting."
        exit 1
    fi

    # the repo must live in the home folder so that stow targets ~ properly
    if [[ "$HOME" != *"/$(basename "$SRC")" && "$(basename "$SRC")" != "dotfiles" ]]; then
        _warning "The repo should be cloned into $HOME/dotfiles so stow targets ~"
        [[ $(prompt "Continue anyway?") == 0 ]] && exit 1
    fi
}

# ---------------------------------------------------------------------------- #
#                              SUDO / SYSTEM BASE                               #
# ---------------------------------------------------------------------------- #
install_base() {
    _step "Base packages + system update"

    # sudo is part of the 'base' group, so it is normally already installed.
    # If it is missing, it cannot be installed from a non-root shell (chicken
    # and egg), so just tell the user how to fix it.
    if ! command -v sudo >/dev/null 2>&1; then
        _error "sudo is not installed and cannot be installed automatically (requires root)."
        echo '        From a root shell (su -), run:  pacman -Sy sudo'
        echo '        Then re-run this script.'
        exit 1
    fi

    # make sure the current user can actually use sudo before going further.
    # NB: use 'sudo -v' (validate/refresh credentials) rather than 'sudo true'
    # so the user is prompted for their password exactly once here, and every
    # subsequent sudo call in the script runs without re-prompting (the 5 min
    # timestamp keeps refreshing as the script progresses).
    if ! sudo -v; then
        _error "The current user cannot run sudo (not in the 'wheel' group?). Aborting."
        exit 1
    fi

    _step "System update + base packages (base-devel, stow, git, unzip)"
    sudo pacman -Syu --needed base-devel stow git unzip
}

# ---------------------------------------------------------------------------- #
#                                    YAY                                       #
# ---------------------------------------------------------------------------- #
install_yay() {
    if pacman -Q yay >/dev/null 2>&1 || command -v yay >/dev/null 2>&1; then
        _info "yay already installed"
        return
    fi
    _step "Installing yay"
    local tmp
    tmp=$(mktemp -d)
    if ! git clone --depth 1 https://aur.archlinux.org/yay.git "$tmp/yay"; then
        _error "Failed to clone yay from AUR (check your internet connection)."
        rm -rf "$tmp"
        exit 1
    fi

    if [[ ! -f "$tmp/yay/PKGBUILD" ]]; then
        _error "Clone succeeded but PKGBUILD is missing, aborting."
        rm -rf "$tmp"
        exit 1
    fi

    if ! (cd "$tmp/yay" && makepkg -s --noconfirm -si --skippgpcheck); then
        _error "Failed to build yay, see output above."
        rm -rf "$tmp"
        exit 1
    fi
    rm -rf "$tmp"

    # final check: the binary must actually be available
    if ! command -v yay >/dev/null 2>&1; then
        _error "yay build finished but the 'yay' command is not available, aborting."
        exit 1
    fi
    _info "yay installed successfully"
}

# ---------------------------------------------------------------------------- #
#                                    OHP                                       #
# ---------------------------------------------------------------------------- #
install_oh_my_posh() {
    if command -v oh-my-posh >/dev/null 2>&1; then
        _info "oh-my-posh already installed"
    else
        _step "Installing oh-my-posh"
        curl -s https://ohmyposh.dev/install.sh | bash -s
    fi
}

# ---------------------------------------------------------------------------- #
#                                   PACKAGES                                   #
# ---------------------------------------------------------------------------- #
install_packages() {
    _step "Verifying required packages"

    local MISSING MISSING_AUR
    MISSING=$(check_packages "$SRC/packages.txt")
    MISSING_AUR=$(check_packages "$SRC/packages.aur.txt")

    if [[ -n "$MISSING" ]]; then
        _warning "Missing official packages: $MISSING"
        if [[ $(prompt "Install these packages?") == 1 ]]; then
            sudo pacman -S --noconfirm $MISSING
        else
            _warning "Skipped (if you know what you're doing)"
        fi
    else
        _info "All official packages are already installed"
    fi

    if [[ "$DESKTOP_MODE" == 1 ]]; then
        local MISSING_DESK MISSING_AUR_DESK
        MISSING_DESK=$(check_packages "$SRC/packages.desktop.txt")
        MISSING_AUR_DESK=$(check_packages "$SRC/packages.aur.desktop.txt")

        if [[ -n "$MISSING_DESK" ]]; then
            _warning "Missing desktop packages: $MISSING_DESK"
            [[ $(prompt "Install these packages?") == 1 ]] && sudo pacman -S --noconfirm $MISSING_DESK
        fi
        if [[ -n "$MISSING_AUR_DESK" ]]; then
            _warning "Missing desktop AUR packages: $MISSING_AUR_DESK"
            [[ $(prompt "Install these packages?") == 1 ]] && yay -S --noconfirm $MISSING_AUR_DESK
        fi
    fi

    if [[ -n "$MISSING_AUR" ]]; then
        # yay may have been skipped earlier, so there might be no AUR helper yet
        if ! command -v yay >/dev/null 2>&1 && ! command -v paru >/dev/null 2>&1; then
            _warning "No AUR helper available (yay/paru), installing yay now"
            install_yay
        fi

        _warning "Missing AUR packages: $MISSING_AUR"
        if [[ $(prompt "Install these AUR packages?") == 1 ]]; then
            if command -v yay >/dev/null 2>&1; then
                yay -S --noconfirm $MISSING_AUR
            elif command -v paru >/dev/null 2>&1; then
                paru -s --noconfirm $MISSING_AUR
            else
                _error "No AUR helper found (yay/paru). Install them manually."
            fi
        fi
    fi
}

# ---------------------------------------------------------------------------- #
#                                  DOTFILES (STOW)                             #
# ---------------------------------------------------------------------------- #
# stow a "package"; on conflict, keep the old version and
# force the symlink (like stow --adopt, but explicit)
stow_pkg() {
    local pkg="$1" target="${2:-$HOME}"
    # stow must be run from the directory containing the packages (config/)
    if (cd "$SRC/config" && stow --target "$target" "$pkg") >> "$LOG_FILE" 2>&1; then
        _info "stow: $pkg -> $target"
    else
        _warning "stow: conflict or failure on '$pkg' (old config backed up in ~/.dotfiles-backup/)"
        if (cd "$SRC/config" && stow --target "$target" --adopt "$pkg") >> "$LOG_FILE" 2>&1; then
            _info "stow: '$pkg' adopted (old config was moved aside)"
        else
            _error "stow: failed to install '$pkg', see $LOG_FILE"
        fi
    fi
}

stow_user_packages() {
    _step "Deploying dotfiles (stow -> $HOME)"

    # deploy every package found in config/, regardless of whether the
    # corresponding program is installed (configs stay dormant until used)
    local pkg
    for pkg in "$SRC"/config/*/; do
        pkg=$(basename "$pkg")
        stow_pkg "$pkg"
    done
}

stow_etc_packages() {
    _step "Deploying /etc files (stow -> /etc)"

    local etc_pkgs=(
        locale.conf
        locale.gen
        sddm.conf
    )

    local f
    for f in "${etc_pkgs[@]}"; do
        [[ -f "$SRC/etc/$f" ]] || continue
        _info "stow: etc/$f -> /etc"
        # stow must be run from the directory containing the files (etc/)
        sudo bash -c "cd '$SRC/etc' && stow --target /etc -- '$f'" >> "$LOG_FILE" 2>&1 \
            || sudo bash -c "cd '$SRC/etc' && stow --target /etc --adopt -- '$f'" >> "$LOG_FILE" 2>&1 \
            || _error "stow /etc/$f failed (see $LOG_FILE)"
    done
}

# ---------------------------------------------------------------------------- #
#                                    LOCALE                                    #
# ---------------------------------------------------------------------------- #
setup_locale() {
    _step "Generating locales"
    sudo locale-gen >> "$LOG_FILE" 2>&1 || _warning "locale-gen failed"
}

# ---------------------------------------------------------------------------- #
#                                       SDDM                                   #
# ---------------------------------------------------------------------------- #
setup_sddm() {
    _step "Configuring SDDM"

    # theme
    sudo mkdir -p /usr/share/sddm/themes
    sudo cp -r "$SRC/esthetic/themes/sddm/abstractdark-sddm-theme" /usr/share/sddm/themes/ \
        && _info "SDDM theme installed" || _error "Failed to install SDDM theme"

    # sddm.conf already stowed into /etc; check the theme value
    if grep -q "Current=abstractdark-sddm-theme" /etc/sddm.conf 2>/dev/null; then
        _info "sddm.conf OK"
    else
        _warning "/etc/sddm.conf does not point to the theme, check it manually"
    fi

    # keyboard
    if [[ $(prompt "Set X11 keyboard layout to 'ch' (localectl set-x11-keymap ch)?") == 1 ]]; then
        sudo localectl set-x11-keymap ch && _info "X11 keyboard: ch"
    fi
}

# ---------------------------------------------------------------------------- #
#                                       GRUB                                   #
# ---------------------------------------------------------------------------- #
setup_grub() {
    _step "Configuring GRUB (yorha theme)"

    if [[ ! -f /etc/default/grub ]] || [[ ! -d /boot/grub ]]; then
        _warning "GRUB not found, skipping"
        return
    fi

    local res
    res=$(prompt_choice "Which resolution for the GRUB theme? (1=1920x1080, 2=2560x1440, 3=3840x2160, other=skip)")
    case "$res" in
        1) local theme="$SRC/esthetic/themes/grub/yorha-1920x1080" ;;
        2) local theme="$SRC/esthetic/themes/grub/yorha-2560x1440" ;;
        3) local theme="$SRC/esthetic/themes/grub/yorha-3840x2160" ;;
        *) _warning "GRUB theme skipped"; return ;;
    esac

    sudo rm -rf /boot/grub/themes/yorha
    sudo cp -r "$theme" /boot/grub/themes/yorha \
        && _info "GRUB theme copied to /boot/grub/themes/yorha"

    if grep -q '^GRUB_THEME=' /etc/default/grub; then
        sudo sed -i 's|^GRUB_THEME=.*|GRUB_THEME="/boot/grub/themes/yorha/theme.txt"|' /etc/default/grub
    else
        echo 'GRUB_THEME="/boot/grub/themes/yorha/theme.txt"' | sudo tee -a /etc/default/grub
    fi
    _info "GRUB_THEME set"

    if [[ $(prompt "Regenerate GRUB config (grub-mkconfig -o /boot/grub/grub.cfg)?") == 1 ]]; then
        sudo grub-mkconfig -o /boot/grub/grub.cfg >> "$LOG_FILE" 2>&1 \
            && _info "grub.cfg regenerated" || _error "grub-mkconfig failed"
    fi
}

# ---------------------------------------------------------------------------- #
#                               MAKE / MAKEPKG                                  #
# ---------------------------------------------------------------------------- #
setup_makepkg() {
    _step "MAKEFLAGS in /etc/makepkg.conf"
    if grep -q '^MAKEFLAGS=' /etc/makepkg.conf; then
        sudo sed -i 's|^MAKEFLAGS=.*|MAKEFLAGS="--jobs=$(nproc)"|' /etc/makepkg.conf
    else
        echo 'MAKEFLAGS="--jobs=$(nproc)"' | sudo tee -a /etc/makepkg.conf
    fi
    _info "MAKEFLAGS=\"--jobs=$(nproc)\" configured"
}

# ---------------------------------------------------------------------------- #
#                                   SERVICES                                    #
# ---------------------------------------------------------------------------- #
setup_services() {
    _step "Enabling services"

    command -v hyprpolkitagent >/dev/null 2>&1 \
        && systemctl --user enable --now hyprpolkitagent.service \
        && _info "hyprpolkitagent enabled"

    if pacman -Q input-remapper-git >/dev/null 2>&1; then
        systemctl --user enable --now input-remapper.service && _info "input-remapper enabled"
    fi
}

# ---------------------------------------------------------------------------- #
#                                   SHELL / FONTS                               #
# ---------------------------------------------------------------------------- #
setup_shell() {
    _step "Shell + fonts"

    # only change the user's shell if it is not already zsh
    if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v zsh)" ]; then
        if [[ $(prompt "Change $USER's shell to zsh?") == 1 ]]; then
            chsh -s "$(command -v zsh)" && _info "Shell -> zsh"
        fi
    else
        _info "Shell already zsh"
    fi

    # oh-my-posh font (check if already installed first)
    if fc-list | grep -qi "JetBrains Mono"; then
        _info "JetBrainsMono font already installed"
    else
        oh-my-posh font install JetBrainsMono >> "$LOG_FILE" 2>&1 \
            && _info "JetBrainsMono font installed" \
            || _warning "Failed to install JetBrainsMono font (install it manually if needed)"
    fi
}

# ---------------------------------------------------------------------------- #
#                                 SUMMARY / END                                 #
# ---------------------------------------------------------------------------- #
final_notes() {
    _step "Done! Remaining manual steps:"
    cat <<EOF

    - configure nextcloud / keepassxc (retrieve your data)
    - retrieve your SSH keys
    - BTRFS/snapper: add 'grub-btrfs-overlayfs' at the end of the HOOKS array
      in /etc/mkinitcpio.conf, then run 'sudo mkinitcpio -P'
    - boot options (if needed, in GRUB_CMDLINE_LINUX_DEFAULT in /etc/default/grub):
      amdgpu.ppfeaturemask=0x4000  (GPU fan control, see README)
      split_lock_detect=off       (disable split lock detection)
    - polkit: see README (bypass password prompt)

    Full log: $LOG_FILE
EOF
}

# ---------------------------------------------------------------------------- #
#                                     MAIN                                     #
# ---------------------------------------------------------------------------- #
main() {
    : > "$LOG_FILE"
    _info "Log: $LOG_FILE"

    # must be known upfront: yay cannot be built as root (makepkg refuses)
    if [[ $EUID -eq 0 ]]; then
        _error "This script must NOT be run as root: yay cannot be installed (makepkg refuses to run as root)."
        _info "Create a user first if needed, set a password, switch to it, then re-run the script:"
        echo '    useradd -m -g users -G wheel <username>'
        echo '    passwd <username>'
        echo '    su - <username>'
        _info "Then set the EDITOR variable:"
        echo '      export EDITOR=nano   # e.g. in ~/.zshrc, or EDITOR="nano" in /etc/makepkg.conf'
        _info "Finally, grant sudo access to the new user (activate the %wheel line):"
        echo '      sudo visudo          # uncomment: %wheel  ALL=(ALL:ALL) ALL'
        exit 1
    fi

    if [[ $(prompt "Desktop mode (gaming/desktop packages)?") == 1 ]]; then
        DESKTOP_MODE=1
    fi

    preflight
    install_base
    install_yay
    install_oh_my_posh
    install_packages
    stow_user_packages
    stow_etc_packages
    setup_locale
    setup_sddm
    setup_grub
    setup_makepkg
    setup_shell
    setup_services
    final_notes
}

main "$@"
