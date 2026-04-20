#!/bin/bash

# ===== CONFIG =====
BUCKET_NAME="aws-resource-tracker-dhruv-2026"
TOPIC_ARN="arn:aws:sns:us-east-1:473469900971:aws-resource-alerts"

# ===== REPORT FILE =====
FILENAME="report_$(date +%F_%H-%M-%S).txt"

# ===== GENERATE REPORT =====
echo "===== AWS RESOURCE REPORT =====" > $FILENAME
echo "Generated on: $(date '+%Y-%m-%d %H:%M:%S')" >> $FILENAME
echo "" >> $FILENAME

# -------- S3 --------
echo "S3 Buckets:" >> $FILENAME
aws s3 ls >> $FILENAME
echo "" >> $FILENAME

# -------- EC2 --------
echo "Running EC2 Instances:" >> $FILENAME
instances=$(aws ec2 describe-instances \
--query 'Reservations[].Instances[?State.Name==`running`].InstanceId' \
--output text)

if [ -z "$instances" ]; then
  echo "No running EC2 instances" >> $FILENAME
else
  echo "$instances" >> $FILENAME
fi
echo "" >> $FILENAME

# -------- Lambda --------
echo "Lambda Functions:" >> $FILENAME
aws lambda list-functions --query 'Functions[].FunctionName' --output text >> $FILENAME
echo "" >> $FILENAME

# -------- IAM --------
echo "IAM Users:" >> $FILENAME
aws iam list-users --query 'Users[].UserName' --output text >> $FILENAME
echo "" >> $FILENAME

echo "===== END OF REPORT =====" >> $FILENAME

# ===== UPLOAD TO S3 =====
aws s3 cp $FILENAME s3://$BUCKET_NAME/

# ===== SEND ALERT (SNS) =====
aws sns publish \
--topic-arn $TOPIC_ARN \
--subject "AWS Resource Report" \
--message file://$FILENAME
