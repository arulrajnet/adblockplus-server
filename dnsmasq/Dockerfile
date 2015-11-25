FROM alpine:3.2

MAINTAINER Arulraj Venni <me@arulraj.net>

RUN apk add --update dnsmasq \
  && rm -rf /var/cache/apk/*

COPY dnsmasq.conf /etc/
COPY resolv.dnsmasq.conf /etc/

VOLUME /dnsmasq.hosts

WORKDIR /etc

EXPOSE 5353

ENTRYPOINT ["/usr/sbin/dnsmasq", "-d"]
