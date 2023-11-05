#!/bin/bash
set -e
rm -f /home/geo-api/tmp/pids/server.pid

# migrate if the database exists, or reset instead
(bundle exec rake db:migrate:status 2>/dev/null || bundle exec rake db:setup) && bundle exec rake db:migrate
bundle exec rails s -b 0.0.0.0 -p 3000