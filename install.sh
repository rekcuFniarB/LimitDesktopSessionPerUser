#!/bin/sh

##  LimitSessionPerUser - allow only one desktop session per user.
##  Copyright (C) 2019  rekcuFniarB <retratserif@gmail.com>
##  
##  This program is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##  
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.

## Print messages to stderr
errlog () {
    echo "$@" 1>&2
}

umask 002

## Check for required utils
REQUIREMENTS='grep awk sed head loginctl id'
for UTIL in $REQUIREMENTS; do
    if [ -z "$(which $UTIL)" ]; then
        errlog "Required util '$UTIL' not found. Install aborted."
        exit 1
    fi
done

if [ ! "$(id -u)" -eq 0 ]; then
    errlog "This should be run as root."
    exit 1
fi

DIR="$(dirname "$0")"
INSTALLDIR='/opt/LimitSessionPerUser'

if [ _"$1" = _'--uninstall' ] && [ -d "$INSTALLDIR" ]; then
    rm -rf "$INSTALLDIR"
    rm '/usr/local/bin/limitsessionperuser'
    rm '/etc/limitsessionperuser.conf'
    rm '/usr/share/xsessions/limitsessionperuser.desktop'
    exit 0
fi

if [ ! -d "$INSTALLDIR" ]; then
    mkdir "$INSTALLDIR"
fi

cp "$DIR/limitsessionperuser.conf" "$INSTALLDIR/"
cp "$DIR/limitsessionperuser.sh" "$INSTALLDIR/"
cp "$DIR/limitsessionperuser.desktop" "$INSTALLDIR/"
cp "$DIR/install.sh" "$INSTALLDIR/"
cp "$DIR/README.md" "$INSTALLDIR/"
cp "$DIR/LICENSE.txt" "$INSTALLDIR/"

if [ -f '/usr/local/bin/limitsessionperuser' ]; then
    rm  '/usr/local/bin/limitsessionperuser'
fi
ln -s "$INSTALLDIR/limitsessionperuser.sh" '/usr/local/bin/limitsessionperuser'

if [ -f '/etc/limitsessionperuser.conf' ]; then
    rm  '/etc/limitsessionperuser.conf'
fi
ln -s "$INSTALLDIR/limitsessionperuser.conf" '/etc/limitsessionperuser.conf'

if [ -f '/usr/share/xsessions/limitsessionperuser.desktop' ]; then
    rm  '/usr/share/xsessions/limitsessionperuser.desktop'
fi
ln -s "$INSTALLDIR/limitsessionperuser.desktop" '/usr/share/xsessions/limitsessionperuser.desktop'
