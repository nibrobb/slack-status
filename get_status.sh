#!/usr/bin/env bash


if [[ -z "${SLACK_TOKEN}" ]]; then
    echo "Missing SLACK_TOKEN environment variable"
    exit 1
fi

header="Authorization: Bearer ${SLACK_TOKEN}"
header2="Content-Type: application/json;charset=utf-8"

api_base="https://slack.com/api"

# Get presence
response_presence=$(curl -s\
    --url "${api_base}/users.getPresence"\
    --header "${header}"\
    --header "${header2}")

# Get custom status
response=$(curl -s\
    --url "${api_base}/users.profile.get"\
    --header "${header}"\
    --header "${header2}")

# Extract status text from the response using 'jq'
presence_text=$(echo "$response_presence" | jq -r '.presence')
status_text=$(echo "$response" | jq -r '.profile.status_text')

timenow=$(date +"%Y-%m-%d %H:%M:%S")

echo "[$timenow] Presence: $presence_text\tCurrent Slack status: $status_text"

