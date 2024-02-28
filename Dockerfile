FROM timbru31/ruby-node:2.7

COPY ./auth /auth

WORKDIR /auth

RUN rm Gemfile.lock && bundle install
