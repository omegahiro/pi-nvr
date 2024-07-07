#!/bin/bash

# Load settings
source service.conf

# Record RTSP stream
ffmpeg -hide_banner -y -loglevel error \
    -rtsp_transport tcp -stimeout 10000000 -use_wallclock_as_timestamps 1 \
    -i $RTSP_URL \
    -vcodec copy -acodec aac -f segment \
    -reset_timestamps 1 -segment_time $SEGMENT_TIME -segment_format mp4 \
    -segment_atclocktime 1 -strftime 1 data/%Y%m%dT%H%M%S.mp4
