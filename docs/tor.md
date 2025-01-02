# tor

once started the tor service, you can use the tor browser to access the onion address of the service.
```bash
> docker exec inception-tor-1 cat /var/lib/tor/hidden_service/hostname
5r7ulpn3v4p2ozc6hfck3blq5kojjjqqjpivzaswrocghleawl2pnvid.onion


## troubleshooting
i cannot use bridge mode because i am in a school network. so using nat i can use the browser and also internet including the tor browser i can connect. but when i start my tor service in the container it doesnt work.

this is my  torrc conf file

# Hidden service for the web server

HiddenServiceDir /var/lib/tor/hidden_service/

HiddenServicePort 80 127.0.0.1:80


# Hidden service for SSH

HiddenServicePort 4242 127.0.0.1:4242


and when i run the container i use nginx

http {

    server {

        listen 80;

        server_name localhost;


        location / {

            root /usr/share/nginx/html;

            index index.html;

        }

    }

}

and i run it like 
```bash
docker build -t my-nginx-ssh-tor .

docker run -d --name tor my-nginx-ssh-t

$(eval ONION_ADDRESS=$(shell docker exec tor cat /var/lib/tor/hidden_service/hostname))

ssh -o ProxyCommand='nc -x localhost:9150 %h %p' -p 4242 root@$(ONION_ADDRESS)

```