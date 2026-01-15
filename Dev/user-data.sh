#!/bin/bash
yum update -y
yum install -y java-17-amazon-corretto amazon-cloudwatch-agent ruby wget

# Install CodeDeploy agent
cd /home/ec2-user
wget https://aws-codedeploy-$${AWS_REGION}.s3.$${AWS_REGION}.amazonaws.com/latest/install
chmod +x ./install
./install auto

mkdir -p /opt/app

# Retrieve DB host,port from SSM parameter

DB_HOST=$(aws ssm get-parameter \
  --name "${ENVIRONMENT}-ems-db-host" \
  --query "Parameter.Value" \
  --output text)

DB_PORT=$(aws ssm get-parameter \
  --name "${ENVIRONMENT}-ems-db-port" \
  --query "Parameter.Value" \
  --output text)

# From Secrets Manager

SECRET_JSON=$(aws secretsmanager get-secret-value \
  --secret-id "${ENVIRONMENT}-ems-db-appuser-credentials" \
  --query SecretString \
  --output text)

DB_USERNAME=$(echo "$SECRET_JSON" | jq -r .username)
DB_PASSWORD=$(echo "$SECRET_JSON" | jq -r .password)
DB_NAME=$(echo "$SECRET_JSON" | jq -r .database)
DB_URL="jdbc:mysql://$${DB_HOST}:$${DB_PORT}/$${DB_NAME}"

export DB_URL
export DB_USERNAME
export DB_PASSWORD

cat <<EOF >> /etc/environment
DB_URL=$${DB_URL}
DB_USERNAME=$${DB_USERNAME}
DB_PASSWORD=$${DB_PASSWORD}
EOF


# CloudWatch Agent configuration

cat <<EOF > /opt/aws/amazon-cloudwatch-agent/bin/config.json
${cw_agent_config}
EOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json \
  -s