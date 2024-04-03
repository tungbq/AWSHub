#!/bin/bash

json=$(cat services.json)
services=$(echo "$json" | jq -r '.services[] | @base64')

# Clear all text after "# Service introduction"
sed -i '/# Service introduction/,$d' README.md

# Add the table header
echo "# Service introduction" >>README.md
echo "| Service Name | AWS Docs | Youtube Introduction |" >>README.md
echo "|--------------|------------------|------------------------------|" >>README.md

for service in $services; do
  _jq() {
    echo ${service} | base64 --decode | jq -r ${1}
  }
  service_short_name=$(_jq '.service_short_name')
  url=$(_jq '.service_url')
  youtube_url=$(_jq '.service_youtube_url')
  service_name=$(_jq '.service_name')

  # Update the service README.md content
  echo -e "| $service_name | [$service_short_name]($url) | $youtube_url |" >>README.md
done
echo "Check the new content in README.md"
cat README.md
