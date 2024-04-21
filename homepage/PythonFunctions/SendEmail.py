import boto3
from botocore.exceptions import ClientError

def send_email(Receiver, body_html, body_text, subject):
    client = boto3.client('ses', region='us-east-1')

    try:
        response = client.send_email(
            Destination={
                'ToAddresses': [
                    Receiver,
                ],
            },
            Message={
                'Body': {
                    'Html': {
                        'Data': body_html,
                        'Charset': 'UTF-8'
                    },
                    'Text': {
                        'Data': body_text,
                        'Charset': 'UTF-8'
                    },
                },
                'Subject': {
                    'Data': subject,
                    'Charset': 'UTF-8'
                },
            }
        )
    except ClientError as e:
        print(e.response['Error']['Message'])
    else:
        print("Email sent! Message ID:", end=" ")
        print(response['MessageId'])