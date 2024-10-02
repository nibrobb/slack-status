#!/usr/bin/env bash


if [[ -z "${SLACK_TOKEN}" ]]; then
    echo "Missing SLACK_TOKEN environment variable"
    exit 1
fi

header="Authorization: Bearer ${SLACK_TOKEN}"
header2="Content-Type: application/json;charset=utf-8"

api_base="https://slack.com/api"

# Set presence
presence_request=$(curl -X POST -s\
    --url "${api_base}/users.setPresence"\
    --header "${header}"\
    --header "${header2}"\
    --data '{"presence": "away"}')

# Set custom status
status_request=$(curl -X POST -s\
    --url "${api_base}/users.profile.set"\
    --header "${header}"\
    --header "${header2}"\
    --data '{"profile": {"status_text": "Custom Status", "status_emoji": ":grin:", "status_expiration": 0}}')

# Format responses and filter for only `ok` field
presence_response=$(echo "${presence_request}" | jq -r '.ok')
status_response=$(echo "${status_request}" | jq -r '.ok')


if [[ "$presence_response" != "true" ]]; then
    echo "Something went wrong\n${presence_request}"
fi

if [[ "$status_response" != "true" ]]; then
    echo "Something went wrong\n${status_request}"
fi
