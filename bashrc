#!/bin/bash

if [ -f /opt/local/etc/bash_completion ]; then
  . /opt/local/etc/bash_completion
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

##
# If the current directory is in a git working copy, shows the path relative to the
# working copy root as //repo/whatever.
#
# Otherwise, if the current directory is in the current user's home directory, shows
# the path relative to the home directory as ~/whatever.
#
# Otherwise, shows the absolute path.
##
function smart_path {
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

# Left-justified:  user@host:smart_path
# Right-justified: extra information about the git repository
# Second line: just the prompt (# for root, $ for others)
export PS1='$(printf "%${COLUMNS}s" "$(gitb_time 2>/dev/null)")\r\u@\h:$(smart_path) \n\$ '

export PATH

# Useful on Dvorak
alias u='ls'
alias uu='ls -l'
alias uua='ls -la'

# Useful in general
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

