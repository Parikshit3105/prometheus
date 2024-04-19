#!/bin/bash

# Set your local folder and S3 paths
LOCAL_PATH="/var/lib/prometheus/"
S3_BUCKET="s3://tsdb-data-sync.sh"

# Create a folder with the current date
CURRENT_DATE=$(date "+%Y-%m-%d")
ZIP_FILE="$LOCAL_PATH/$CURRENT_DATE.zip"

# Navigate to the parent directory of the folder to be zipped
cd $(dirname $LOCAL_PATH)

# Zip the data
zip -r $ZIP_FILE $(basename $LOCAL_PATH)

# Sync zipped data from local to S3
aws s3 cp $ZIP_FILE $S3_BUCKET/

# Clean up: Remove the local zip file
rm $ZIP_FILE