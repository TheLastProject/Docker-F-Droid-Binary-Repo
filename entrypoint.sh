#!/bin/sh

if [ ! -d "/var/www/fdroid" ]; then
    echo "[FATAL] Could not find /var/www/fdroid, did you create a Docker volume for it?"
    exit 1
fi

cd /var/www/fdroid || exit
/app/fdroidserver/fdroid init
/app/fdroidserver/fdroid update --create-key
jarsigner -verify -verbose repo/index-v1.jar
keytool -keystore keystore.p12 -list -v

if [ -z "${FDROID_REPO_URL}" ]; then
    echo "[FATAL] FDROID_REPO_URL environment variable is not defined. Exiting..."
    exit 1
fi

if [ -z "${FDROID_REPO_NAME}" ]; then
    echo "[FATAL] FDROID_REPO_NAME environment variable is not defined. Exiting..."
    exit 1
fi

sed -i 's;.*repo_url:.*;repo_url: '"${FDROID_REPO_URL}"';g' /var/www/fdroid/config.yml || exit 1
sed -i 's;.*repo_name:.*;repo_name: '"${FDROID_REPO_NAME}"';g' /var/www/fdroid/config.yml || exit 1

nginx

/app/fdroidserver/fdroid update -c --rename-apks --use-date-from-apk || exit

echo
echo "================================================================"
echo "To add apps, throw .apk files in /var/www/fdroid/repo."
echo "This directory is scanned once per hour or on container restart."
echo "================================================================"
echo

while true; do
    sleep 60m
    echo "Generating skeleton metadata for all new APKs"
    /app/fdroidserver/fdroid update -c --rename-apks --use-date-from-apk || exit
    echo "Done, next scan for new APKs in 60 minutes"
done
