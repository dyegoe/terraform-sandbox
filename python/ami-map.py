import boto3
from os import getenv
from sys import argv
from dateutil import parser

def newest_image(list_of_images):
    latest = None
    for image in list_of_images:
        if not latest:
            latest = image
            continue
        if parser.parse(image['CreationDate']) > parser.parse(latest['CreationDate']):
            latest = image
    return latest

filters = [{'Name': 'architecture','Values': ['x86_64']},
           {'Name': 'state','Values': ['available']},
           {'Name': 'root-device-type','Values': ['ebs']},
           {'Name': 'virtualization-type','Values': ['hvm']},
           {'Name': 'image-type','Values': ['machine']}]

img_options = ['amazonlinux', 'ubuntu1404', 'ubuntu1604', 'ubuntu1804']
""" Ubuntu aws cli search
aws ec2 describe-images --filter \
    Name=owner-id,Values=099720109477 \
    Name=architecture,Values=x86_64 \
    Name=state,Values=available \
    Name=root-device-type,Values=ebs \
    Name=virtualization-type,Values=hvm \
    Name=image-type,Values=machine \
    Name=name,Values=ubuntu/images/hvm-ssd/ubuntu* | jq '.Images[] | .Name'  | sort
"""
if len(argv) > 1 and str(argv[1]) in img_options:
    if str(argv[1]) == 'amazonlinux':
        filters.append({'Name': 'owner-id','Values': ['137112412989']})
        filters.append({'Name': 'name','Values': ['amzn-ami-hvm-*-gp2']})
    if str(argv[1]) == 'ubuntu1404':
        filters.append({'Name': 'owner-id','Values': ['099720109477']})
        filters.append({'Name': 'name','Values': ['ubuntu/images/hvm-ssd/ubuntu-trusty-14.04*']})
    if str(argv[1]) == 'ubuntu1604':
        filters.append({'Name': 'owner-id','Values': ['099720109477']})
        filters.append({'Name': 'name','Values': ['ubuntu/images/hvm-ssd/ubuntu-xenial-16.04*']})
    if str(argv[1]) == 'ubuntu1804':
        filters.append({'Name': 'owner-id','Values': ['099720109477']})
        filters.append({'Name': 'name','Values': ['ubuntu/images/hvm-ssd/ubuntu-bionic-18.04*']})
else:
    print("You must use {} [{}]".format(argv[0], ' | '.join(img_options)))
    exit(1)

session = boto3.Session(profile_name=getenv("AWS_PROFILE"))
ec2_regions = session.client("ec2")
response = ec2_regions.describe_regions()
regions = list()

for region in response['Regions']:
    regions.append(region["RegionName"])

print("locals  {")
print("  ami = {")

for region_name in regions:
    ec2_ami = session.client("ec2", region_name=region_name)
    response = ec2_ami.describe_images(Filters=filters)
    source_image = newest_image(response['Images'])
    print("    \"{0}\" = \"{1}\"".format(region_name, source_image['ImageId']))

print("  }")
print("}")
