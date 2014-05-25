################################################################################
# Personal .bashrc file
#
# Maintained By: Ryan Jacobs <ryan.mjacobs@gmail.com>
#
# March 18, 2014 -> Original Creation.
# April 29, 2014 -> Created doxc function.
# April 30, 2014 -> Colorize prompt as red if root user.
################################################################################

################################################################################
# BASH & Terminal Setup
################################################################################

# Set the locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Export the terminal's ability for 256 colors
TERM=xterm-256color

# Colorize with .dir_colors or /etc/DIR_COLORS
if [ -f "$HOME/.dir_colors" ]; then
    eval `dircolors "$HOME/.dir_colors"`
else
    eval `dircolors /etc/DIR_COLORS`
fi

# Colorize the prompt, green for user and red for root
if [ "$(id -u)" -ne 0 ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
elif [ "$(id -u)" -eq 0 ]; then
    PS1='\[\033[01;31m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
fi

# Colorize ls and grep
alias ls='ls --color=auto'
alias grep='grep --colour=auto'

# Default Editor
export EDITOR='vim'

# Include the local bin
PATH="$PATH:$HOME/.bin:/usr/local/msp430/bin"

# Enable recursive globbing, (available in BASH v4 and above)
shopt -s globstar

# Keep History when BASH exits
shopt -s histappend

# History ignore commands starting with space
HISTCONTROL='ignorespace'
HISTFILESIZE=50000000
HISTSIZE=1000000

################################################################################
# Aliases
################################################################################

# Don't send the 'Erase is backspace.' message on XTerm when reset.
alias reset='reset -Q'

# Just a timestamp/datestamp format that I prefer.
# Useful as such: echo "hello world" > file_$(ts).txt
alias timestamp='date +%T'
alias datestamp='date +%F'
alias ts=timestamp
alias ds=datestamp

# Basic Bash prompt
alias basic_prompt='PS1="\e[01;34m-> \e[00m"'

# Allows sl (joke train program) to be interrupted with ^C
alias sl='sl -e'
alias LS='LS -e'

################################################################################
# Useful Functions
################################################################################

# BASH Round Function
round() {
    if [ $# != 2 ]; then
        printf "BASH Round Function.\n"
        printf "Usage: %s <Number to Round> <Places to Round>\n" $FUNCNAME
        return 1
    fi

    if [ $2 -gt 64 ]; then
        printf "Unable to round further than 64 decimal places, defaulting to 64 places:\n\n"
        echo $(printf %.64f $(echo "scale=64;(((10^64)*$1)+0.5)/(10^64)" | bc))
    else
        echo $(printf %.$2f $(echo "scale=$2;(((10^$2)*$1)+0.5)/(10^$2)" | bc))
    fi
}

# Set the terminal title
xtitle() {
    unset PROMPT_COMMAND
    echo -ne "\033]0;${@}\007"
}

# Serve a file using netcat
# Only guaranteed to work using openbsd-netcat
function serve() {
    if [ $# != 2 ]; then
        printf "Serves a file using netcat.\n"
        printf "Usage: %s <file> <port>\n" $FUNCNAME
        return 1
    fi

    FILE="$1"
    PORT="$2"

    # Check the file even exists
    if [ ! -f "$FILE" ]; then
        printf "The file '%s' doesn't exist!\n" "$FILE"
        return 1
    fi

    cat "$FILE" | pv -s $(ls -l "$FILE" | awk '{print $5}') -rbpe | netcat -l $PORT
}

# Use google translate for locale based TTS
function say() {
    if [[ "${1}" =~ -[a-z]{2} ]]; then
        local lang=${1#-}
        local text="${*#$1}"
    else local lang=${LANG%_*}
        local text="$*"
    fi
       
    mplayer "http://translate.google.com/translate_tts?ie=UTF-8&tl=${lang}&q=${text}" &> /dev/null
}

#  Toggle a temporary ram partition
function ram_drive() {
    if [ $# != 0 ]; then
        printf "Creates a temporary RAM partition at /mnt/RAM.\n"
        printf "Usage: %s\n" $FUNCNAME
        return 1
    fi

    MOUNT="/mnt/RAM"
    SIZE="3072M"

    cat /proc/mounts | grep "$MOUNT" > /dev/null

    if [ $? -eq 0 ]; then
        read -p "Press <ENTER> to Remove RAM Partition:"
        sudo umount "$MOUNT" &&\
        printf "%s -> OFF\n" "$MOUNT" ||\
        printf "Error: couldn't unmount the RAM partition\n"
    else
        sudo mount -t tmpfs tmpfs "$MOUNT" -o size=$SIZE &&\
        printf "%s -> ON\n" "$MOUNT" ||\
        printf "Error: couldn't mount the RAM partition\n"
    fi
}

# Find the total length of playable media in a directory
function media_len() {
    if [ $# != 1 ]; then
        printf "Finds the total length of playable media in a directory.\n"
        printf "Output format is: DD:HH:MM:SS.\n\n"
        printf "Usage: %s <PATH>\n" $FUNCNAME
        return 1
    fi

    SEARCH_PATH="$1"

    find "$SEARCH_PATH" -type f -print0 |\
    xargs -0  mplayer -vo dummy -ao dummy -identify 2>/dev/null |\
    perl -nle '/ID_LENGTH=([0-9\.]+)/ && ($t += $1) && printf "%02d:%02d:%02d:%02d\n",$t/86400,$t/3600%24,$t/60%60,$t%60'
} 

# Create a C file template, compatible with Doxygen
function doxc() {
    # Global Variables
    AUTHOR="Ryan Jacobs (ryan.mjacobs@gmail.com)"

    if [ $# == 0 ]; then
        printf "Creates C files in a Doxygen compatible format.\n"
        printf "Usage: %s <file1> [file2] [file3]\n" $0
        return 1
    fi

    for file in "$@"; do
        printf "File: %s\n" $file

        if [ -f $file ]; then
            printf "\tFile already exists! Skipping.\n"
        else
            touch $file
            printf "/**\n"                                         >> $file
            printf " * @file    %s\n" $file                        >> $file
            printf " * @brief   Brief description of the file.\n"  >> $file
            printf " *\n"                                          >> $file
            printf " * @detail\n"                                  >> $file
            printf " *          Detailed description goes here,\n" >> $file
            printf " *          and can extend down here.\n"       >> $file
            printf " *\n"                                          >> $file
            printf " * @author  %s\n" "$AUTHOR"                    >> $file
            printf " * @date    %s\n" "$(date '+%B %d, %Y')"       >> $file
            printf " * @bug     No known bugs.\n"                  >> $file
            printf " */\n"                                         >> $file

            printf "\tFile created successfully!\n"
        fi
    done
}
