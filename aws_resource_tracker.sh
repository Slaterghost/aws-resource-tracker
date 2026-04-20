#!/bin/bash

# ===== CONFIG =====
BUCKET_NAME="aws-resource-tracker-dhruv-2026"
TOPIC_ARN="arn:aws:sns:us-east-1:473469900971:aws-resource-alerts"

# ===== REPORT FILE =====
FILENAME="report_$(date +%F_%H-%M-%S).txt"

# ===== GENERATE REPORT =====
{
echo "===== AWS RESOURCE REPORT ====="
echo "Generated on: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

echo "S3 Buckets:"
aws s3 ls
echo ""

echo "Running EC2 Instances:"
aws ec2 describe-instances \
--query 'Reservations[].Instances[?State.Name==`running`].InstanceId' \
--output text
echo ""

echo "Lambda Functions:"
aws lambda list-functions --query 'Functions[].FunctionName' --output text
echo ""

echo "IAM Users:"
aws iam list-users --query 'Users[].UserName' --output text
echo ""

echo "===== END OF REPORT ====="
} > "$FILENAME"

# ===== UPLOAD TO S3 =====
aws s3 cp "$FILENAME" "s3://$BUCKET_NAME/"

# ===== SEND ALERT (SNS) =====
aws sns publish \
--topic-arn "$TOPIC_ARN" \
--subject "AWS Resource Report" \
--message file://"$FILENAME"

echo "Report generated: $FILENAME"
