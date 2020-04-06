#!/bin/bash
set -e

# allow arguments to be passed to squid
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == squid || ${1} == "/usr/sbin/squid" ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch squid
if [[ -z ${1} ]]; then

  if [[ ! -d /var/spool/squid/00 ]]; then
    echo "Initializing cache..."
    /usr/sbin/squid -N -f /etc/squid/squid.conf -z
  fi

  if [[ ! -f /var/run/container-squid ]]; then
    sed -i s'/^http_access.*/http_access allow all/'g /etc/squid/squid.conf
    cat <<EOF >> /etc/squid/squid.conf
cache_dir ufs /var/spool/squid 100 16 256
acl step1 at_step SslBump1
ssl_bump peek step1
ssl_bump bump all
EOF
    touch /var/run/container-squid
  fi

  echo "Starting squid..."
  exec /usr/sbin/squid -f /etc/squid/squid.conf -NYCd 1 ${EXTRA_ARGS}
else
  exec "$@"
fi
