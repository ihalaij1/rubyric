# Rubyric
Rubyric is an online tool which is used in teaching to make giving written 
feedback on assignments easier and faster using predefined rubrics.
Rubyric allows teachers to create courses, course instances and assignments.
Teachers can create assessment rubrics to assignments to be used as a base to
review students' submissions. Rubrics contain predefined criteria, feedback
phrases and their corresponding grades and points. The reviewer can choose
phrases and add their own comments in between them to create consistent but
personalized feedback for students.

This version of Rubyric has parts that have been developed according to wishes
of some courses in Aalto University and other parts have been developed to 
connect Rubyric to other teaching services, mainly A+. However, Rubyric can be 
used as a standalone service.

This documentation aims to explain how Rubyric works from point of view of
developer as well as end user.

## Contents

1. [Installation](#1-installation)
   * [Install environment](#install-environment)
   * [Install Rubyric](#install-rubyric)
   * [Connect local Rubyric to A+ course in docker](#connect-local-rubyric-to-a-course-in-docker-optional) (optional for testing)
2. [Technical documentation](technical_documentation.md)
3. [User Guide](user_guide.md)

# Installation

## Install environment
Install ruby version 2.3.1 or higher , for example with rvm or rbenv. Then
install rails:

```sh
gem install rails -v 5.0.2
```
or
```sh
sudo gem install rails -v 5.0.2
```

Rubyric requires pdfinfo, ghostscript and libpq-dev to work

```sh
sudo apt-get install poppler-utils ghostscript libpq-dev
```

Rubyric uses postgresql as database. Install postgresql and create user.

```sh
sudo apt-get install postgresql
sudo -u postgres createuser --interactive
```

## Install Rubyric
Install gems
```sh
bundle install
```

Copy configuration files
```sh
cp config/initializers/secret_token.rb.base config/initializers/secret_token.rb
cp config/initializers/settings.rb.base config/initializers/settings.rb
cp config/database.yml.base config/database.yml
```

Create database, and put password and username to config/database.yml
```sh
sudo -u postgres createdb -O my_username rubyric
```

Initialize database
```sh
rails db:setup
```

Start server
```sh
bin/delayed_job start
rails server
```
Now you can access Rubyric at http://localhost:3000/.

## Connect local Rubyric to A+ course in docker (optional)

> NOTE: Unless you are developer and you need help in testing Rubyric with A+, 
> you can just ignore this section.

This section is optional and is only used if you want to test how Rubyric
works with your A+ course in development environment, e.g. when you are
implementing some new function to Rubyric. To test your local Rubyric version
with A+ course, you need to start A+ course at localhost. To do this follow 
instructions at https://apluslms.github.io/guides/quick/.

In order to get A+ and Rubyrci to communicate with each other we need to do 
some configuring to both services. At the time of writing this guide A+ needs 
ports 8000, 8080 and 3000. Thus we cannot use the default port 3000 with 
Rubyric. Choose some other port for Rubyric, e.g. 3030. You also 
need to find out your docker ip address, which can be for example something like 
172.17.0.1 or 172.18.0.1 as A+ should contact that address in order to reach
Rubyric. You also need to find out from which address A+ tries to contact 
Rubyric. 

To add Rubyric as a LTI service to A+ you need to

  1. Go to http://localhost:8000/admin and login as `root`:`root`
  2. Choose `Lti services` and `Add Lti service`
  3. Set settings as
     * Url: http://[docker ip]:[port]/session/lti
     * Destination region: hosted in the same organization
     * Access settings: allow API access
     * Consumer key: test
     * Consumer secret: secret
    
Key-secret pair test:secret are part of default configuration of Rubyric. You
can change these in `config/initializers/settings.rb`. In production version
you **should** change these into something safer.

In Rubyric add A+ (docker) ip address into APLUS_IP_WHITELIST at file
`config/initializers/settings.rb`
so that Rubyric will accept submissions from A+.

Start Rubyric server

```sh
rails server -p [port] -b [docker ip]
```

With this your local Rubyric should allow your A+ course to connect to it.

| [Next part ->](technical_documentation.md)
