#!/usr/bin/env python3

import boto3
from os import getenv, path
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

filters_default = [
    {'Name': 'architecture','Values': ['x86_64']},
    {'Name': 'state','Values': ['available']},
    {'Name': 'root-device-type','Values': ['ebs']},
    {'Name': 'virtualization-type','Values': ['hvm']},
    {'Name': 'image-type','Values': ['machine']}
]

"""
aws ec2 describe-images --filter \
    Name=architecture,Values=x86_64 \
    Name=state,Values=available \
    Name=root-device-type,Values=ebs \
    Name=virtualization-type,Values=hvm \
    Name=image-type,Values=machine \
    Name=owner-id,Values=137112412989 \
    Name=name,Values='amzn-ami-hvm-*-gp2' | jq '.Images[] | .Name .ImageId'  | sort
"""
"""
aws ec2 describe-images --filter \
    Name=architecture,Values=x86_64 \
    Name=state,Values=available \
    Name=root-device-type,Values=ebs \
    Name=virtualization-type,Values=hvm \
    Name=image-type,Values=machine \
    Name=owner-id,Values=591542846629 \
    Name=name,Values='amzn-ami-*.h-amazon-ecs-optimized' | jq '.Images[] | .Name .ImageId'  | sort
"""
"""
aws ec2 describe-images --filter \
    Name=architecture,Values=x86_64 \
    Name=state,Values=available \
    Name=root-device-type,Values=ebs \
    Name=virtualization-type,Values=hvm \
    Name=image-type,Values=machine \
    Name=owner-id,Values=099720109477 \
    Name=name,Values='ubuntu/images/hvm-ssd/ubuntu-trusty-14.04*' | jq '.Images[] | .Name .ImageId'  | sort
"""
"""
aws ec2 describe-images --filter \
    Name=architecture,Values=x86_64 \
    Name=state,Values=available \
    Name=root-device-type,Values=ebs \
    Name=virtualization-type,Values=hvm \
    Name=image-type,Values=machine \
    Name=owner-id,Values=099720109477 \
    Name=name,Values='ubuntu/images/hvm-ssd/ubuntu-xenial-16.04*' | jq '.Images[] | .Name .ImageId'  | sort
"""
"""
aws ec2 describe-images --filter \
    Name=architecture,Values=x86_64 \
    Name=state,Values=available \
    Name=root-device-type,Values=ebs \
    Name=virtualization-type,Values=hvm \
    Name=image-type,Values=machine \
    Name=owner-id,Values=099720109477 \
    Name=name,Values='ubuntu/images/hvm-ssd/ubuntu-bionic-18.04*' | jq '.Images[] | .Name .ImageId'  | sort
"""
filters_dists = {
    'amazonlinux' : [
        {'Name': 'owner-id','Values': ['137112412989']},
        {'Name': 'name','Values': ['amzn-ami-hvm-*-gp2']}
    ],
    'amazonlinuxecs' : [
        {'Name': 'owner-id','Values': ['591542846629']},
        {'Name': 'name','Values': ['amzn-ami-*.h-amazon-ecs-optimized']}
    ],
    'ubuntu1404' : [
        {'Name': 'owner-id','Values': ['099720109477']},
        {'Name': 'name','Values': ['ubuntu/images/hvm-ssd/ubuntu-trusty-14.04*']}
    ],
    'ubuntu1604' : [
        {'Name': 'owner-id','Values': ['099720109477']},
        {'Name': 'name','Values': ['ubuntu/images/hvm-ssd/ubuntu-xenial-16.04*']}
    ],
    'ubuntu1804' : [
        {'Name': 'owner-id','Values': ['099720109477']},
        {'Name': 'name','Values': ['ubuntu/images/hvm-ssd/ubuntu-bionic-18.04*']}
    ],
}

session = boto3.Session(profile_name=getenv("AWS_PROFILE", "default"))
ec2_regions = session.client("ec2")
response = ec2_regions.describe_regions()
regions = list()

for region in response['Regions']:
    regions.append(region["RegionName"])

lines_to_file = []
line = "locals  {"
print(line)
lines_to_file.append('{}\n'.format(line))
for img in filters_dists:
    line = "  {ami} = {{".format(ami=img)
    print(line)
    lines_to_file.append('{}\n'.format(line))
    for region_name in regions:
        ec2_ami = session.client("ec2", region_name=region_name)
        response = ec2_ami.describe_images(Filters=filters_default + filters_dists[img])
        if len(response['Images']) > 0:
            source_image = newest_image(response['Images'])
            line = "    \"{0}\" = \"{1}\"".format(region_name, source_image['ImageId'])
            print(line)
            lines_to_file.append('{}\n'.format(line))
        else:
            continue
    line = "  }"
    print(line)
    lines_to_file.append('{}\n'.format(line))
line = "}"
print(line)
lines_to_file.append('{}\n'.format(line))
with open('{}/locals.tf'.format(path.dirname(path.realpath(__file__))), 'w') as f:
    f.writelines(lines_to_file)
