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
HISTSIZE=1000
HISTFILESIZE=2000

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
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

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
    # Original PS1 below:
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    #
    # This guide helped: https://linuxhint.com/bash-ps1-customization/
    # https://www.nerdfonts.com/cheat-sheet
    # Also, on nerd font cheat sheet, try searching "divider" or "triangle"
    # \e[m will stop the background from going past the PS1
    # I added a custom color scheme to Windows terminal, by adding the json schemes from:
    #   https://github.com/catppuccin/windows-terminal
    # I did this by pasting the color schemes into schemes at:
    #   %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
    # To view the complete font, open the "Character Map" program in windows.
    # `\[` and `\]` are called non-printing character delimiters, and surround areas of text which should
    #   not be added to the character length of the bash prompt.
    #   - `\001\` and `\002` can be used as a replacement of these delimiters, in variables.
    # `eval` is used before some variables, to evaluate the value completely, this will
    #   ensure that the sub-variable's area is correctly concatentated.

    BG_COLOR_ONE_TEXT=$'\001\e[34m\002' # The background color, applied ot transition text
    BG_COLOR_ONE_BG=$'\001\e[44m\002' # The background color, applied to background

    BG_COLOR_TWO_TEXT=$'\001\e[35m\002' # The background color, applied ot transition text
    BG_COLOR_TWO_BG=$'\001\e[45m\002' # The background color, applied to background

    eval TEXT_COLOR=$'\001\e[30m\002' # The color of the text within the prompt

    # If on an ssh connection, change the background color of u@h
    if [ -n "$SSH_CLIENT" ]; then
      BG_COLOR_ONE_TEXT=$'\001\e[31m\002'
      BG_COLOR_ONE_BG=$'\001\e[41m\002' # The background color, applied to background
    fi

    # The rounded corner beginning of the bash prompt
    eval ROUNDED_START=$'${BG_COLOR_ONE_TEXT}\ue0b6'

    # Transparent triangles transition
    eval TRANSITION_ONE=$'\001\e[m\002${BG_COLOR_ONE_TEXT}\ue0b0${BG_COLOR_TWO_TEXT}\ue0D7\001\e[m\002${BG_COLOR_TWO_BG}'
    # Ending Triangle
    eval TRANSITION_END=$'\001\e[m\002${BG_COLOR_TWO_TEXT}\ue0b0'

    #                                            username@hostname                         dir
    PS1=$'${ROUNDED_START}${BG_COLOR_ONE_BG}${TEXT_COLOR}\u@\H ${TRANSITION_ONE}${TEXT_COLOR} \w ${TRANSITION_END}\[\e[m \]'
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

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

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

alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
alias dt='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
