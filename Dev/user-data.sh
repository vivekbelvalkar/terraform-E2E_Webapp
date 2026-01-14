#!/bin/bash
yum update -y
yum install -y java-17-amazon-corretto amazon-cloudwatch-agent ruby wget

# Install CodeDeploy agent
cd /home/ec2-user
wget https://aws-codedeploy-${AWS_REGION}.s3.${AWS_REGION}.amazonaws.com/latest/install
chmod +x ./install
./install auto

mkdir -p /opt/app

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