#!/bin/bash

# Read services from JSON file and sort them by service name
services=$(jq -r '.services | sort_by(.service_name) | .[] | @base64' services.json)

# Clear all text after "# AWS Service Resources"
sed -i '/## AWS Services Learning Resources 📘/,$d' README.md

# Add the table header
echo "## AWS Services Learning Resources 📘" >>README.md
echo "Below you will find links to detailed documentation and introductory videos for some popular AWS services" >>README.md
echo "| ID | Service Name | AWS Docs | Youtube Introduction | FAQ |" >>README.md
echo "|----|--------------|----------|---------------------|-----|" >>README.md

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
  faq_url=$(_jq '.faq_url')

  # Remove "https://" from YouTube URL and extract the video ID
  youtube_id=$(echo "$youtube_url" | sed 's~https://youtu.be/~~')

  # Update the service README.md content
  echo "| $id | $service_name | 📖 [$service_short_name]($url) | ▶️ [youtu.be/$youtube_id](https://youtu.be/$youtube_id) | ❔ [$service_short_name/faqs]($faq_url)|" >>README.md

  # Increment ID
  ((id++))
done

echo "" >>README.md
echo "And **more upcoming services content...⏩** you can star/follow this repository to get more up-to-dated content ⭐" >>README.md

echo "Check the new content in README.md"
cat README.md
