FROM ruby:2.3.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /skills
WORKDIR /skills
ADD Gemfile /skills/Gemfile
ADD Gemfile.lock /skills/Gemfile.lock
RUN bundle install
ADD . /skills