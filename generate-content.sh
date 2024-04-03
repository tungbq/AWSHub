#!/bin/bash

# Read services from JSON file
services=$(jq -r '.services[] | @base64' services.json)

# Clear all text after "# AWS Service Resources"
sed -i '/## AWS Services Learning Resources 📘/,$d' README.md

# Add the table header
echo "## AWS Services Learning Resources 📘" >>README.md
echo "| ID | Service Name | AWS Docs | Youtube Introduction |" >>README.md
echo "|----|--------------|----------|---------------------|" >>README.md

# Initialize ID counter
id=1

# Iterate over each service
for service in $services; do
  # Function to decode base64 and extract value using jq
  _jq() {
    echo ${service} | base64 --decode | jq -r ${1}
  }
  # Extract service details
  service_short_name=$(_jq '.service_short_name')
  url=$(_jq '.service_url')
  youtube_url=$(_jq '.service_youtube_url')
  service_name=$(_jq '.service_name')

  # Remove "https://" from YouTube URL and extract the video ID
  youtube_id=$(echo "$youtube_url" | sed 's~https://youtu.be/~~')

  # Update the service README.md content
  echo "| $id | $service_name | 📖 [$service_short_name]($url) | [youtu.be/$youtube_id](https://youtu.be/$youtube_id) |" >>README.md

  # Increment ID
  ((id++))
done

echo "Check the new content in README.md"
cat README.md
