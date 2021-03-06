#!/bin/bash
############################
# setup.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="bashrc vimrc vim zshrc oh-my-zsh"    # list of files/folders to symlink in homedir

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
  echo "Moving any existing dotfiles from ~ to $olddir"
  mv ~/.$file ~/dotfiles_old/
  echo "Creating symlink to $file in home directory."
  ln -s $dir/$file ~/.$file
done

install_zsh () {
# Test to see if zshell is installed.  If it is:
if [ -f /bin/zsh -o -f /usr/bin/zsh -o -f ${HOME}/bin/zsh ]; then
  # Clone my oh-my-zsh repository from GitHub only if it isn't already present
  if [ ! -d ${dir} ]; then
    cd ~
    git clone http://github.com/JakeTobak/dotfiles.git
  fi
else
  local tempdir=$(mktemp --directory)
  curl -L http://www.zsh.org/pub/zsh.tar.gz \
    | tar -zx --strip-components 1 -C ${tempdir}
  mkdir -p ${HOME}/bin
  mkdir -p ${HOME}/etc/zsh
  cd ${tempdir}
  ./configure --prefix=${HOME}/etc/zsh
  make
  make install
  cd -
  rm -rf ${tempdir}
  ln -s ${HOME}/etc/zsh/bin/zsh ${HOME}/bin/zsh
  install_zsh
fi
}

install_zsh
