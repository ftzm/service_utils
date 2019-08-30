#!/usr/bin/env bash

set -u
set -e

user=$1
email=$2
token=$3
repo=$4
path=$5
raw_content=$(cat)
content=$(base64 -w 0 <<< $raw_content)

sha=$(curl \
  -s \
  -u $user:$token \
  -X GET \
  -H "Content-Type: application/json" \
  https://api.github.com/repos/$user/$repo/contents/$path \
  | jq -r ."sha")

payload="{\"message\":\"update ${path}\", \"committer\": {\"name\": \"${user}\", \"email\": \"${email}\"}, \"sha\": \"${sha}\", \"content\": \"${content}\"}"

echo $payload

curl \
  -u $user:$token \
  -v \
  -X PUT \
  -H "Content-Type: application/json" \
  -d "${payload}" \
  https://api.github.com/repos/$user/$repo/contents/$path
