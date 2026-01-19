# ============================================================================ #
#                                    ALIASES                                   #
# ============================================================================ #
[ -f ~/.aliases ] && source ~/.aliases

# ============================================================================ #
#                                    HISTORY                                   #
# ============================================================================ #
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# ============================================================================ #
#                              FIXING ZSH KEYCODE                              #
# ============================================================================ #
source ~/.zshkeybindings

# ============================================================================ #
#                                     ZINIT                                    #
# ============================================================================ #
# ZINIT Setup
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# ZINIT Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# ============================================================================ #
#                                  OH MY POSH                                  #
# ============================================================================ #
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/omp.toml)"

# ============================================================================ #
#                              COMPLETION STYLING                              #
# ============================================================================ #
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # ignore case
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # color completion
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath' # FIXME: find a way to see hidden files

# ============================================================================ #
#                               SHELL INTEGRATION                              #
# ============================================================================ #
# TODO: check if and how it is installed
eval "$(fzf --zsh)"
#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # git installed