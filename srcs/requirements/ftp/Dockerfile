FROM alpine:3.20

RUN apk update && apk upgrade

RUN apk add --no-cache vsftpd

# exec the configuration script
COPY tools/conf.sh /tmp/conf.sh
COPY tools/vsftpd.conf /tmp/vsftpd.conf
RUN chmod +x /tmp/conf.sh 

ENTRYPOINT  [ "/tmp/conf.sh" ]