import json
import boto3
import os
import zipfile
import io

# Initialize the S3 client
s3 = boto3.client("s3")

# Retrieve environment variables for S3 bucket names
SOURCE_BUCKET = os.environ.get("SOURCE_BUCKET")
CONSOLIDATED_BUCKET = os.environ.get("CONSOLIDATED_BUCKET")

def lambda_handler(event, context):
    """
    AWS Lambda handler function.
    
    This function processes S3 events triggered when a new file is uploaded.
    It reads the event details, processes each file, and returns a status message.
    """
    try:
        print("Received event:", json.dumps(event, indent=2))
        
        # Iterate over each record in the event
        for record in event["Records"]:
            s3_object_key = record["s3"]["object"]["key"]  # Extract file key from event
            print(f"Processing file: {s3_object_key}")
            
            # Process the file (zip and move)
            zip_and_move_file(s3_object_key)

        return {"status": "Success", "message": "Files processed successfully"}
    
    except Exception as e:
        print(f"Lambda failed with error: {str(e)}")
        return {"status": "Error", "message": str(e)}

def zip_and_move_file(s3_object_key):
    """
    Downloads a file from the source S3 bucket, compresses it into a ZIP archive,
    uploads it to the consolidated bucket, and deletes the original file.
    """
    try:
        # Create an in-memory stream for the file download
        file_stream = io.BytesIO()
        s3.download_fileobj(SOURCE_BUCKET, s3_object_key, file_stream)
        file_stream.seek(0)  # Reset stream position

        # Create an in-memory ZIP buffer
        zip_buffer = io.BytesIO()
        with zipfile.ZipFile(zip_buffer, "w", zipfile.ZIP_DEFLATED) as zip_file:
            # Add the file to the ZIP archive
            zip_file.writestr(os.path.basename(s3_object_key), file_stream.getvalue())

        zip_buffer.seek(0)  # Reset ZIP buffer position
        zip_file_name = f"{s3_object_key}.zip"  # Define the new ZIP file name

        # Upload the ZIP file to the consolidated bucket
        s3.put_object(Bucket=CONSOLIDATED_BUCKET, Key=zip_file_name, Body=zip_buffer)
        print(f"Zipped and uploaded: {zip_file_name} to {CONSOLIDATED_BUCKET}")

        # Delete the original file from the source bucket
        s3.delete_object(Bucket=SOURCE_BUCKET, Key=s3_object_key)
        print(f"Deleted original file: {s3_object_key} from {SOURCE_BUCKET}")

    except Exception as e:
        print(f"Error processing file {s3_object_key}: {str(e)}")
        raise
