FROM ruby:2.5.1
RUN apt-get update -qq && apt-get -y install vim &&apt-get install -y build-essential nodejs
RUN mkdir /lifehack
WORKDIR /lifehack
COPY Gemfile /lifehack/Gemfile
COPY Gemfile.lock /lifehack/Gemfile.lock
RUN gem install bundler
RUN bundle update
RUN bundle install
COPY . /lifehack
