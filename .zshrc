# ===============
# powerlevel10k
# ===============

# Enable powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ==============
# dynamic title
# ==============
if [[ "$TERM" == "xterm-256color" || "$TERM" == "alacritty" ]]; then
  precmd() {
    print -Pn "\e]0;%n@%m: %~\a"
  }

  preexec() {
    print -Pn "\e]0;%n@%m: $1\a"
  }
fi

# ============
# plugins
# ============

# zinit directory
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# download zinit if it does not exists
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# source/load zinit
source "${ZINIT_HOME}/zinit.zsh"

# add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# add in plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# load zsh-completions
autoload -U compinit && compinit

zinit cdreplay -q

# completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# =============
# keybindings
# =============

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# =========
# history
# =========

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

# =============
# path config 
# ============

export PATH="$PATH:/home/chow/.local/bin"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
# opencode
export PATH=/home/chow/.opencode/bin:$PATH

# ===================
# shell integrations
# ===================

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fzf --zsh)"

# cargo
. "$HOME/.cargo/env"

# fnm
FNM_PATH="/home/chow/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --use-on-cd --shell zsh)"
  eval "$(fnm completions --shell zsh)"
fi

# zoxide
eval "$(zoxide init zsh --cmd cd)"

# uv
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

# ===========
# functions
# ===========

fpath+=${ZDOTDIR:-~}/.zsh_functions
source ~/.zsh_functions/vpn

# ==========
# envs
# ==========
export EDITOR=windsurf

# ========== 
# aliases
# ==========

alias vim=nvim
alias ls='ls --color'

