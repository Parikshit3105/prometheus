#!/bin/bash

# Set the name of the folder to be created
folder_name="Weekly_backup"

# Set the S3 bucket name
s3_bucket="hp-obs-observability-backup"

# Sync the folder to the S3 bucket using AWS CLI
echo "Backup is starting"

aws s3 sync --exclude "*.tmp-for-creation" --exclude "*.tmp-for-deletion" /var/lib/prometheus/ "s3://$s3_bucket/$folder_name/"
echo "Backup and sync to S3 completed."
