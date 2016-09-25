FROM ruby:2.3.0

# the essentials
RUN apt-get update -qq && apt-get install -y build-essential
# for postgres
RUN apt-get install -y libpq-dev
# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev
# for capybara-webkit
RUN apt-get install -y libqt4-webkit libqt4-dev xvfb
# for a JS runtime
RUN apt-get install -y nodejs

RUN mkdir /inspector-gadget
WORKDIR /inspector-gadget
ADD Gemfile /inspector-gadget/Gemfile
ADD Gemfile.lock /inspector-gadget/Gemfile.lock
RUN bundle install
ADD . /inspector-gadget 