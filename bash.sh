#!/bin/bash


##################
# This script will report aws resource usage#
##################

#AWS S3
#AWS EC2
#AWS Lambda
#AWS IAM Users

set -x

#list s3 buckets
echo "List s3 buckets"
aws s3 ls

#list EC2 Instances
echo "Ec2 instances"
aws ec2 describe-instances | jq ".Reservations[].Instances[].InstanceId"

#list lambda
echo "Print ls of lamda functions"
aws lambda list-funtions

#list IAM users
echo"list iam users"
aws iam list-users


