#!/bin/bash
source conf.cfg

prev_value=""

while true; do

# Input text (your response)
current_value=$(mmcli -m 0 --command='AT+QENG="servingcell"' | grep '+QENG: "LTE"' | awk -F, '{mcc=$3; mnc=$4; cellid=$5; print mcc, mnc, cellid}' | while read -r mcc mnc cellid; do printf "%s %s %d\n" "$mcc" "$mnc" "$((16#$cellid))"; done)

# Check if the current value is different from the previous value
if [[ "$current_value" != "$prev_value" ]]; then
        read -r mcc mnc cellid <<< "$current_value"
        echo MCC:"$mcc" MNC:"$mnc" CELL_ID:"$cellid" -  $(date +"%T")
        prev_value="$current_value" # Update prev_value to the current value
        #date +"%T"
        #/home/taltech/SUPL-3GPP-LPP-client/build/example-lpp osr -f rtcm -h 129.192.82.125 -p 5431 --imsi=248270000000001 -c "$mcc" -n "$mnc" -t 1 -i "$cellid" --tcp=192.168.3.1 --tcp-port=3000
fi

sleep $TIME
done