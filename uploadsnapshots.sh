#!/bin/bash

# Set default values for environment variables
: "${HTTP_URL:=https://webcam.connect.prusa3d.com/c/snapshot}"
: "${DELAY_SECONDS:=20}"
: "${LONG_DELAY_SECONDS:=60}"

FINGERPRINT="???"
TOKEN="???"
SNAPSHOTURL="http://127.0.0.1/snapshot"

sleep "5"

while true; do
    now=$(date)

    # grab from streamer
    curl -s "$SNAPSHOTURL" -o /tmp/output.jpg

    # If no error, upload it.
    if [ $? -eq 0 ]; then
        # echo "$now: Uploading snapshot..."

        datestr=$(date)
        convert /tmp/output.jpg -quality 85 -filter lanczos -resize 800 -pointsize 24 -fill white -undercolor '#00000080' -gravity southwest -annotate +10+10 "${datestr}" /tmp/annotated.jpg

        # POST the image to the HTTP URL using curl
        curl -X PUT "$HTTP_URL" \
            -H "accept: */*" \
            -H "content-type: image/jpg" \
            -H "fingerprint: $FINGERPRINT" \
            -H "token: $TOKEN" \
            --data-binary "@/tmp/annotated.jpg" \
            -s \
            --compressed

        # Reset delay to the normal value
        DELAY=$DELAY_SECONDS
    else
        echo "$now: Snapshot returned an error. Retrying after ${LONG_DELAY_SECONDS}s..."

        # Set delay to the longer value
        DELAY=$LONG_DELAY_SECONDS
    fi

    sleep "$DELAY"
done

