# Docker

## volumes
Docker does not automatically create the host directories specified in the device option of the volume configuration. You need to ensure that these directories exist on the host before starting the containers.

```bash
mkdir -p ~/data/wd-data
mkdir -p ~/data/wp-files
```
