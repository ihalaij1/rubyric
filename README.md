# Rubyric

Rubyric is an online tool in which you can create courses and assignments, 
receive submissions and assess them by using rubrics. More information about 
Rubyric and how to use it can be found [here](doc/rubyric.md).

## Install environment
Install ruby version 2.3.1 or higher, for example with rvm or rbenv. Then
install rails:
```sh
gem install rails -v 5.0.2
```
or
```sh
sudo gem install rails -v 5.0.2
```
Rubyric uses postgresql as database. Install postgresql and create user.
```sh
sudo apt-get install postgresql
sudo -u postgres createuser --interactive
```
Rubyric requires pdfinfo, ghostscript and libpq-dev to work
```sh
sudo apt-get install poppler-utils ghostscript libpq-dev
```

## Install Rubyric

### Install gems
```sh
bundle install
```

### Configure
```sh
cp config/initializers/secret_token.rb.base config/initializers/secret_token.rb
cp config/initializers/settings.rb.base config/initializers/settings.rb
cp config/database.yml.base config/database.yml
```

### Create database, and put password and username to config/database.yml
```sh
sudo -u postgres createdb -O my_username rubyric
```

### Initialize database
```sh
rails db:setup
```

### Start server
```sh
bin/delayed_job start
rails server
```

You can now access Rubyric at http://localhost:3000.

### Make user Rubyric admin
Open rails console
```sh
rails c
```
Find user and update admin attribute. You can find user by their user id with
User.find(id) or by some other attributes with User.find_by(attribute: value).
```sh
User.find(id).update_attributes(admin: '1')
```
or you can create a new user as admin
```sh
User.create(email: email, password: password, admin: '1')
```
