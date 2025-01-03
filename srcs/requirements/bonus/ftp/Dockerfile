FROM alpine:3.20

RUN apk update && apk upgrade && \ 
	apk add --no-cache vsftpd && \
	rm -rf /var/cache/apk

# I copy my configuration file to the container
COPY ./tools/vsftpd.conf /tmp/vsftpd.conf

# copy and exec the configuration script
COPY ./tools/conf.sh /tmp/conf.sh
RUN chmod +x /tmp/conf.sh 

# start the ftp server on port 21
ENTRYPOINT  [ "/tmp/conf.sh" ]