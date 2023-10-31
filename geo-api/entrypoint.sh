#!/bin/bash
set -e
rm -f /home/geo-api/tmp/pids/server.pid

bundle exec rake db:reset || bundle exec rake db:migrate 2>/dev/null
bundle exec rails s -b 0.0.0.0 -p 3000