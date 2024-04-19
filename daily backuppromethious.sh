#!/bin/bash

# Set the name of the folder to be created
folder_name="Daily_backup"

# Set the S3 bucket name
observability_bucket="hp-obs-observability-backup"

elasticsearch_bucket="hp-obs-elasticsearch-backup"

# Sync the folder to the S3 bucket using AWS CLI
echo "Backup is starting"

aws s3 sync --exclude "*.tmp-for-creation" --exclude "*.tmp-for-deletion" /var/lib/prometheus/ "s3://$observability_bucket/$folder_name/"

echo "observability daily backup completed"

aws s3 sync /var/lib/elasticsearch "s3://$elasticsearch_bucket/$folder_name/"

echo "elasticsearch daily backup completed"