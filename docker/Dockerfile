FROM ruby:2.6.9-bullseye

ENV LANG=C.UTF-8

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ghostscript \
    libpq-dev \
    poppler-utils \
    postgresql-client \
  && rm -rf /var/lib/apt/lists/*

# Throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy Rubyric source code.
COPY . .
# Rails database configuration and Rubyric settings.
COPY docker/config config/
COPY docker/init_rubyric.sh /init_rubyric.sh

VOLUME /data
EXPOSE 8091

ENTRYPOINT ["/init_rubyric.sh"]
CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "8091"]

