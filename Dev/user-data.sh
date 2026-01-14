#!/bin/bash
yum update -y
yum install -y java-17-amazon-corretto amazon-cloudwatch-agent

mkdir -p /opt/app
aws s3 cp s3://${ARTIFACT_BUCKET}/app.jar /opt/app/app.jar

nohup java -Xms64m -Xmx128m -jar /opt/app/app.jar > /opt/app/app.log 2>&1 &

# -------------------------------
# CloudWatch Agent configuration
# -------------------------------

cat <<EOF > /opt/aws/amazon-cloudwatch-agent/bin/config.json
${cw_agent_config}
EOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json \
  -s