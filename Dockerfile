FROM fluent/fluentd:v1.8.1-1.0
MAINTAINER Aaron Brewbaker <cryptogrampus@gmail.com>

USER root

RUN apk update \
 && apk add --no-cache curl jq \
 && apk add --no-cache --update --virtual .build-deps \
        sudo build-base ruby-dev \
 # cutomize following instruction as you wish
 && sudo gem install fluent-plugin-prometheus \
 && sudo gem install fluent-plugin-jq \
 && sudo gem install fluent-plugin-kubernetes_metadata_filter \
 && sudo gem sources --clear-all \
 && apk del .build-deps \
 && rm -rf /home/fluent/.gem/ruby/2.5.0/cache/*.gem

# Copy configuration files
COPY ./conf/fluent.conf /fluentd/etc/
COPY ./conf/systemd.conf /fluentd/etc/
COPY ./conf/kubernetes.conf /fluentd/etc/
COPY ./conf/prometheus.conf /fluentd/etc/
RUN touch /fluentd/etc/disable.conf

COPY entrypoint.sh /bin/

USER fluent

