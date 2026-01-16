resource "aws_lambda_function" "db_bootstrap" {
  function_name = "${var.env}-db-bootstrap"
  role          = var.lambda_role_arn
  handler       = "DbBootstrapHandler::handleRequest"
  runtime       = "java17"
  timeout       = 60
  memory_size  = 512

  filename = "../../lambda-db-bootstrap/target/db-bootstrap-lambda.jar"

  vpc_config {
    subnet_ids         = var.vpc_subnet_ids
    security_group_ids = var.security_group_ids
  }

  environment {
    variables = {
      DB_MASTER_SECRET_ARN = var.db_master_secret_arn
      DB_HOST = var.db_host
      DB_PORT = var.db_port
      DB_NAME       = var.db_name
      APP_DB_USER   = var.app_db_user
      APP_DB_PASS   = var.app_db_password
      SQL_KEY       = var.sql_data_s3_key
      SQL_BUCKET = var.bucket_name
    }
  }
}