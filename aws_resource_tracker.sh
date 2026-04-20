#!/bin/bash
#
###############
#Author: Dhruv
#Date: 19-April
#
#Version: v1
#
#This script will report the AWS resource usage
############
#
set -x

#AWS S3
#AWS EC2
#AWS LAMBDA
#AWS IAM USERS
#
#list s3 buckets
echo "print list of s3 buckets"
aws s3 ls > resourceTracker

#list ec2 instances
echo "print list of ec2"
aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId'


#list aws lambda
echo "print list of lambda"
aws lambda list-functions >> resourceTracker:q!


#list iam users
echo "print list of iam users"
aws iam list-users
