# TODO check https://github.com/cebem1nt/dotfiles/blob/main/install.sh

SRC=$(dirname "$0")
LOG_FILE="install.log"

_info() { printf '\033[32m[INFO]\033[0m %s\n' "$*"; }
_warning() { printf '\033[33m[WARNING]\033[0m %s\n' "$*"; }
_error() { printf '\033[31m[ERROR]\033[0m %s\n' "$*"; }

prompt() {
    read -r -p "$1"$'\033[32m [Y/n] \033[0m' CHOICE
    if [ -z "$CHOICE" ]; then 
        echo 1 
    else
        case "$CHOICE" in 
            n|N|No|no ) echo 0;;
            y|Y|* ) echo 1;;
        esac
    fi
}

check_packges() {
    while IFS= read -r LINE; do
        if [[ -z "$LINE" ]] || [[ ${LINE# } == \#* ]]; then 
            continue
        fi

        PKG="${LINE//[[:space:]]/}"

        if ! pacman -Q "$PKG" >/dev/null 2>&1 ; then
            echo -n "$PKG "
        fi
    done < $1
}

verify_packages() {
    _info "Verifying necessary packages...."

    if which pacman >/dev/null 2>&1; then
		# TODO check if files exist
        MISSING=$(check_packges "$SRC/packages.txt") 
        MISSING_AUR=$(check_packges "$SRC/packages.aur.txt") 

        if [[ -n "$MISSING" ]]; then
            _warning "The following packages are not installed:"
            echo "    $MISSING"
            _warning "If you know what you're doing, skip"

            if [[ $(prompt "Install missing packages?") == 1 ]]; then
                sudo pacman -Syu $MISSING
            fi
		else
			_info "Everything is already installed"
        fi

        if [[ -n "$MISSING_AUR" ]]; then
            _warning "The following AUR packages are not installed:"
            echo "    $MISSING_AUR"
            _warning "If you know what you're doing, skip"

            if [[ $(prompt "Install missing packages?") == 1 ]]; then
                if which yay >/dev/null 2>&1; then
                    yay -S $MISSING_AUR
                elif which paru >/dev/null 2>&1; then
                    paru -S $MISSING_AUR
                else
                    _error "No AUR helper found, could not install."
                    read -r -p "Press ENTER to continue..."
                fi
            fi
        fi
    else
        _warning "You're not using an arch/arch based distro. This script wont work"
        read -r -p "Press ENTER to continue..."
    fi
}

# ============================================================================ #
#                              INSTALL REQUIREMENT                             #
# ============================================================================ #
sudo pacman -Syu --needed base-devel stow

# ============================================================================ #
#                                    INSTALL                                   #
# ============================================================================ #

# TODO if a step is canceled, everything should be (ctrl+c)

## Yay
# TODO check if already done
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

## Oh my posh
# TODO check if already done
curl -s https://ohmyposh.dev/install.sh | bash -s

## Everything else
verify_packages | tee -a $LOG_FILE

# ============================================================================ #
#                                     SETUP                                    #
# ============================================================================ #

## ZSH
# TODO check if already done
chsh -s $(which zsh)

## Oh my posh
# TODO check if already done
oh-my-posh font install JetBrainsMono

# TODO Deploy dotfiles
# ./config/delploy.sh

# TODO copy etc files ?
# cp ./esthetic/themes/sddm/abstractdark-sddm-theme /usr/share/sddm/themes
# locale-gen

# SDDM keyboard
# localectl set-x11-keymap ch

# TODO Grub theme ? must ask for res

# TODO Enable services
# sudo systemctl --user enable --now hyprpolkitagent.service
# sudo systemctl --user enable --now input-remapper
 
# TODO add a message to say what to do afterward. config nextcloud, retrieve ssh key, keepassxc, etc.. 

# things to install and setup
# nextcloud # gui only ?
# rclone # Desktop only
