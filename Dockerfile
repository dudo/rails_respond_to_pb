FROM ruby:3

LABEL maintainer="Brett Dudo <brett@dudo.io>"

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential redis

WORKDIR /usr/src/gem

# Cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG C.UTF-8
ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_JOBS 4
ENV BUNDLE_RETRY 3

RUN gem update --system && \
    gem install bundler
ADD . ./
RUN bundle install

ENTRYPOINT  [ "bundle" ]
CMD [ "version" ]
