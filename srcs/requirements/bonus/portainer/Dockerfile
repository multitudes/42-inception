FROM alpine:3.20

RUN apk update && apk upgrade && \
    apk add bash bind-tools ca-certificates curl jq tar && \
    rm -rf /var/cache/apk

COPY ./tools/setup.sh /tmp/setup.sh

RUN chmod +x /tmp/setup.sh

ENTRYPOINT [ "/tmp/setup.sh", "--no-kubernetes" ]