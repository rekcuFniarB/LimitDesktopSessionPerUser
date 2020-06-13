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

DIR="$(dirname "$0")"

## Print messages to syslog
errlog () {
    logger "[LSPU] $@"
}

## Determine config file
if [ -f '/etc/limitsessionperuser.conf' ]; then
    CONF='/etc/limitsessionperuser.conf'
elif [ -f "$DIR/limitsessionperuser.conf" ]; then
    CONF="$DIR/limitsessionperuser.conf"
fi

## Load config
if [ -f "$CONF" ]; then
    . "$CONF"
fi

errlog "Using config $CONF"

## List of other sessions of current user
SESSIONS="$(loginctl list-sessions | grep seat | grep -v tty | grep $USER)"

## Determine session file
if [ -z "$SESSION" ] || [ ! -f "$SESSION" ]; then
    SESSION="/usr/share/xsessions/$(ls '/usr/share/xsessions' | head -n 1)"
fi

EXEC='true'
## Determine session start executable
if [ -n "$SESSION" ]; then
    EXEC="$(cat "$SESSION" | grep '^Exec=' | sed 's/Exec=//')"
fi

## Get ID of other existing session
ID="$(echo -n "$SESSIONS" | awk '{print $1}' | grep -v "$XDG_SESSION_ID" | head -n 1)"

if [ -n "$DEBUG" ]; then
    errlog "DEBUG: current session: '$XDG_SESSION_ID'"
    errlog "DEBUG: sessions: '$SESSIONS'"
    errlog "DEBUG: user '$USER'"
fi

if [ -n "$ID" ]; then
    # ACTION defined in config
    if [ _"$ACTION" = _"KILL" ]; then
        errlog "Terminating old session '$ID'"
	## terminate old session and start new
        loginctl terminate-session "$ID"
        ## Start session
        if [ -z "$TERMINATESESSION" ]; then
            exec "$EXEC"
        else
            "$EXEC"
            sleep 1
            errlog "Process '$EXEC' exited, terminating current session '$XDG_SESSION_ID'"
            loginctl terminate-session "$XDG_SESSION_ID"
        fi
    else
        ## If session exists switch to existing session.
        errlog "Found previously creted session '$ID'"
        errlog "Activating sesion ID '$ID'"
        exec loginctl activate "$ID"
    fi
else
    errlog "Starting new session '$SESSION'"
    errlog "Executing '$EXEC'"
    ## Start session
    if [ -z "$TERMINATESESSION" ]; then
        exec "$EXEC"
    else
        "$EXEC"
        sleep 1
        errlog "Process '$EXEC' exited, terminating current session '$XDG_SESSION_ID'"
        loginctl terminate-session "$XDG_SESSION_ID"
    fi
fi

exit $?
