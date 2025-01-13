FROM debian:12.8

ENV IMAGE_VERSION=12.8

LABEL maintainer="Kirill Shtrykov" \
      org.opencontainers.image.version=${IMAGE_VERSION} \
      org.opencontainers.image.title="kirillshtrykov/debian-ansible" \
      org.opencontainers.image.description="Debian Docker container for Ansible roles testing." \
      org.opencontainers.image.url="https://hub.docker.com/r/kirillshtrykov/debian-ansible" \
      org.opencontainers.image.vendor="Kirill Shtrykov" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://github.com/kirill-shtrykov/docker-debian-ansible"

RUN apt update && \
    apt upgrade -y && \
    apt install -y \
      python3 \
      sudo \
      bash \
      net-tools \
      ca-certificates \
      systemd \
      procps && \
    apt clean

RUN if [ ! -e /sbin/init ]; then ln -s /lib/systemd/systemd /sbin/init ; fi

# Don't start the optional systemd services.
RUN find /etc/systemd/system \
         /lib/systemd/system \
         -path '*.wants/*' \
         -not -name '*journald*' \
         -not -name '*systemd-tmpfiles*' \
         -not -name '*systemd-user-sessions*' \
         -exec rm \{} \;

RUN systemctl set-default multi-user.target

VOLUME [ "/sys/fs/cgroup" ]

ENTRYPOINT ["/sbin/init"]
