# syntax=docker/dockerfile:1
FROM ruby:2.7.0

RUN curl https://deb.nodesource.com/setup_12.x | bash \
  && curl -s -L https://raw.githubusercontent.com/yarnpkg/releases/gh-pages/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y build-essential nodejs postgresql-client yarn \
  && rm -rf /var/lib/apt/lists/*

RUN bundle config --global frozen 1

RUN mkdir /oauth
WORKDIR /oauth
ADD . /oauth

ADD Gemfile /oauth/Gemfile
ADD Gemfile.lock /oauth/Gemfile.lock
RUN bundle install
RUN bundle install

ADD package.json /oauth/package.json
ADD yarn.lock /oauth/yarn.lock
RUN yarn install

EXPOSE 3000

ENTRYPOINT [ "bundle", "exec" ]
