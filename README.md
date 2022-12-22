# Docker F-Droid Binary Repo

A Docker container for running a binary F-Droid repo.

This is only useful if you want to publish APK files in an F-Droid repo, not when trying to build from source.

## Configuration
This project needs the following configuration:

### Environment variables
- `FDROID_REPO_URL`: The URL your repo will be available on (must end on /repo)
- `FDROID_REPO_NAME`: A name for your repo
- `FDROID_SCAN_INTERVAL`: How long to wait between each scan for APK files (syntax of the `sleep` command, defaults to `24h`)

### Volume
You will need to bind a Docker volume to /var/www/fdroid

### Port
The repo will be exposed on port 80

### Apps
Just throw APK files in /var/www/fdroid/repo, magic will happen once every `${FDROID_SCAN_INTERVAL}` or when you restart the container.

## Example setup
```
docker run -d \
-e FDROID_REPO_URL=https://myfdroidrepo.example.com/fdroid/repo \
-v your_volume:/var/www/fdroid \
-p 80:80 \
--name my-fdroid-binrepo ghcr.io/thelastproject/docker-f-droid-binary-repo:main
```

## Special thanks
This setup is based on the setup described by Izzy on https://android.izzysoft.de/articles/named/fdroid-simple-binary-repo.
