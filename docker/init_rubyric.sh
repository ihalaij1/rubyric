#!/bin/sh

# Export LTI key for A+.
mkdir -p /data/aplus/lti-services-in/
echo '{"key": "rubyric", "secret": "rubyric", "label": "Rubyric", "url": "http://'$(hostname -i)':8091/session/lti", "icon": "save-file"}' \
> /data/aplus/lti-services-in/rubyric.json


# Wait for the database to start.
sleep 7

# Run Rubyric database migrations.
./bin/rails db:migrate

# Create an admin user.
./bin/rails runner "
User.where(email: 'admin@rubyric').first_or_create do |user|
  user.admin = '1'
  user.password = 'admin'
  user.firstname = 'Andy'
  user.lastname = 'Admin'
end"

# Start background tasks.
./bin/delayed_job start

exec "$@"
