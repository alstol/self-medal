#!/bin/sh

ls

if [ -n "$GITHUB_EVENT_PATH" ];
then
    EVENT_PATH=$GITHUB_EVENT_PATH

elif [ -f ./sample_event.json ];
then
    EVENT_PATH='./sample_event.json'
else
    echo "No JSON data to process. :("
    exit 1
fi

MERGER=$(jq .pull_request.merged_by.login < $EVENT_PATH)
CREATOR=$(jq .pull_request.user.login < $EVENT_PATH)

echo "PR MADE BY: $CREATOR"
echo "PR MERGED BY: $MERGER"

if [ $MERGER = $CREATOR ]; then
    echo "YOU MERGED YOUR OWN PR! SHAME! 👮🏻‍";
    set -eu
    sh -c "npm install"
    sh -c "node index.js $*"
else
    echo "$MERGER is a good man. Moving on..."
fi

