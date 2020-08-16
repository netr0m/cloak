FROM alpine
LABEL maintainer="Morten Amundsen <me@mortenamundsen.me>"

ENV USER=vpn
ENV PUID=1000
ENV PGID=1000

RUN addgroup -g $PGID $USER
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/tmp/$USER" \
    --ingroup "$USER" \
    --no-create-home \
    --uid "$PUID" \
    "$USER"

# Install openvpn
RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash curl ip6tables iptables openvpn tzdata busybox

HEALTHCHECK --interval=60s --timeout=10s --start-period=120s \
	CMD /usr/bin/healthcheck.sh

VOLUME ["/vpn"]

COPY run.sh run_ovpn.sh healthcheck.sh healer.sh /usr/bin/
COPY crontab /tmp/crontab
RUN cat /tmp/crontab >> /etc/crontabs/root

ENTRYPOINT [ "/usr/bin/run.sh" ]
