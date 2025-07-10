# ena-network-monitoring

# ENA Network Metrics Monitoring for AWS EC2

This project helps monitor EC2 ENA (Elastic Network Adapter) metrics and push them to CloudWatch for proactive observability.

## 🔍 What it Does

- Scrapes key ENA metrics using `ethtool`
- Sends them to AWS CloudWatch under a custom namespace
- Enables visibility into network throttling events (e.g., bandwidth or PPS exceedance)

## 📦 Files

- `scripts/push-ena-metrics.sh`: Bash script to collect and send ENA metrics
- `cloudformation/monitoring-ena.yaml`: CloudFormation template to launch an EC2 instance with IAM permissions and crontab scheduling

## 🚀 How to Use

1. **Deploy via CloudFormation**
   - Update the `VpcId` and `KeyName` parameters.
   - Launch the stack in your AWS region (tested on `ap-south-1`).

2. **Script Functionality**
   - Installed on an EC2 instance via `UserData`
   - Runs every minute using `cron`
   - Pushes the following ENA metrics to CloudWatch:
     - `bw_in_allowance_exceeded`
     - `bw_out_allowance_exceeded`
     - `pps_allowance_exceeded`
     - `conntrack_allowance_exceeded`
     - `linklocal_allowance_exceeded`

## 🛡 IAM Permissions

The EC2 instance is granted permissions to send custom metrics via `cloudwatch:PutMetricData`.

## 📈 Example CloudWatch View

Once deployed, go to **CloudWatch > Metrics > Custom Namespaces > EC2/ENA** to see metrics per instance.

## 💬 Credits

Inspired by [Pinterest Engineering Blog](https://medium.com/@Pinterest_Engineering/handling-network-throttling-with-aws-ec2-at-pinterest-fda0efc21083)
