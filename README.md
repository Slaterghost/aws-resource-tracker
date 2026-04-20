<<<<<<< HEAD
# AWS Resource Tracker

Shell script to monitor AWS resources using AWS CLI.

## Features
- S3 buckets
- EC2 instances
- Lambda functions
- IAM users

## Run
=======
# AWS Resource Tracker 🚀

An automated AWS monitoring system built using Bash and AWS CLI that tracks cloud resources, generates reports, uploads them to S3, and sends alerts via SNS.

---

## 🔧 Tech Stack
- Bash (Shell Scripting)
- AWS CLI
- Amazon S3
- Amazon SNS
- Cron (Automation)

---

## 📊 Features
- Tracks AWS resources (S3, EC2, Lambda, IAM)
- Filters running EC2 instances
- Generates timestamped reports
- Uploads reports to Amazon S3
- Sends email alerts using SNS
- Supports scheduled execution via cron

---

## ▶️ How to Run

```bash
chmod +x aws_resource_tracker.sh
>>>>>>> ccb4686 (Upgraded script with SNS alerts, S3 upload and improved README)
./aws_resource_tracker.sh
