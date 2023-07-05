#!/bin/bash

NULL=/dev/null
MAX_PID=65535

pid=1
while (( $pid < $MAX_PID ))
do
    if kill -0 $pid 2> $NULL
    then
        echo "INFO: Process $pid exists"

        if ! ls /proc | grep ^$pid$ > $NULL
        then
            ppid=$(grep '^Tgid:' /proc/$pid/status | grep -Eo '[[:digit:]]+$')

            if [ -n $ppid ]
            then
                if [ $pid != $ppid ] && ! ls /proc | grep ^$pid$ > $NULL
                then
                    echo "INFO: Process $pid is thread of $ppid: `cat /proc/$ppid/comm`"
                else
                    echo WARN: process $pid not in proc: `cat /proc/$pid/comm` >&2
                fi
            fi
        fi
    fi

    pid=$((pid+1))
done
