FROM debian:sid

COPY index.html /wwwroot/index.html
COPY robots.txt /wwwroot/robots.txt
COPY entrypoint.sh /entrypoint.sh

RUN set -ex\
    && apt update -y \
    && apt upgrade -y \
    && apt install -y wget unzip \
    && apt install -y shadowsocks-libev\
    && apt autoremove -y\
    && chmod +x /entrypoint.sh

CMD /entrypoint.sh