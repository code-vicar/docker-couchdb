#!/bin/bash
set -e

if [ "$1" = 'couchdb' ]; then
  echo "Configuring couchdb"
  echo "[httpd]" > /usr/local/etc/couchdb/local.ini
  echo "bind_address = 0.0.0.0" >> /usr/local/etc/couchdb/local.ini

  echo "Starting couchdb"
  exec gosu couchdb "$@"
fi

echo "Passthrough command"
exec "$@"
