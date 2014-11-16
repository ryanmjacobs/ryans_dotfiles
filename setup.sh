################################################################################
# setup.sh
#
# Run './setup.sh' to intall dotfiles in home with symlinks.
#
# Maintained By: Ryan Jacobs <ryan.mjacobs@gmail.com>
# October 03, 2014 -> File creation.
################################################################################

dir=$(pwd -P)
home=$HOME

config_install=(\
    'dunst'
)
basic_install=(\
    '.bashrc'\ 
    '.dir_colors'\ 
    '.irssi'\ 
    '.inputrc'\ 
    '.mplayer'\ 
    '.mpv'\ 
    '.profile'\ 
    '.tmux.conf'\ 
    '.vim'\ 
    '.vimrc'\ 
    '.Xresources'\ 
)
full_install=(\
    '.abcde.conf'\ 
    '.bashrc'\ 
    '.bin'\ 
    '.dir_colors'\ 
    '.gitconfig'\ 
    '.gnuplot'\ 
    '.irssi'\ 
    '.inputrc'\ 
    '.mplayer'\ 
    '.mpv'\ 
    '.profile'\ 
    '.tmux.conf'\ 
    '.twmrc'\ 
    '.vim'\ 
    '.vimrc'\ 
    '.vitetris'\ 
    '.vnc'\ 
    '.xinitrc'\ 
    '.Xresources'\ 
)

# Usage: help_msg
help_msg() {
    printf "Usage: $0 [options]\n"
    printf "Installs ryans_dotfiles into your \$HOME.\n\n"
    printf "  --help     Display this help message.\n"
    printf "  --basic    Install only the basics.\n"
    printf "  --full     Install everything!\n"
    printf "  --copy     Copy files instead of symlinking.\n"
    printf "  --symlink  Symlink files instead of copying.\n"
    printf "  --force    Overwrite existing files.\n"

    printf "\nDefault run: $0 --basic --copy\n"

    printf "\nReport bugs to <ryan.mjacobs@gmail.com>.\n"
}

# Get arguments
basic_flag=true
full_flag=false
copy_flag=true
symlink_flag=false
force_flag=false
while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            help_msg
            exit 0;;
        --basic)
            basic_flag=true
            full_flag=false
            shift;;
        --full)
            full_flag=true
            basic_flag=false
            shift;;
        --copy)
            copy_flag=true
            symlink_flag=false
            shift;;
        --symlink)
            symlink_flag=true
            copy_flag=false
            shift;;
        --force)
            force_flag=true
            shift;;
        *)
            break;;
    esac
done

if [ $basic_flag == true ]; then
    files="${basic_install[@]}"
elif [ $full_flag == true ]; then
    files="${full_install[@]}"
fi

# Install normal dotfiles
printf "Installing into $home/\n\n"
pushd "$home"
    for file in ${files[@]}; do
        [ $force_flag == true ] && rm -r "$home/$file"

        if [ $copy_flag == true ]; then
            cp --verbose --recursive "$dir/$file" "$home"
        elif [ $symlink_flag == true ]; then
            ln --verbose --symbolic "$dir/$file" "$home"
        fi

        if [ $? -ne 0 ]; then
            printf "\nFailed to install!\nQuitting.\n"
            exit 1
        fi
    done
popd

# Install .config/ files
printf "Installing into $home/.config/\n\n"
[ ! -d "$home/.config" ] && mkdir -v "$home/.config"
pushd "$home/.config"
    for config in ${config_install[@]}; do
        [ $force_flag == true ] && rm -r "$config"

        if [ $copy_flag == true ]; then
            cp --verbose --recursive "$dir/.config/$config" .
        elif [ $symlink_flag == true ]; then
            ln --verbose --symbolic "$dir/.config/$config" .
        fi

        if [ $? -ne 0 ]; then
            printf "\nFailed to install!\nQuitting.\n"
            exit 1
        fi
    done
popd

printf "\nSuccessfully installed!\nQuitting.\n"
exit 0
