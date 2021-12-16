#!/bin/sh

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
