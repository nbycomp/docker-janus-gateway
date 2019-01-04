cat <<FOO > /opt/janus/etc/janus/janus.plugin.streaming.cfg
[rtp]
type = rtp
id = 1
description = ${FEED1_LABEL}
audio = no
video = yes
videoport = 10001
videopt = 126
videortpmap = H264/90000
videofmtp = profile-level-id=42e01f\;packetization-mode=1

[rtsp]
type = rtsp
id = 2
description = ${FEED2_LABEL}
audio = no
video = yes
url= ${FEED2_URL}
rtsp_user=${FEED2_USER}
rtsp_pwd=${FEED2_PASSWORD}
videofmtp = profile-level-id=42e01f\;packetization-mode=1
FOO

service nginx restart && /opt/janus/bin/janus --nat-1-1=${DOCKER_IP}