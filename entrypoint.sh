#!/bin/sh

rtp_stream () {
    cat <<EOF
[rtp]
type = rtp
id = $1
description = feed $1
audio = no
video = yes
videoport = $2
videopt = 126
videortpmap = H264/90000
videofmtp = profile-level-id=42e01f\;packetization-mode=1
EOF
}

rtsp_stream () {
    cat <<EOF
[rtsp]
type = rtsp
id = $i
description = cellnex 2
audio = no
video = yes
url=
rtsp_user=
rtsp_pwd=
videofmtp = profile-level-id=42e01f\;packetization-mode=1
EOF
}

case $FEED_COUNT in
    ''|*[!0-9]*)
        echo "expected \$FEED_COUNT to be an integer, got: $FEED_COUNT" >&2
        exit 1
        ;;
    *)
        port_range_start=10001
        port_range_end=$(( 10000 + FEED_COUNT ))
        echo "creating $FEED_COUNT RTP streams listening on ports $port_range_start-$port_range_end"
        ;;
esac

id=1
while { port=$(( port_range_start + id - 1 )); [ $port -le $port_range_end ]; } do
    rtp_stream $id $port
    id=$(( id + 1 ))
done > /opt/janus/etc/janus/janus.plugin.streaming.cfg

service nginx restart && /opt/janus/bin/janus --nat-1-1=${DOCKER_IP}
