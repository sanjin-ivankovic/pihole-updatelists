#!/bin/bash

# Respect PH_VERBOSE environment variable
if [ "${PH_VERBOSE:-0}" -gt 0 ]; then
    set -x
    SCRIPT_ARGS="--verbose --debug"
fi

case $1 in
    "config")
        # Recreate the config file if it doesn't exist
        if [ ! -f "/etc/pihole-updatelists/pihole-updatelists.conf" ]; then
            cp /etc/pihole-updatelists.conf /etc/pihole-updatelists/pihole-updatelists.conf
            echo "  [i] Created /etc/pihole-updatelists/pihole-updatelists.conf"
        fi

        chown pihole:pihole /etc/pihole-updatelists/*
        chmod 644 /etc/pihole-updatelists/*
    ;;
    "cron")
        # Check if the user provided a custom crontab string
        if [ -n "$CRONTAB_STRING" ]; then
            echo "  [i] Changing pihole-updatelists schedule to: $CRONTAB_STRING"
        else # Otherwise, use the default one
            CRONTAB_STRING="$(sed -n '/pihole updateGravity/s/#\(.*\) PATH=.*/\1/p' /crontab.txt)"
        fi

        sed "/pihole-updatelists/ s|^.*PATH=|$CRONTAB_STRING PATH=|" -i /crontab.txt
    ;;
    "run")
        shift # Skip 'run' argument
        # shellcheck disable=SC2086,SC2068
        /usr/bin/php /usr/local/sbin/pihole-updatelists --config=/etc/pihole-updatelists/pihole-updatelists.conf --env $SCRIPT_ARGS $@
    ;;
    *)
        echo "Usage: $0 run [ARGS]"
        exit 1
    ;;
esac
