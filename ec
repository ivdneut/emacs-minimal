#!/bin/bash 

if echo ${TERM} | grep -q screen ; then
    export TERM=screen
else
    export TERM=xterm-color
fi

function startemacs () {
    if [ ! -z ${project} ] ; then
        if ! ps -fu ${USER} | grep -E "emacs --daemon=${project}$" | grep -v grep > /dev/null ; then
            emacs --daemon=${project} > /dev/null 2>&1
        fi
    else
        if ! ps -fu ${USER} | grep -E "emacs --daemon$" | grep -v grep > /dev/null ; then
            emacs --daemon > /dev/null 2>&1
        fi
    fi
}

cmd=`basename $0`
if [ ${cmd} = 'tec' ] ; then
    #export DISABLE_WAKIB="yes"
    opt="-t" # Run emacsclient in a terminal, in the foreground
elif [ ${cmd} = 'fgec' ] ; then
    opt="--create-frame" # Run emacsclient in the foreground.
else
    opt="--create-frame --no-wait"
fi

export ALTERNATE_EDITOR=""
startemacs
if [ ! -z ${project} ] ; then
    serveropt="-s ${project}"
else
    serveropt=""
fi
if [ -z ${DISPLAY} ] ; then
    EC="emacsclient -t"
else
    EC="emacsclient ${opt}"
fi
if [ $# -eq 0 ] ; then
    ${EC}
    exit 0
fi
while (( "$#" )) ; do
    if echo $1 | grep -E '^\+[0-9]+' > /dev/null ; then
        echo "${EC} ${serveropt} $1 $2"
        ${EC} ${serveropt} $1 $2 2> /dev/null
        status=$?
        shift
    else
        echo "${EC} ${serveropt} $1"
        ${EC} ${serveropt} $1 2> /dev/null
        status=$?
    fi
    shift
done

exit ${status}
