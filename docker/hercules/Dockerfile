# Image minimale : émulateur S/390 Hercules + utilitaires (telnet / less).
# La configuration et les volumes DASD (ex. TK4-) restent sous stack/hercules/.
FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        hercules \
        telnet \
        netcat-openbsd \
        less \
        vim \
        nano \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /config

CMD ["bash", "-lc", "echo 'Hercules installé. Exemple : hercules -f /config/hercules.cnf'; exec bash"]
