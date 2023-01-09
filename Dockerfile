FROM alpine:latest
LABEL maintainer="Bernd Klaus"

ENV DNSDISTCONF_BACKEND_IP = "8.8.8.8" \
    DNSDISTCONF_RECURSOR_IP = "9.9.9.9" \
    DNSDISTCONF_MAIN_DOMAIN = "example.com"

COPY dnsdist.conf /etc/dnsdist.conf
COPY entrypoint.sh /usr/local/bin/

RUN apk --update --no-cache add \
        dnsdist \
        curl \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/* \ 
    && rm -rf /var/log/* \
    && chmod +x /usr/local/bin/entrypoint.sh \
    && touch /etc/authdomains.txt

EXPOSE 53/tcp 53/udp 5199/tcp 8083/tcp

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "/usr/bin/dnsdist", "--supervised", "--disable-syslog"]
