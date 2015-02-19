################################################################################
# .bashrc
#
# Author: Ryan Jacobs <ryan.mjacobs@gmail.com>
#
#  March 18, 2014 -> File creation.
#  April 29, 2014 -> Created doxc function.
#  April 30, 2014 -> Colorize prompt as red if user is root.
#   July 31, 2014 -> Renamed media_len to medialen. If no path is given default
#                    to the current path.
# August 05, 2014 -> Enable BASH Completion.
# August 20, 2014 -> Add msleep() function to sleep for n minutes.
# August 28, 2014 -> Remove function keyword for compatibility with other shells.
#  Sept. 11, 2014 -> Remove msleep(). Turns out you can do that with sleep n[m].
#   Oct. 03, 2014 -> Add 'When Exists' function.
#   Oct. 05, 2014 -> Change browser from firefox to chrome.
#   Oct. 12, 2014 -> Add '.PHONY: clean' to defmake.
#   Nov. 06, 2014 -> Source hhlighter script.
#   Nov. 11, 2014 -> Rename "google-chrome-stable" to "google-chrome".
#   Dec. 03, 2014 -> Set tty for GPG and pinentry-curses.
#   Dec. 13, 2014 -> alias def="sdcv"
#   Jan. 20, 2014 -> Add builds_path.
################################################################################

################################################################################
# BASH & Terminal Setup
################################################################################

# Set the locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Enable BASH Completion
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

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

# Default Editor
export EDITOR="vim"

# Set tty for GPG and pinentry-curses
export GPG_TTY=$(tty)

# Include the local bin
bin_path="$HOME/.bin"
builds_path="$HOME/builds/usr/bin"
npm_path="$(npm config get prefix 2>/dev/null)/bin"
ruby_path="$(ruby -rubygems -e "puts Gem.user_dir" 2>/dev/null)/bin"
cabal_path="$HOME/.cabal/bin"
PATH="$bin_path:$builds_path:$PATH:$npm_path:$ruby_path:$cabal_path"
LD_LIBRARY_PATH="$HOME/builds/usr/lib:$LD_LIBRARY_PATH"

# Source in bash functions
source "$bin_path/h.sh"

# Enable recursive globbing, (available in BASH v4 and above)
shopt -s globstar

# Keep history when BASH exits
shopt -s histappend

# Check window size after each command. Then, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# History ignore commands starting with space
HISTCONTROL="ignorespace"
HISTFILESIZE=50000000
HISTSIZE=1000000

################################################################################
# Aliases
################################################################################

# General aliases
alias def="sdcv"

# Colorize ls and grep
alias ls="ls --color=auto"
alias grep="grep --colour=auto"

# Don't send the 'Erase is backspace.' message on XTerm when reset.
alias reset="reset -Q"

# Just a timestamp/datestamp format that I prefer.
# Useful as such: echo "hello world" > file_$(ts).txt
alias timestamp="date +%T"
alias datestamp="date +%F"
alias ts=timestamp
alias ds=datestamp

# Basic Bash prompt
alias basic_prompt='PS1="\e[01;34m-> \e[00m"'

# Allows sl (joke train program) to be interrupted with ^C
alias sl="sl -e"
alias LS="LS -e"

# Resize images to fit in feh
alias feh="feh -."

# Launch irssi with the Jellybeans theme
alias irssi="xterm -name jellybeans -e 'irssi' & exit"

# Disable BASH History
alias historyoff="set +o history; history -c"

# If colordiff is installed, use it instead of normal diff
if hash colordiff &>/dev/null; then
    alias diff="colordiff"
fi

################################################################################
# Useful Functions
################################################################################

# When Exists. Loop every seconds and when file exists, return 0
we() {
    OPTIND=1
    opt_help=false
    opt_bytes=0
    while getopts "hb:" opt; do
        case $opt in
            h) opt_help=true;;
            b) opt_bytes=$OPTARG;;
        esac
    done

    shift $((OPTIND-1))
    file=$1

    if [ -z "$file" ] || [ $opt_help == true ]; then
        printf "Wait until the file exists, then return 0.\n"
        printf "Usage: %s [-b bytes] <file>\n" $FUNCNAME
        return 1
    fi

    while true; do
        if [ -f "$file" ]; then
            size=$(stat --printf="%s" "$file")
            if [ "$size" -ge "$opt_bytes" ]; then
                return 0
            fi
        fi
        sleep 1
    done
}

# Launch web browser and exit
internet() {
    OPTIND=1 # reset getopts
    opt_help=false

    while getopts "hg:" opt; do
        case $opt in
            h)
                opt_help=true
                ;;
        esac
    done

    if [ $opt_help == true ]; then
        printf "Launch web browser and exit.\n"
        printf "Usage: %s [site...]\n" $FUNCNAME
        return 0
    fi

    if [ $# -gt 0 ]; then
       #firefox -private "$@" & exit
        google-chrome --incognito "$@" & exit
    else
        google-chrome --incognito "http://www.google.com/" & exit
    fi
}

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
serve() {
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

    pv -rpbe "$FILE" | netcat -l $PORT
}

