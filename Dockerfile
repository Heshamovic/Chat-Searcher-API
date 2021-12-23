FROM ruby:2.6.9

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs && rm -rf /var/lib/apt/lists/

RUN mkdir /app
WORKDIR /app

COPY Gemfile ./
COPY Gemfile.lock ./

RUN bundle install

copy . /app
