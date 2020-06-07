import boto3

client = boto3.client('ec2', region_name='us-east-1')

response = client.run_instances(
    ImageId='ami-0affd4508a5d2481b',
    InstanceType='t3.nano',
    MaxCount=1,
    MinCount=1,
)