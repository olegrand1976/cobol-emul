FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=fr_FR.UTF-8 \
    LANGUAGE=fr_FR:fr \
    LC_ALL=fr_FR.UTF-8 \
    COB_SCREEN_ESC=Y \
    COB_SCREEN_EXCEPTIONS=Y

RUN apt-get update && apt-get install -y --no-install-recommends \
        gnucobol \
        libcob4-dev \
        gdb \
        make \
        build-essential \
        vim \
        nano \
        less \
        file \
        locales \
        ca-certificates \
    && sed -i 's/^# *\(fr_FR.UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["bash"]
