FROM alpine:latest
LABEL maintainer="Bernd Klaus"

ENV DNSDISTCONF_BACKEND_IP="8.8.8.8"

COPY dnsdist.conf /etc/dnsdist.conf
COPY entrypoint.sh /usr/local/bin/

RUN apk --update --no-cache add \
        dnsdist \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/* \
    && rm -rf /var/log/* \
    && chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 53/tcp 53/udp 5199/tcp 8083/tcp

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "/usr/bin/dnsdist", "--supervised", "--disable-syslog"]
