#!/bin/bash

# Load settings
source service.conf

# Check if the script is running on a Raspberry Pi
# The reason is unknown, but the timeout option is different between the Raspberry Pi and other systems
if [ "$IS_RASPBERRY_PI" -eq 1 ]; then
    TIMEOUT_OPTION="-timeout"
else
    TIMEOUT_OPTION="-stimeout"
fi

ffmpeg -hide_banner -y -loglevel error \
    -rtsp_transport tcp $TIMEOUT_OPTION 10000000 \
    -i $RTSP_URL -c:v copy -c:a aac \
    -hls_time 2 -hls_list_size 10 -hls_flags delete_segments -start_number 1 data/live/live.m3u8