# Use google translate for locale based TTS
say() {
    if [[ "${1}" =~ -[a-z]{2} ]]; then
        local lang=${1#-}
        local text="${*#$1}"
    else local lang=${LANG%_*}
        local text="$*"
    fi
       
    if hash "mpv"; then
        player="mpv"
    elif hash "mplayer"; then
        player="mplayer"
    fi

   $player "http://translate.google.com/translate_tts?ie=UTF-8&tl=${lang}&q=${text}" &> /dev/null
}

# Find the total length of playable media in a directory
medialen() {
    if   [ $# -eq 1 ]; then
        SEARCH_PATH="$1"
    elif [ $# -eq 0 ]; then
        SEARCH_PATH=$PWD
    else
        printf "Finds the total length of playable media in a directory.\n"
        printf "Output format is: DD:HH:MM:SS.\n\n"
        printf "Usage: %s <PATH>\n" $FUNCNAME
        return 1
    fi

    find "$SEARCH_PATH" -type f -print0 |\
    xargs -0  mplayer -vo dummy -ao dummy -identify 2>/dev/null |\
    perl -nle '/ID_LENGTH=([0-9\.]+)/ && ($t += $1) && printf "%02d:%02d:%02d:%02d\n",$t/86400,$t/3600%24,$t/60%60,$t%60'
} 

# Create a C file template, compatible with Doxygen
doxc() {
    # Global Variables
    AUTHOR="Ryan Jacobs <ryan.mjacobs@gmail.com>"

    if [ $# == 0 ]; then
        printf "Creates C files in a Doxygen compatible format.\n"
        printf "Usage: %s <file1> [file2] [file3]\n" $FUNCNAME
        return 1
    fi

    for file in "$@"; do
        filename=$(basename "$file")
        extension="${filename##*.}"

        printf "File: %s\n" "$file"

        if [ -f "$file" ]; then
            printf "\tFile already exists! Skipping.\n"
        elif [ "$extension" == "h" ]; then
            touch "$file"
            header_name=$(echo "$(basename $file)" | tr "." "_" | tr "[:lower:]" "[:upper:]")
            printf "/**\n"                                         >> "$file"
            printf " * @file    %s\n" "$filename"                  >> "$file"
            printf " * @brief   Brief description of the file.\n"  >> "$file"
            printf " *\n"                                          >> "$file"
            printf " * @detail\n"                                  >> "$file"
            printf " *          Detailed description goes here,\n" >> "$file"
            printf " *          and can extend down here.\n"       >> "$file"
            printf " *\n"                                          >> "$file"
            printf " * @author  %s\n" "$AUTHOR"                    >> "$file"
            printf " * @date    %s\n" "$(date '+%B %d, %Y')"       >> "$file"
            printf " * @bug     No known bugs.\n"                  >> "$file"
            printf " */\n"                                         >> "$file"
            printf "\n"                                            >> "$file"
            printf "#ifndef %s\n" "$header_name"                   >> "$file"
            printf "#define %s\n" "$header_name"                   >> "$file"
            printf "\n"                                            >> "$file"
            printf "#endif /* %s */\n" "$header_name"              >> "$file"
            printf "\tFile created successfully!\n"
        else
            touch "$file"
            printf "/**\n"                                         >> "$file"
            printf " * @file    %s\n" "$file"                      >> "$file"
            printf " * @brief   Brief description of the file.\n"  >> "$file"
            printf " *\n"                                          >> "$file"
            printf " * @detail\n"                                  >> "$file"
            printf " *          Detailed description goes here,\n" >> "$file"
            printf " *          and can extend down here.\n"       >> "$file"
            printf " *\n"                                          >> "$file"
            printf " * @author  %s\n" "$AUTHOR"                    >> "$file"
            printf " * @date    %s\n" "$(date '+%B %d, %Y')"       >> "$file"
            printf " * @bug     No known bugs.\n"                  >> "$file"
            printf " */\n"                                         >> "$file"
            printf "\tFile created successfully!\n"
        fi
    done
}

# Create a default Makefile for C projects
defmake() {
    # Global variables
    FILE="Makefile"

    if [ $# == 0 ]; then
        printf "Create a Makefile for C projects.\n"
        printf "Usage: %s <executable_name> <source1> [source2] [source3...]\n" $FUNCNAME
        return 1
    fi

    EXECUTABLE=$1; shift
    SOURCES="$@"

    printf "CC=gcc\n"                                                                           >> "$FILE"
    printf "CFLAGS=-c -Wall\n"                                                                  >> "$FILE"
    printf "LDFLAGS=\n"                                                                         >> "$FILE"
    printf "SOURCES=%s\n" "$SOURCES"                                                            >> "$FILE"
    printf "OBJECTS=\$(SOURCES:.c=.o)\n"                                                        >> "$FILE"
    printf "EXECUTABLE=%s\n" "$EXECUTABLE"                                                      >> "$FILE"

    printf "all: \$(SOURCES) \$(EXECUTABLE)\n\n"                                                >> "$FILE"

    printf "\$(EXECUTABLE): \$(OBJECTS)\n"                                                      >> "$FILE"
    printf "\t\$(CC) \$(OBJECTS) \$(LDFLAGS) -o \$@\n\n"                                        >> "$FILE"

    printf ".c.o:\n"                                                                            >> "$FILE"
    printf "\t\$(CC) \$(CFLAGS) \$< -o \$@\n\n"                                                 >> "$FILE"

    printf "clean:\n"                                                                           >> "$FILE"
    printf "\trm -f \$(EXECUTABLE)\n"                                                           >> "$FILE"
    printf "\trm -f *.o\n\n"                                                                    >> "$FILE"

    printf ".PHONY: clean\n"                                                                    >> "$FILE"
}
