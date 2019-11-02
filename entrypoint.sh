#! /bin/bash

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
  V_VER=`wget -qO- "https://api.github.com/repos/shadowsocks/v2ray-plugin/releases/latest" | grep 'tag_name' | cut -d\" -f4`
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


C_VER=`wget -qO- "https://api.github.com/repos/mholt/caddy/releases/latest" | grep 'tag_name' | cut -d\" -f4`
mkdir /caddybin
cd /caddybin
CADDY_URL="https://github.com/mholt/caddy/releases/download/$C_VER/caddy_${C_VER}_linux_amd64.tar.gz"
echo ${CADDY_URL}
wget --no-check-certificate -qO 'caddy.tar.gz' ${CADDY_URL}
tar xvf caddy.tar.gz
rm -rf caddy.tar.gz
chmod +x caddy


if [ ! -d /etc/shadowsocks-libev ]; then  
　　mkdir /etc/shadowsocks-libev
fi
cat <<-EOF > /etc/shadowsocks-libev/config.json
{
    "server":"127.0.0.1",
    "server_port":"10000",
    "password":"${PASSWORD}",
    "timeout":300,
    "method":"${ENCRYPT}",
    "mode": "tcp_and_udp",
    "fast_open":false,
    "reuse_port":true,
    "no_delay":true,
    "plugin": "/usr/bin/v2ray-plugin",
    "plugin_opts":"server;path=${V2_Path}"
}
EOF

echo /etc/shadowsocks-libev/config.json
cat /etc/shadowsocks-libev/config.json

cat <<-EOF > /caddybin/Caddyfile
http://0.0.0.0:${PORT}
{
	root /wwwroot
	index index.html
	timeouts none
	proxy ${V2_Path} localhost:10000 {
		websocket
		header_upstream -Origin
    transparent
	}
}
EOF


ss-server -c /etc/shadowsocks-libev/config.json &
cd /caddybin
./caddy -conf="/caddybin/Caddyfile"