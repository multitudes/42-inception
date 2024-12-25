# add certificates

To add certificates to your Debian virtual machine, follow these steps:

I need a configuration file for NGINX to use the certificates. Here 
```nginx
# filepath: nginx-tls/nginx.conf
events {}

http {
    server {
        listen 443 ssl;

        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_certificate /etc/nginx/ssl/nginx.crt;
        ssl_certificate_key /etc/nginx/ssl/nginx.key;

        location / {
            root /usr/share/nginx/html;
            index index.html;
        }
    }
}
```

```bash
mkdir -p nginx/ssl    
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx/ssl/nginx.key -out nginx/ssl/nginx.crt -subj "/CN=localhost" 
```

## Firefox warning
if i see this from firefox, when running the container inside my virtual machine does it mean that the certificate is not recognized or it is normal when self signed?

Warning: Potential Security Risk Ahead

Firefox detected a potential security threat and did not continue to localhost. If you visit this site, attackers could try to steal information like your passwords, emails, or credit card details.

When using a self-signed certificate, it is normal to see a warning like "Potential Security Risk Ahead" in Firefox or any other browser. This warning occurs because the browser cannot verify the authenticity of the self-signed certificate, as it is not issued by a trusted Certificate Authority (CA).

To proceed, you can add an exception in Firefox to trust the self-signed certificate:

1. **Click on "Advanced"**: On the warning page, click on the "Advanced" button.

2. **Add Exception**: Click on "Accept the Risk and Continue" to add an exception for the self-signed certificate and proceed to the site.

This will allow you to access your NGINX server using the self-signed certificate. However, keep in mind that this is only suitable for development and testing purposes. For production environments, you should use a certificate issued by a trusted CA.