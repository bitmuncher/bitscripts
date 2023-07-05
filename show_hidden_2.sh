#!/bin/bash

# check if a process is hidden by sending signal 0 and validate responses with check of status files in /proc

NULL=/dev/null
PID_MAX_FILE=/proc/sys/kernel/pid_max

if [ ! -f $PID_MAX ]
then
    echo "ERROR: No such file $PID_MAX_FILE" >&2
    exit 1
fi

if [ $(whoami) != "root" ]
then
    echo "WARN: Run as root is recommended" >&2
fi

pid_max=$(cat $PID_MAX_FILE)
echo "INFO: Scanning up to PID $pid_max" >&2

pid=1
while (( $pid < $pid_max ))
do
    if kill -0 $pid 2> $NULL
    then
        echo "INFO: Process $pid exists: $(cat /proc/$pid/comm)" >&2

        if ! ls /proc | grep ^$pid$ > $NULL
        then
            s_tgid=$(grep '^Tgid:' /proc/$pid/status | grep -Eo '[[:digit:]]+$')
            s_pid=$(grep '^Pid:' /proc/$pid/status | grep -Eo '[[:digit:]]+$')

            if [ -n "$s_tgid" ] && [ -n "$s_pid" ]
            then
                if [ $pid = $s_tgid ]
                then
                    if  ! ls /proc | grep ^$pid$ > $NULL
                    then
                        echo "WARN: Process $pid not in /proc: $(cat /proc/$pid/comm)"
                    fi
                else
                    echo "INFO: Process $pid is thread of $s_tgid: $(cat /proc/$s_tgid/comm)" >&2
                fi
            else
                echo "ERROR: Cannot get status of process $pid" >&2
            fi
        fi
    fi

    pid=$((pid+1))
done
