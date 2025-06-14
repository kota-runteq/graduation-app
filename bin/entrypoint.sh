#!/bin/bash
set -e

rm -f /graduation-app/tmp/pids/server.pid
bundle exec rails db:prepare

exec "$@"
