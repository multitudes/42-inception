FROM alpine:3.20

RUN apk update && apk upgrade

RUN apk add --no-cache vsftpd

# exec the configuration script
COPY tools/conf.sh /tmp/conf.sh
RUN chmod +x /tmp/conf.sh 
RUN /tmp/conf.sh

ENTRYPOINT  [ "vsftpd", "/etc/vsftpd/vsftpd.conf" ]