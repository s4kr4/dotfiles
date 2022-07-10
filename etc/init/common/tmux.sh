#!/bin/bash

. "$DOTPATH"/etc/lib/util.zsh

if ! has "tmux"; then
    if ! has "git"; then
        log_fail "ERROR: Require git"
        exit 1
    else
        case "$(get_os)" in
            osx)
                install libevent
                install automake
                install pkg-config
                return
                ;;

            linux)
                install gcc
                install libevent-dev
                install libncurses5-dev
                install automake
                install pkg-config
                install bison
                if [ "$?" -eq 1 ]; then
                    return
                fi
                ;;

            *)
                log_fail "ERROR: This script is only supported OSX or Linux"
                return
                ;;
        esac

        cdirectory=`pwd`
        git clone https://github.com/tmux/tmux.git ${HOME}/tmp/tmux
        cd ${HOME}/tmp/tmux
        sh autogen.sh
        ./configure --enable-utf8proc && make
        sudo make install
        cd "$cdirectory"
    fi

    log_pass "tmux: Installed tmux successfully"
else
    log_pass "tmux: Already installed"
fi

