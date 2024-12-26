FROM alpine:3.20

RUN apt update && apt upgrade -y

# Install necessary packages- these are compatible with my version of alpine
RUN apk add --no-cache \
    php82-fpm \
    php82-mysqli \
	bash \
	wget \
	tar 

COPY install.sh  /
COPY wp-conf.php /

CMD [/install.sh]