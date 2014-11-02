#!/bin/bash

TMUXCOMMIT=${1:-"origin/master"}

{
  # Install latest stable version of libevent
  git clone https://github.com/nmathewson/Libevent.git libevent
  cd libevent
  git checkout $(git tag | grep stable | sort --version-sort | tail -n 1)
  ./autogen.sh
  ./configure --prefix=/usr --enable-static --enable-shared --disable-openssl
  make
  make install
  cd ..
  
  # Install latest stable version of ncurses
  wget ftp://invisible-island.net/ncurses/ncurses.tar.gz
  tar xf ncurses.tar.gz
  cd ncurses-*
  ./configure
  make
  make install
  cd .. 
  
  # Build latest version of tmux
  git clone git://git.code.sf.net/p/tmux/tmux-code tmux
  cd tmux
  git checkout $TMUXCOMMIT
  for patch in $(ls /mnt/patches/tmux*.patch); do
    patch -p1 < $patch
  done
  ./autogen.sh
  ./configure --enable-static
  make
} > >(tee /buildlog) 2>&1

cd /tmux
COMMIT=$(git rev-parse HEAD)
BUILDREV=$(($(ls /mnt/tmux-${COMMIT}-* 2>/dev/null | wc -l)+1))

mv /tmux/tmux /mnt/tmux-${COMMIT}-${BUILDREV}
mkdir /mnt/buildlogs/ 2>/dev/null
mv /buildlog /mnt/buildlogs/buildlog-${COMMIT}-${BUILDREV}
