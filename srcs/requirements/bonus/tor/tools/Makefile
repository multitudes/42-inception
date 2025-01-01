ps:
	docker ps


run:
	docker build -t my-nginx-ssh-tor .
	docker run -d --name tor my-nginx-ssh-tor

stop:
	docker stop tor && docker rm tor

logs:
	docker logs tor

hostname:
	$(eval ONION_ADDRESS=$(shell docker exec tor cat /var/lib/tor/hidden_service/hostname))
	@echo $(ONION_ADDRESS) > onion_address.txt
	@echo .onion address: $(ONION_ADDRESS)

connect:
	$(eval ONION_ADDRESS=$(shell docker exec tor cat /var/lib/tor/hidden_service/hostname))
	ssh -o ProxyCommand='nc -x localhost:9150 %h %p' -p 4242 root@$(ONION_ADDRESS)
# also use the -i and path to private key if needed

debug:
	docker exec -it tor ps aux | grep tor
	docker exec -it tor service tor status
	docker exec -it tor service ssh status
	docker exec -it tor cat /root/.ssh/authorized_keys
	ss -lp | grep 9050

.PHONY: ps build run stop logs hostname