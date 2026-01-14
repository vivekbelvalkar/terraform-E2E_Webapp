#!/bin/bash
yum update -y
yum install -y java-17-amazon-corretto amazon-cloudwatch-agent

mkdir -p /opt/app
aws s3 cp s3://${ARTIFACT_BUCKET}/app.jar /opt/app/app.jar

nohup java -Xms64m -Xmx128m -jar /opt/app/app.jar > /opt/app/app.log 2>&1 &

# -------------------------------
# Fetch DB credentials
# -------------------------------
SECRET_JSON=$(aws secretsmanager get-secret-value \
  --secret-id ems_db_appuser_creds \
  --query SecretString \
  --output text)

DB_NAME=$(echo $SECRET_JSON | jq -r .database)
DB_USERNAME=$(echo $SECRET_JSON | jq -r .app_user)
DB_PASSWORD=$(echo $SECRET_JSON | jq -r .app_password)

export DB_URL="jdbc:mysql://${DB_HOST}:${DB_PORT}/${DB_NAME}"
export DB_USERNAME
export DB_PASSWORD

# Persist env vars for Spring Boot
cat <<EOF >> /etc/environment
DB_URL=${DB_URL}
DB_USERNAME=${DB_USERNAME}
DB_PASSWORD=${DB_PASSWORD}
EOF

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