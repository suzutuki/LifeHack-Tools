FROM ruby:2.5.7
RUN apt-get update -qq && apt-get install -y build-essential nodejs
RUN mkdir /lifehack
WORKDIR /lifehack
COPY Gemfile /lifehack/Gemfile
COPY Gemfile.lock /lifehack/Gemfile.lock
RUN gem install bundler
RUN bundle update
RUN bundle install
COPY . /lifehack
