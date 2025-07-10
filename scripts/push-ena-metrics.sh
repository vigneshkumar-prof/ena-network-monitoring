#!/bin/bash
# Set variables
INTERFACE="ens5"
NAMESPACE="EC2/ENA"
REGION="ap-south-1"
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# Metrics to track
METRICS=(
  "bw_in_allowance_exceeded"
  "bw_out_allowance_exceeded"
  "pps_allowance_exceeded"
  "conntrack_allowance_exceeded"
  "linklocal_allowance_exceeded"
)

# Loop through each metric
for METRIC_NAME in "${METRICS[@]}"; do
  VALUE=$(ethtool -S $INTERFACE | grep "$METRIC_NAME" | awk '{print $2}')
  if [ ! -z "$VALUE" ]; then
    aws cloudwatch put-metric-data \
      --metric-name "$METRIC_NAME" \
      --namespace "$NAMESPACE" \
      --value "$VALUE" \
      --dimensions InstanceId="$INSTANCE_ID" \
      --region "$REGION"
    echo "Pushed $METRIC_NAME = $VALUE"
  else
    echo "Metric $METRIC_NAME not found on interface $INTERFACE"
  fi
done
