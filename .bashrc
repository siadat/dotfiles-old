# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# -------------
# Added by Sina
# -------------

function tmux-start-or-attach() {
  tmux -2 attach -d || tmux -2 new -s default
}

if command -v tmux>/dev/null; then
  [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && tmux-start-or-attach
fi

# Prefix disabled stuff with #_disabled_#
export LC_ALL="en_US.utf-8"
export PS1='\[\e[1;33m\]\w${text}$\[\e[m\] '
export FZF_DEFAULT_COMMAND='ag -lf .'
alias v='vim -O'
alias gd='git diff --stat -p -U0'
alias gdc='git diff --stat -p -U0 --cached'
alias gsh='git show --stat -p -U0'
alias gs='git status'
alias ls='ls -1 --group-directories-first -p --color=auto'
alias date-slug='date +%F-%T'
alias wgetoffline='wget -c -H -e robots=off -p -k -E'
alias tmux-detach-all-clients='tmux detach-client -Pa'
alias tmux-kill-all-panes='tmux kill-pane -a -t.'
alias cd..='cd ..'
alias open='xdg-open'

function vag() {
  vim -O $(ag -l $@)
}

function anywait() {
  # Usage: anywait PID1 PID2
	for pid in "$@"; do
		while kill -0 "$pid"; do
			sleep 0.1
		done
	done
}

function multi-ed() {
  echo "Enter commands to execute on:"
  for file in $@; do
    echo "  $file"
  done

  tmp=$(mktemp)
  vim $tmp

  for file in $@; do
    cat $tmp | ed $file
  done

  rm $tmp
}

function restart-by-pid() {
  # Usage: restart-by-pid "~/.CMD.pid" "CMD"
  local pidfile=$1
  local cmd=$2
  if [ -f "$pidfile" ]; then
		if [ ! -f "/proc/$(cat $pidfile)/cmdline" ]; then
      rm $pidfile
      echo "$pidfile was stalled. Please stop process manually."
      return
		else
			# NOTE: /proc/PID/cmdline seems to remove spaces from actual command.
			if [ "$(cat /proc/$(cat $pidfile)/cmdline | tr "\0" " ")" = "${cmd// /}" ]; then
				kill $(cat $pidfile)
				anywait $(cat $pidfile) 2> /dev/null
			fi
		fi
  fi

  function run() {
    bash -c "$cmd"
		rm $pidfile
  }
  unset -f run

  nohup run >& /dev/null &
  echo -n $! > $pidfile
  # echo "${cmd}: $(cat $pidfile) $(cat /proc/$(cat $pidfile)/cmdline)"
}

function start-go-docs-and-blog() {
  nohup godoc -http=:6060 &
  cd ~/cloned/goblog
  git pull origin master
  go build ./blog
  nohup  ./blog/blog -http=:6061 &
  # restart-by-pid ~/.godoc.pid "godoc -http=:6060"
  # restart-by-pid ~/.goblog.pid "cd ~/cloned/goblog && ./blog/blog -http=:6061"
}

export CDPATH=$CDPATH:$GOPATH/src:~/src

# go
export GOROOT=/home/sina/go1.7.3
export GOPATH=$HOME/go
export PATH=$PATH:/home/sina/go1.7.3/bin:$GOPATH/bin

# go:gvm
#_disabled_# [[ -s "/home/sina/.gvm/scripts/gvm" ]] && source "/home/sina/.gvm/scripts/gvm"
#_disabled_# export GOPATH=~/go
#_disabled_# export PATH=$PATH:~/go/bin

# git-prompt
#_disabled_# [[ $- == *i* ]] && . ~/git-prompt/git-prompt.sh

# bash completion
#_disabled_# . /etc/bash_completion.d/ssh

# fzf
#_disabled_# [ -f ~/.fzf.bash ] && source ~/.fzf.bash

# nvm (node version manager)
export NVM_DIR="/home/sina/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

function ip() {
  if [ -z "$1" ]; then
    hostname -I
    return
  fi
  sed -n "/$1/,/^HostName/Ip" ~/.ssh/config | grep -i hostname | perl -pe 's/^hostname\s+//i'
}

# jupyter (added by Anaconda3 4.1.1 installer)
#_disabled_# export PATH="/home/sina/workshop/anaconda3/bin:$PATH"

# pyenv
#_disabled_# export PYENV_ROOT="$HOME/.pyenv"
#_disabled_# export PATH="$PYENV_ROOT/bin:$PATH"
#_disabled_# eval "$(pyenv init -)"

# jenv (java)
#_disabled_# export PATH="$HOME/.jenv/bin:$PATH"
#_disabled_# eval "$(jenv init -)"

# dockerfuncs:
# source ~/.dockerfunc
