#!/bin/bash

read_cpu() {
    awk '/cpu /{print $2+$3+$4+$5+$6+$7+$8+$9+$10,$5}' /proc/stat
}

read -r total1 idle1 < <(read_cpu)
sleep 0.1
read -r total2 idle2 < <(read_cpu)

usage=$(( ( (total2 - total1) - (idle2 - idle1) ) * 100 / (total2 - total1) ))

if [ "$usage" -ge 90 ]; then
    echo "{\"text\": \"$usage\", \"class\": \"critical\"}"
elif [ "$usage" -ge 70 ]; then
    echo "{\"text\": \"$usage\", \"class\": \"warning\"}"
else
    echo "{\"text\": \"$usage\"}"
fi
