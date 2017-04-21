#!/usr/bin/env bash

set -e

#sudo apt-get update
#sudo apt-get upgrade
#sudo apt-get install vim git ncurses-dev
#git clone https://github.com/Limvot/vim_config.git
#cd vim_config
#git submodule init
#git submodule update
#./setup.sh



cd
if ! [ -s "packages" ]
then
    mkdir packages
fi
cd packages

if ! [ -s "installed" ]
then
    mkdir installed
fi
PREFIX=$(pwd)/installed
if ! [ -s "added_to_bashrc" ]
then
    echo "export PATH=$PREFIX/bin:\$PATH" >> ~/.bashrc
    echo "export LD_LIBRARY_PATH=$PREFIX/lib:\$LD_LIBRARY_PATH" >> ~/.bashrc
    echo "added" > added_to_bashrc
fi

easy_pkg() {
    URL=$1
    ARCHIVE="${URL##*/}"
    FOLDER="${ARCHIVE%.tar.gz}"
    echo "$URL, $ARCHIVE, $FOLDER"

    if ! [ -s "$ARCHIVE" ]
    then
        wget $URL
    fi

    if ! [ -s "$FOLDER.finished" ]
    then
        echo "$FOLDER.finished does not exist"
        if [ -s "$FOLDER" ]
        then
            rm -r "$FOLDER"
        fi

        tar xf $ARCHIVE

        cd $FOLDER
        env CPPFLAGS="-I$PREFIX/include/" LDFLAGS="-L$PREFIX/lib/" ./configure --prefix=$PREFIX
        make
        make install
        cd ..
        echo "finished" > "$FOLDER.finished"
    fi
}

easy_pkg https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
easy_pkg https://github.com/tmux/tmux/releases/download/2.3/tmux-2.3.tar.gz

# suckless st
if ! [ -s st ]
then
    sudo apt install libx11-dev libxft-dev libxext-dev
    git clone git://git.suckless.org/st
    cd st
    git checkout tags/0.7
    cp ~/vim_config/config.h ./
    sed 's#PREFIX =.*#PREFIX = '$PREFIX'#g' config.mk -i
    make clean install
fi
