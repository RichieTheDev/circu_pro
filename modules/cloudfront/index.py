import json
import datetime
import base64
import rsa
import urllib.parse
from botocore.exceptions import BotoCoreError, NoCredentialsError

# CloudFront Key Pair ID and Private Key Path (Update these values)
CLOUDFRONT_KEY_PAIR_ID = "YOUR_KEY_PAIR_ID"
PRIVATE_KEY_PATH = "/path/to/your/private_key.pem"
CLOUDFRONT_URL = "https://your-distribution.cloudfront.net/your-object"

def generate_signed_url(url, key_pair_id, private_key_path, expiration=3600):
    """
    Generates a signed URL for AWS CloudFront to provide temporary access to a private object.
    
    :param url: CloudFront URL of the object.
    :param key_pair_id: CloudFront key pair ID.
    :param private_key_path: Path to the private key file.
    :param expiration: Expiration time in seconds (default: 1 hour).
    :return: Signed CloudFront URL.
    """
    try:
        # Calculate expiration time (Unix timestamp)
        expire_time = int((datetime.datetime.utcnow() + datetime.timedelta(seconds=expiration)).timestamp())
        
        # Define custom policy
        policy = {
            "Statement": [{
                "Resource": url,
                "Condition": {
                    "DateLessThan": {"AWS:EpochTime": expire_time}
                }
            }]
        }

        # Convert policy to JSON and base64-encode (URL-safe encoding)
        policy_json = json.dumps(policy, separators=(',', ':'))
        policy_b64 = base64.urlsafe_b64encode(policy_json.encode()).decode().rstrip("=")  # Remove padding

        # Load private key
        with open(private_key_path, "rb") as key_file:
            private_key = rsa.PrivateKey.load_pkcs1(key_file.read(), format="PEM")

        # Sign the policy using SHA-1
        signature = rsa.sign(policy_json.encode(), private_key, "SHA-1")

        # Encode the signature in base64 (URL-safe, no padding)
        signature_b64 = base64.urlsafe_b64encode(signature).decode().rstrip("=")

        # Construct signed URL
        signed_url = (
            f"{url}?Expires={expire_time}&Key-Pair-Id={key_pair_id}"
            f"&Signature={urllib.parse.quote(signature_b64)}"
        )

        return signed_url
    except Exception as e:
        print(f"Error generating signed URL: {e}")
        return None

def lambda_handler(event, context):
    """
    AWS Lambda handler to return a CloudFront signed URL.
    """
    try:
        signed_url = generate_signed_url(CLOUDFRONT_URL, CLOUDFRONT_KEY_PAIR_ID, PRIVATE_KEY_PATH)
        if signed_url:
            return {
                "statusCode": 200,
                "body": json.dumps({"signed_url": signed_url})
            }
        else:
            return {
                "statusCode": 500,
                "body": json.dumps({"error": "Failed to generate signed URL"})
            }
    except BotoCoreError as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
    except NoCredentialsError:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": "AWS credentials not found"})
        }
