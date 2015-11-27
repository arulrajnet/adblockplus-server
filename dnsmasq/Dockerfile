FROM alpine:3.2

MAINTAINER Arulraj Venni <me@arulraj.net>

RUN apk add -U dnsmasq \
  && rm -rf /var/cache/apk/*

COPY dnsmasq.conf /etc/
COPY resolv.dnsmasq.conf /etc/

VOLUME /dnsmasq.hosts

WORKDIR /etc

EXPOSE 53 53/udp

ENTRYPOINT ["/usr/sbin/dnsmasq", "-d"]
