# wordpress

I need to take the alpine and download the necessary dependencies like php and wordpress.

## Steps


## volumes
Docker does not automatically create the host directories specified in the device option of the volume configuration. You need to ensure that these directories exist on the host before starting the containers.

```bash
mkdir -p ~/data/wd-data
mkdir -p ~/data/wd-files
```

## links
https://hub.docker.com/_/wordpress  

https://github.com/docker/awesome-compose/blob/master/official-documentation-samples/wordpress/README.md