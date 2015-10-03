#!/bin/bash
set -e

if [ "$1" = 'couchdb' ]; then
  echo "[httpd]\n" > /usr/local/etc/couchdb/local.ini
  echo "bind_address = 0.0.0.0" >> /usr/local/etc/couchdb/local.ini

  set -- "/usr/local/bin/couchdb"
  exec "$@"
fi

exec "$@"
