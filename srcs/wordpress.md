# wordpress

I need to take the alpine and download the necessary dependencies like php and wordpress.

## Steps


## volumes
Docker does not automatically create the host directories specified in the device option of the volume configuration. You need to ensure that these directories exist on the host before starting the containers.

```bash
mkdir -p ~/data/wd-data
mkdir -p ~/data/wd-files
```