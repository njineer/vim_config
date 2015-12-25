
alias tmux='tmux -2'                      # automatically support 256 colors
alias n='NVIM_TUI_ENABLE_TRUE_COLOR=1 /home/nathan/neovim/build/bin/nvim'
alias vim='NVIM_TUI_ENABLE_TRUE_COLOR=1 /home/nathan/neovim/build/bin/nvim'
alias cloud='ssh 107.191.103.252'
#alias serv='mosh -p 8768 --ssh="ssh -p 8767" nathan@room409.xyz'
alias serv='ssh -p 8767 nathan@room409.xyz'
alias desk='ssh -p 8766 nathan@room409.xyz'

if ! pgrep -u $USER ssh-agent > /dev/null; then
    ssh-agent | sed "s/^echo.*$//" > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval $(<~/.ssh-agent-thing)
fi
ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'


alias o='xdg-open'
alias l='i3lock; systemctl suspend'
alias minecraft='java -jar ~/minecraft/Minecraft.jar'
alias lg='java -jar ~/school/fall2015/ta/Logisim.jar'
setxkbmap -layout us -option ctrl:nocaps

export PATH=$PATH:~/bin:/home/nathan/.gem/ruby/2.2.0/bin:~/.gem/ruby/2.1.0/bin:~/Nim/bin:/opt/android-sdk/tools:/opt/android-sdk/platform-tools
export ANDROID_HOME=/opt/android-sdk
export GOPATH=~/go_path
export PATH=$PATH:$GOPATH/bin

# prompt
#autoload promptinit
#promptinit
#prompt fade green

# thanks Andrew's file
autoload -U colors && colors
export PS1="%B%{$fg[red]%}[%{$fg[green]%}%n%{$fg[cyan]%}@%M %{$fg[white]%}%c%{$fg[red]%}]%#%{$reset_color%} %b"

#PS1='[\u@\h \W]\$ '
BROWSER=/usr/bin/xdg-open

# ex - archive extractor
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;

      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' matcher-list 'r:|[._-]=** r:|=**' 'r:|[._-]=** r:|=**' 'r:|[._-]=** r:|=**' 'r:|[._-]=** r:|=**'
zstyle ':completion:*' max-errors 2
zstyle :compinstall filename '/home/nathan/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
