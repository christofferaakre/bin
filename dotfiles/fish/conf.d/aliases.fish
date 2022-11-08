alias aliases="vim ~/bin/dotfiles/fish/conf.d/aliases.fish"

alias open="xdg-open"

alias notes="pushd ~/notes && vim && popd"

# cd
alias bin="cd ~/bin"
alias coding="cd ~/coding"

# editor
alias vim="nvim"
#alias vi="nvim"
alias hx="helix"
alias code="code-insiders"

# git
alias gs="git status"
alias ga="git add ."
alias gc="git commit"
alias gp="git push"
alias gb="git branch"
alias gl="git log"
alias glo="git log --oneline"
alias gd="git diff"

# awesome
alias arc="vim ~/.config/awesome/rc.lua"

# coreutil replacements
alias ls="exa"

# godot
alias gdvim="nvim --listen godot"

# gwa
alias scripts="cd ~/Documents/scripts"

# os
alias qemu="qemu-system-x86_64"
alias igcc="$HOME/opt/cross/bin/i686-elf-gcc"
alias ild="$HOME/opt/cross/bin/i686-elf-ld"
alias iobjdump="$HOME/opt/cross/bin/i686-elf-objdump"
alias igdb="$HOME/opt/cross/bin/i686-elf-gdb"
