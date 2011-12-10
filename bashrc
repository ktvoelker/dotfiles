#!/bin/bash

if [ -f /usr/local/etc/bash_completion ]; then
  # Probably using Homebrew
  . /usr/local/etc/bash_completion
elif [ -f /opt/local/etc/bash_completion ]; then
  # Probably using Macports
  . /opt/local/etc/bash_completion
elif [ -f /etc/bash_completion ]; then
  # Probably a normal system
  . /etc/bash_completion
elif [ -f /etc/bash/bashrc ]; then
  # Gentoo (rancor)
  . /etc/bash/bashrc
fi

# The __git_ps1 function is really good. Only use homegrown if it is missing
if __git_ps1 2>/dev/null
then
  # Turn on all of the __git_ps1 features
  export GIT_PS1_SHOWDIRTYSTATE=1
  export GIT_PS1_SHOWSTASHSTATE=1
  export GIT_PS1_SHOWUNTRACKEDFILES=1
  export GIT_PS1_SHOWUPSTREAM="auto verbose"
  function gitb_time {
    echo "$(__git_ps1)"
  }
else
  # __git_ps1 is for some reason not present so use my crappy version
  function git_branch {
    ref=$(git symbolic-ref HEAD) || return
    git diff-files --quiet && dirty="@" || dirty="*"
    echo "$dirty["${ref#refs/heads/}"]"
  } 2>/dev/null

  function gitb_time {
    echo "$(git_branch 2>/dev/null)"
  }
fi

function git_path {
  local gp=$PWD
  until [ -d "$gp/.git" -o "$gp" = "$HOME" ]
  do
    if [ "$gp" = / ]
    then
      echo $PWD
      return
    fi
    gp=$(dirname "$gp")
  done
  local path=${PWD:${#gp}}
  if [ -d "$gp/.git" ]
  then
    local base=$(basename $gp)
    echo "//$base$path"
  else
    echo "~$path"
  fi
}

# Yep, this is a two line prompt (though it may not be obvious). Format follows:
# Path                                                  ($?) (git info) Time
# Prompt-char
export PS1='$(printf "%${COLUMNS}s" "$(gitb_time 2>/dev/null)")\r\u@\h:$(git_path) \n\$ '

export SCALA_HOME=/opt/scala

PATH="$SCALA_HOME/bin:$PATH"
PATH="/opt/rakudo/bin:$PATH"
PATH="/usr/local/bin:$PATH"
PATH="/usr/local/sbin:$PATH"
PATH="/usr/local/texlive/2011/bin/x86_64-darwin:$PATH"
PATH="$HOME/.cabal/bin:$PATH"
PATH="$HOME/usr/bin:$PATH"

export PATH

UNAME=`uname`
if [ "$UNAME" = Darwin ]
then
  export CLICOLOR=1
  alias cp="gcp"
  alias mv="gmv"
  alias tar="gtar"
  alias chown="gchown"
  alias chmod="gchmod"
elif [ "$UNAME" = Linux ]
then
  alias ls='ls --color=auto'
fi

alias maven='mvn'
alias u='ls'
alias uu='ls -l'
alias uua='ls -la'
alias grep="grep -E --color=auto"
alias crep="grep -n -A5 -B5"

if [ $BASH_VERSINFO -eq 4 ]
then
  shopt -s autocd
  shopt -s checkjobs
  shopt -s dirspell
  shopt -s globstar
fi

shopt -s checkwinsize
shopt -s cmdhist
shopt -s extglob
shopt -s histappend

export HISTCONTROL=ignoreboth

export VIRTUAL_ENV_DISABLE_PROMPT=Please!!!

if [ -f "$HOME/.pythonrc" ]
then
  export PYTHONSTARTUP=$HOME/.pythonrc
fi

if [ -d "$HOME/usr/lib/python" ]
then
  export PYTHONPATH=$HOME/usr/lib/python
fi

