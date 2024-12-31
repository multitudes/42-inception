#!/bin/sh 

echo "[vsftpd config] Configuring vsftpd..."

# This creates an empty directory at /var/run/vsftpd/empty. 
# This directory is used by vsftpd as a secure chroot environment. 
# The secure_chroot_dir directive in the vsftpd configuration specifies a 
# directory that vsftpd can change to when it needs to perform operations as 
# an unprivileged user. 
# This helps improve security by isolating the FTP server process.
# mkdir -p /var/run/vsftpd/empty

# cat <<EOF > /etc/vsftpd/vsftpd.conf
# # run in standalone mode (listen for incomming connections on an IP and a port)
# listen=YES
# # require a user to login
# anonymous_enable=NO
# # permits local users in /etc/passwd logins
# local_enable=YES
# # enable file upload
# write_enable=YES
# # file permissions for newly user created files = 777(default) - 022(umask)
# local_umask=022
# # log upploads and downloads
# xferlog_enable=YES
# pasv_enable=YES
# pasv_address=${IP_ADDR}
# pasv_min_port=30000
# pasv_max_port=30009
# local_root=/home/${FTP_USER}
# secure_chroot_dir=/var/run/vsftpd/empty
# EOF


# # Function to get the IP address of the running FTP container
# get_ftp_ip() {
#     docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -qf "name=ftp")
# }

# # Get the IP address of the FTP container
# IP_ADDR=$(get_ftp_ip)

# If the backup file does not exist, create it and configure the FTP server
if [ ! -f "/etc/vsftpd/vsftpd.conf.bak" ]; then

    mkdir -p /var/www/html

    cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak
    mv /tmp/vsftpd.conf /etc/vsftpd/vsftpd.conf

    # Add the FTP_USER, change his password and declare him as the owner of wordpress folder and all subfolders
    adduser -D -h /home/$FTP_USER $FTP_USER
    echo "$FTP_USER:$FTP_PASS" | chpasswd
    chown -R $FTP_USER:$FTP_USER /var/www/html

	#chmod +x /etc/vsftpd/vsftpd.conf
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
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf



