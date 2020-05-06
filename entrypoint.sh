#!/bin/bash

#v2ray-plugin版本
if [[ -z "${VER}" ]]; then
  VER="latest"
fi
echo ${VER}

if [[ -z "${PASSWORD}" ]]; then
  PASSWORD="5c301bb8-6c77-41a0-a606-4ba11bbab084"
fi
echo ${PASSWORD}

if [[ -z "${ENCRYPT}" ]]; then
  ENCRYPT="aes-128-gcm"
fi


if [[ -z "${V2_Path}" ]]; then
  V2_Path="/shadow"
fi
echo ${V2_Path}



if [ "$VER" = "latest" ]; then
  V_VER=`wget -qO- "https://api.github.com/repos/shadowsocks/v2ray-plugin/releases/latest" | sed -n -r -e 's/.*"tag_name".+?"([vV0-9\.]+?)".*/\1/p'`
  [[ -z "${V_VER}" ]] && V_VER="v1.3.0"
else
  V_VER="v$VER"
fi

mkdir /v2raybin
cd /v2raybin
V2RAY_URL="https://github.com/shadowsocks/v2ray-plugin/releases/download/${V_VER}/v2ray-plugin-linux-amd64-${V_VER}.tar.gz"
echo ${V2RAY_URL}
wget --no-check-certificate ${V2RAY_URL}
tar -zxvf v2ray-plugin-linux-amd64-$V_VER.tar.gz
rm -rf v2ray-plugin-linux-amd64-$V_VER.tar.gz
mv v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin
rm -rf /v2raybin


if [ ! -d /etc/shadowsocks-libev ]; then  
　　mkdir /etc/shadowsocks-libev
fi

sed -e "/^#/d"\
    -e "s/\${PASSWORD}/${PASSWORD}/g"\
    -e "s/\${ENCRYPT}/${ENCRYPT}/g"\
    -e "s|\${V2_Path}|${V2_Path}|g"\
    /conf/libev_conf.json >  /etc/shadowsocks-libev/config.json

echo /etc/shadowsocks-libev/config.json
cat /etc/shadowsocks-libev/config.json

sed -e "/^#/d"\
    -e "s/\${PORT}/${PORT}/g"\
    -e "s|\${V2_Path}|${V2_Path}|g"\
    -e "s|\${QR_Path}|${QR_Path}|g"\
    -e "$s"\
    /conf/nginx_heroku.conf > /etc/nginx/conf.d/nginx_heroku.conf
echo /etc/nginx/conf.d/nginx_heroku.conf
cat /etc/nginx/conf.d/nginx_heroku.conf

ss-server -c /etc/shadowsocks-libev/config.json &
rm -rf /etc/nginx/sites-enabled/default
nginx -g 'daemon off;'
