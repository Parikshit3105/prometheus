import boto3 
import json
from datetime import datetime, timedelta, timezone

s3 = boto3.resource('s3')

def lambda_handler(event, context):
    source_bucket_name = 'centralized-logging'
    destination_bucket_name = 'elg-security-monitoring'  # Update this if needed
    destination_folder = 'GuardDuty/'
    
    # Define the time window for considering new files (2 minutes)
    time_window = timedelta(minutes=2)
    current_time = datetime.now(timezone.utc)

    source_bucket = s3.Bucket(source_bucket_name)

    for obj in source_bucket.objects.filter(Prefix='AWSLogs/'):
        # Check if the object is a file (not a folder)
        if not obj.key.endswith('/'):
            # Get the last modified timestamp of the object
            last_modified = obj.last_modified

            # Calculate the time difference between the current time and the last modified timestamp
            time_difference = current_time - last_modified

            # Check if the file is within the specified time window
            if time_difference <= time_window:
                source_key = obj.key
                destination_key = destination_folder + source_key.split('/')[-1]

                try:
                    print(f'Copying file {source_key} to {destination_key}')
                    copy_source = {'Bucket': source_bucket_name, 'Key': source_key}
                    s3.Object(destination_bucket_name, destination_key).copy_from(CopySource=copy_source)
                    print(f'Successfully copied {source_key} to {destination_key}')
                except Exception as e:
                    print(f'Error copying file {source_key} to {destination_key}: {e}')

    return {
        'statusCode': 200,
        'body': json.dumps('Newly created files copied successfully!')
    }
