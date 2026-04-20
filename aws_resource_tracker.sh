#!/bin/bash

# ===== CONFIG =====
BUCKET_NAME="aws-resource-tracker-dhruv-2026"
TOPIC_ARN="arn:aws:sns:us-east-1:473469900971:aws-resource-alerts"

STATE_FILE="last_state.txt"
CURRENT_STATE="current_state.txt"

FILENAME="report_$(date +%F_%H-%M-%S).txt"

# ===== GET CURRENT STATE =====
aws ec2 describe-instances \
--query 'Reservations[].Instances[?State.Name==`running`].InstanceId' \
--output text > $CURRENT_STATE

# ===== COMPARE WITH PREVIOUS =====
if [ -f "$STATE_FILE" ]; then
    diff $STATE_FILE $CURRENT_STATE > /dev/null
    STATUS=$?
else
    STATUS=1
fi

# ===== GENERATE REPORT =====
{
echo "===== AWS RESOURCE REPORT ====="
echo "Generated on: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

echo "Running EC2 Instances:"
cat $CURRENT_STATE
echo ""

echo "===== END OF REPORT ====="
} > "$FILENAME"

# ===== UPLOAD TO S3 =====
aws s3 cp "$FILENAME" "s3://$BUCKET_NAME/"

# ===== ALERT ONLY IF CHANGE DETECTED =====
if [ $STATUS -ne 0 ]; then
    echo "Change detected! Sending alert..."

    aws sns publish \
    --topic-arn "$TOPIC_ARN" \
    --subject "AWS Alert: EC2 State Changed" \
    --message file://"$FILENAME"

    # Update state
    cp $CURRENT_STATE $STATE_FILE
else
    echo "No change detected. No alert sent."
fi
