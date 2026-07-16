# ============================================================
# PATH
# ============================================================

export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$(python3 -m site --user-base)/bin"

# ============================================================
# History
# ============================================================

HISTFILE=~/.zsh_history
HISTSIZE=50000          # メモリ上に保持する件数
SAVEHIST=50000          # ファイルに保存する件数

setopt EXTENDED_HISTORY       # 実行時刻と所要時間も記録
setopt SHARE_HISTORY          # 複数ターミナル間で履歴を即共有
setopt HIST_IGNORE_ALL_DUPS   # 同じコマンドは古いほうを消す
setopt HIST_IGNORE_SPACE      # 行頭スペース付きは履歴に残さない
setopt HIST_REDUCE_BLANKS     # 余分な空白を詰めて記録
setopt HIST_VERIFY            # !! 展開後、実行前に一度見せる
setopt HIST_NO_STORE          # history コマンド自体は残さない

# ============================================================
# Completion
# ============================================================

autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # 大文字小文字を区別しない
zstyle ':completion:*' menu select                      # 候補を矢印キーで選ぶ
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # 候補に色を付ける
zstyle ':completion:*' group-name ''                    # 種類ごとに candidates を分類
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

setopt AUTO_MENU        # Tab 連打で候補を順に巡回
setopt COMPLETE_IN_WORD # カーソルが単語の途中でも補完する
setopt ALWAYS_TO_END    # 補完確定後にカーソルを単語末尾へ

# ============================================================
# Directory navigation
# ============================================================

setopt AUTO_CD           # ディレクトリ名だけで cd
setopt AUTO_PUSHD        # cd のたびに移動元をスタックに積む
setopt PUSHD_IGNORE_DUPS # スタックに同じディレクトリを重複させない
setopt PUSHD_SILENT      # pushd/popd の出力を黙らせる

# ============================================================
# Misc options
# ============================================================

setopt INTERACTIVE_COMMENTS # 対話シェルでも # コメントを許可
setopt NO_BEEP              # ビープを鳴らさない
setopt EXTENDED_GLOB        # ^ や ~ を使った高機能グロブ
setopt NO_FLOW_CONTROL      # Ctrl-S / Ctrl-Q による画面停止を無効化

# ============================================================
# Key bindings
# ============================================================

bindkey -e  # Emacs キーバインド（Ctrl-A 行頭 / Ctrl-E 行末 / Ctrl-R 履歴検索）

# ↑↓ を「打ちかけの文字列で始まる履歴」の検索にする
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# ============================================================
# Prompt
# ============================================================

autoload -Uz vcs_info add-zsh-hook
add-zsh-hook precmd vcs_info
zstyle ':vcs_info:git:*' formats       ' %F{magenta}(%b)%f'
zstyle ':vcs_info:git:*' actionformats ' %F{magenta}(%b|%a)%f'
zstyle ':vcs_info:*' enable git

setopt PROMPT_SUBST
PROMPT='%F{cyan}%~%f${vcs_info_msg_0_}
%(?.%F{green}.%F{red})❯%f '

# ============================================================
# Colors
# ============================================================

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

export LESS_TERMCAP_mb=$'\e[1;31m'    # 点滅開始（赤）
export LESS_TERMCAP_md=$'\e[1;36m'    # 太字開始（シアン）
export LESS_TERMCAP_me=$'\e[0m'       # 太字・点滅の終了
export LESS_TERMCAP_so=$'\e[1;44;33m' # 強調開始（背景青＋文字黄）
export LESS_TERMCAP_se=$'\e[0m'       # 強調終了
export LESS_TERMCAP_us=$'\e[1;32m'    # 下線開始（緑）
export LESS_TERMCAP_ue=$'\e[0m'       # 下線終了

# ============================================================
# Aliases
# ============================================================

alias ll='ls -lh'
alias la='ls -lAh'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias d='dirs -v'

alias cd42='cd ~/Desktop/42/Cursus'
