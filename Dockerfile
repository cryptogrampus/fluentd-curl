FROM fluent/fluentd:v1.9.1-1.0
MAINTAINER Aaron Brewbaker <cryptogrampus@gmail.com>

USER root

RUN apk update \
 && apk add --no-cache curl jq \
 && apk add --no-cache --update --virtual .build-deps \
        sudo build-base ruby-dev \
 && sudo gem install fluent-plugin-prometheus \
 && sudo gem install fluent-plugin-jq \
 && sudo gem install fluent-plugin-rewrite-tag-filter \
 && sudo gem sources --clear-all \
 && apk del .build-deps \
 && rm -rf /home/fluent/.gem/ruby/2.5.0/cache/*.gem

# Copy configuration files
COPY ./conf/fluent.conf /fluentd/etc/
RUN touch /fluentd/etc/disable.conf

COPY entrypoint.sh /bin/

USER fluent

