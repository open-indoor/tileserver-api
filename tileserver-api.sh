#!/bin/bash

set -x
set -e

API_URL=${API_URL:-"https://${API_DOMAIN_NAME}"}

echo "API_DOMAIN_NAME=${API_DOMAIN_NAME}" >  /tileserver/tileserver.src
echo "API_URL=${API_URL}"                 >> /tileserver/tileserver.src

chmod +x /tileserver/tileserver
chmod +x /usr/bin/actions.sh
chmod +x /usr/bin/tic

crontab -l | { cat; echo "* * * * * /usr/bin/tic"; } | crontab -
echo "Start cron task" && crontab -l && /usr/sbin/cron -l 8
cat /usr/bin/actions.sh

cat /tmp/Caddyfile | envsubst | tee /etc/caddy/Caddyfile

# (caddy run --watch --config /etc/caddy/Caddyfile & fcgiwrap -f -s unix:/var/run/fcgiwrap.socket)
nohup /usr/src/app/run.sh --public_url "${API_URL}/tileserver/" --verbose -c /tileserver/config.json &

(caddy run --watch --config /etc/caddy/Caddyfile & fcgiwrap -f -s unix:/var/run/fcgiwrap.socket)
