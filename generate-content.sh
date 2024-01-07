#!/bin/bash

json=$(cat services.json)
services=$(echo "$json" | jq -r '.services[] | @base64')

echo "Clean up the previous content under 'Service introduction'"
sed -i '/# Service introduction/,$ {/# Service introduction/!d}' README.md

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

  echo "# $service_name" > "$folder/README.md"
  # Update the service README.md content
  echo -e "- Official AWS URL: $url" >> "$folder/README.md"
  echo -e "- Official YouTube Introduction: $youtube_url" >> "$folder/README.md"
  echo "Check the new content in $folder/README.md"
  cat "$folder/README.md"

  # Update the README.md content
  echo -e "- [$folder/README.md](./$folder/README.md)" >> README.md
done
echo "Check the new content in README.md"
cat README.md
