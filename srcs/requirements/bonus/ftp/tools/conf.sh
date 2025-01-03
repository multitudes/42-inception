#!/bin/sh 

echo "[vsftpd config] Configuring vsftpd..."

# here a trick to perform the ftp server configuration only once
# If the backup file does not exist, create it and configure the FTP server
if [ ! -f "/etc/vsftpd/vsftpd.conf.bak" ]; then

    mkdir -p /var/www/html

	# I make a backup of the default and replace it with my own configuration
	# taken from the docker container files
    cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak
    mv /tmp/vsftpd.conf /etc/vsftpd/vsftpd.conf

    # Add the FTP_USER, change his password and give permission
    adduser -D -h /home/$FTP_USER $FTP_USER
    echo "$FTP_USER:$FTP_PASS" | chpasswd
    chown -R $FTP_USER:$FTP_USER /var/www/html

    echo $FTP_USER | tee -a /etc/vsftpd.userlist &> /dev/null

    # Debugging: Print the contents of vsftpd.userlist
    cat /etc/vsftpd.userlist
	echo "[vsftpd config] vsftpd configuration complete."
fi

# Replace placeholder with actual IP address in vsftpd.conf
sed -i "s/\${IP_ADDR}/$IP_ADDR/g" /etc/vsftpd/vsftpd.conf

# debug
echo "FTP_USER=${FTP_USER}"
echo "FTP_PASS=${FTP_PASS}"
echo "FTP ip=${IP_ADDR}"

echo "FTP started on :21"
exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf



