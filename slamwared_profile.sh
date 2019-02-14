#!/bin/bash

# ./slamwared -t /etc/sdp_ref.json 2>&1 | grep "Iteration time" --line-buffered | { while read LINE; do echo [`date +%s`]$LINE;done }
# rp.applet.slamsdp.SDPController

/usr/bin/slamwared -t /etc/sdp_ref.json 2>&1 | \grep -E "\rp.algorithm.slam.SDPSLAMBuilder\" --line-buffered | \
{
    while read LINE; 
	do echo [`date +%s`]$LINE
    done
} 
| tee /tmp/slamwared.log
