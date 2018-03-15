# Set the locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# enable terminal colors
[ -z "$TERM" ] && export TERM=xterm-256color

# bash completion
[ -r /usr/share/bash-completion/bash_completion ] &&\
   . /usr/share/bash-completion/bash_completion

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

export EDITOR="vim"
export GPG_TTY=$(tty) # enable tty for GPG and pinentry-curses

shopt -s globstar     # recursive globbing
shopt -s histappend   # keep history when BASH exits
shopt -s checkwinsize # resize window after each command

# History ignore commands starting with space
HISTCONTROL="ignorespace"
HISTFILESIZE=50000000
HISTSIZE=1000000

################################################################################
# Aliases
################################################################################

# General aliases
alias def="sdcv"
alias vim="nvim"

# Colorize ls and grep
alias ls="ls --color=auto --quoting-style=literal"
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

# If colordiff is installed, use it instead of normal diff
if hash colordiff &>/dev/null; then
    alias diff="colordiff"
fi

################################################################################
# Useful Functions
################################################################################

# Set the terminal title
xtitle() {
    unset PROMPT_COMMAND
    echo -ne "\033]0;${@}\007"
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
            printf " */\n"                                         >> "$file"
            printf "\tFile created successfully!\n"
        fi
    done
}

# Create a default Makefile for C projects
defmake() {
    if [ $# -gt 1 ]; then
        echo "Create a Makefile for C projects."
        echo "Usage: $FUNCNAME [executable_name]"
        return 1
    fi

    [ -n "$1" ] && executable="$1" || executable=a.out
    [ ! -d src ] && mkdir src

     >Makefile echo -e "CC=gcc"
    >>Makefile echo -e "CFLAGS=-c -Wall"
    >>Makefile echo -e "LDFLAGS="
    >>Makefile echo -e "SOURCES=\$(shell find src/ -type f -name '*.c')"
    >>Makefile echo -e "OBJECTS=\$(SOURCES:.c=.o)"
    >>Makefile echo -e "EXECUTABLE=$executable\n"

    >>Makefile echo -e "all: \$(SOURCES) \$(EXECUTABLE)\n"

    >>Makefile echo -e "\$(EXECUTABLE): \$(OBJECTS)"
    >>Makefile echo -e "\t\$(CC) \$(OBJECTS) \$(LDFLAGS) -o \$@\n"

    >>Makefile echo -e ".c.o:"
    >>Makefile echo -e "\t\$(CC) \$(CPPFLAGS) \$(CFLAGS) \$< -o \$@\n"

    >>Makefile echo -e "clean:"
    >>Makefile echo -e "\trm -f \$(EXECUTABLE)"
	>>Makefile echo -e "\t@find src/ -type f -name '*.o' -exec rm -vf {} \\;\n"

    >>Makefile echo -e ".PHONY: clean"
}

for n in {2..20}; do
    eval "${n}x() { for n in `seq -s' ' $n`; do" '$@; done }'
    eval "x${n}() { for n in `seq -s' ' $n`; do" '$@; done }'
done &>/dev/null
xx() { while true; do "$@"; done }
