FROM alpine:latest
LABEL maintainer="Bernd Klaus"

ENV DNSDISTCONF_BACKEND_IP = "PDNS-IPv6" \
    DNSDISTCONF_RECURSOR_IP = "9.9.9.9" \
    DNSDIST_ENABLE_RECURSOR = "false" \
    DNSDISTCONF_MAIN_DOMAIN = "example.com"

COPY dnsdist.conf /etc/dnsdist.conf
COPY entrypoint.sh /usr/local/bin/

RUN apk --update --no-cache add \
        dnsdist \
        curl \
        jq \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/* \ 
    && rm -rf /var/log/* \
    && chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 53/tcp 53/udp 5199/tcp 8083/tcp

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "/usr/bin/dnsdist", "--supervised", "--disable-syslog"]
