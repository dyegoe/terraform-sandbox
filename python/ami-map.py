import boto3
from os import getenv

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


session = boto3.Session(profile_name=getenv("AWS_PROFILE"))
ec2_regions = session.client("ec2")
response = ec2_regions.describe_regions()
regions = list()

for region in response['Regions']:
    regions.append(region["RegionName"])

filters = [{
        'Name': 'name',
        'Values': ['amzn-ami-minimal-hvm-*']
    }, {
        'Name': 'description',
        'Values': ['Amazon Linux AMI*']
    }, {
        'Name': 'architecture',
        'Values': ['x86_64']
    }, {
        'Name': 'owner-alias',
        'Values': ['amazon']
    }, {
        'Name': 'owner-id',
        'Values': ['137112412989']
    }, {
        'Name': 'state',
        'Values': ['available']
    }, {
        'Name': 'root-device-type',
        'Values': ['ebs']
    }, {
        'Name': 'virtualization-type',
        'Values': ['hvm']
    }, {
        'Name': 'hypervisor',
        'Values': ['xen']
    }, {
        'Name': 'image-type',
        'Values': ['machine']
    }]

print("variable \"amis\" {")
print("  type = \"map\"")
print("  default = {")

for region_name in regions:
    ec2_ami = session.client("ec2", region_name=region_name)
    response = ec2_ami.describe_images(Owners=['amazon'], Filters=filters)
    source_image = newest_image(response['Images'])
    print("    \"{0}\" = \"{1}\"".format(region_name, source_image['ImageId']))

print("  }")
print("}")
