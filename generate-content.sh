#!/bin/bash

json=$(cat services.json)
services=$(echo "$json" | jq -r '.services[] | @base64')

# Clear all text after "# Service introduction"
sed -i '/# Service introduction/,$d' README.md

# Add the table header
echo "# Service introduction" >>README.md
echo "| Service Name | AWS Docs | Introduction |" >>README.md
echo "|--------------|------------------|------------------------------|" >>README.md

for service in $services; do
  _jq() {
    echo ${service} | base64 --decode | jq -r ${1}
  }
  folder=$(_jq '.service_folder_name')
  url=$(_jq '.service_url')
  youtube_url=$(_jq '.service_youtube_url')
  service_name=$(_jq '.service_name')

  if [ ! -d "$folder" ]; then
    mkdir "$folder"
    echo "Folder created: $folder"
  else
    echo "Folder already exists: $folder"
  fi

  echo "# $service_name" >"$folder/README.md"
  # Update the service README.md content
  echo -e "| $service_name | $url | $youtube_url |" >>README.md
  echo "Check the new content in $folder/README.md"
  cat "$folder/README.md"
done
echo "Check the new content in README.md"
cat README.md
