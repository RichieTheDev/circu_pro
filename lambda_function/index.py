import json
import boto3
import os
import zipfile
import io

# Initialize AWS S3 client
s3 = boto3.client("s3")

# Get environment variables
SOURCE_BUCKET = os.environ.get("SOURCE_BUCKET")
CONSOLIDATED_BUCKET = os.environ.get("CONSOLIDATED_BUCKET")


def lambda_handler(event, context):
    try:
        print("Received event:", json.dumps(event, indent=2))

        for record in event["Records"]:
            s3_object_key = record["s3"]["object"]["key"]
            print(f"Processing file: {s3_object_key}")

            # Process the file: zip and move
            zip_and_move_file(s3_object_key)

        return {"status": "Success", "message": "Files processed successfully"}

    except Exception as e:
        print(f"Error processing file: {str(e)}")
        return {"status": "Error", "message": str(e)}


def zip_and_move_file(s3_object_key):
    """Downloads, zips, uploads to consolidated bucket, and deletes original file."""
    try:
        # Download file into memory
        file_stream = io.BytesIO()
        s3.download_fileobj(SOURCE_BUCKET, s3_object_key, file_stream)
        file_stream.seek(0)

        # Create ZIP in memory
        zip_buffer = io.BytesIO()
        with zipfile.ZipFile(zip_buffer, "w", zipfile.ZIP_DEFLATED) as zip_file:
            zip_file.writestr(os.path.basename(s3_object_key), file_stream.getvalue())

        zip_buffer.seek(0)

        # Upload the ZIP file to Consolidated Bucket
        zip_file_name = f"{s3_object_key}.zip"
        s3.put_object(Bucket=CONSOLIDATED_BUCKET, Key=zip_file_name, Body=zip_buffer)

        print(f"Zipped and uploaded: {zip_file_name} to {CONSOLIDATED_BUCKET}")

        # Delete original file from Source Bucket after successful upload
        s3.delete_object(Bucket=SOURCE_BUCKET, Key=s3_object_key)
        print(f"Deleted original file: {s3_object_key} from {SOURCE_BUCKET}")

    except Exception as e:
        print(f"Error processing file {s3_object_key}: {str(e)}")
        raise
