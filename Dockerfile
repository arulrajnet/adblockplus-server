FROM debian:wheezy

MAINTAINER Arulraj Venni <me@arulraj.net>

# Install privoxy 
RUN apt-get update -qq \
	&& apt-get install -y privoxy supervisor wget \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/{apt,dpkg,cache,log}/* /tmp/* /var/tmp/* \
	&& mkdir -p /opt/supervisor/conf.d /opt/privoxy

# Add custom supervisor config
COPY ./supervisord/supervisord.conf /opt/supervisor/supervisord.conf
COPY ./supervisord/privoxy-supervisor.conf /opt/supervisor/conf.d/privoxy-supervisor.conf
COPY ./supervisord/adblock2privoxy-supervisor.conf /opt/supervisor/conf.d/adblock2privoxy-supervisor.conf

# Add custom privoxy config
COPY ./privoxy/config /opt/privoxy/config
COPY ./privoxy/privoxy-blocklist_0.2.sh /opt/privoxy/privoxy-blocklist_0.2.sh
RUN chmod +x /opt/privoxy/privoxy-blocklist_0.2.sh

# Ports
EXPOSE 8118

CMD ["supervisord", "-c", "/opt/supervisor/supervisord.conf"]
