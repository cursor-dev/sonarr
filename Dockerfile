FROM cursor/mbase
MAINTAINER Ryan Pederson <ryan@pederson.ca>

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC \
  && echo "deb http://apt.sonarr.tv/ develop main" | tee -a /etc/apt/sources.list \
  && apt-get update -q \
  && apt-get install -qy nzbdrone mediainfo \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN chown -R media:users /opt/NzbDrone \
  ; mkdir -p /volumes/config /volumes/downloads /volumes/media \

EXPOSE 8989
EXPOSE 9898
VOLUME /volumes/config
VOLUME /volumes/downloads
VOLUME /volumes/media

ADD start.sh /
RUN chmod +x /start.sh

ADD sonarr-update.sh /sonarr-update.sh
RUN chmod 755 /sonarr-update.sh \
  && chown media:users /sonarr-update.sh

USER media
WORKDIR /opt/NzbDrone

ENTRYPOINT ["/start.sh"]
