FROM debian:sid



RUN set -ex\
    && apt update -y \
    && apt upgrade -y \
    && apt install -y wget unzip \
    && apt install -y shadowsocks-libev\
    && apt install -y nginx\
    && apt autoremove -y

COPY index.html /wwwroot/index.html
COPY robots.txt /wwwroot/robots.txt
COPY entrypoint.sh /entrypoint.sh
COPY conf/ /conf

RUN chmod +x /entrypoint.sh
CMD /entrypoint.sh
