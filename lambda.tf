terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAXY7Q4XPNDA5R7RPG"
  secret_key = "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"
}

resource "aws_lambda_function" "test_lambda" {

  function_name = "testLambda"
  filename      = "lambda_function_payload.zip"

  description      = "First lambda function"
  handler          = "first.lambda_handler"
  runtime          = var.runtime
  source_code_hash = data.archive_file.lambda.output_base64sha256
  role             = "arn:aws:iam::534691757018:role/dynamodbaccesspolicy"

  tags = {
    Name = "learning aws terraform deployment"
  }
  environment {
    variables = var.env_vars
  }
}
resource "aws_lambda_event_source_mapping" "allow_dynamodb_table_to_trigger_lambda" {
  event_source_arn  = aws_dynamodb_table.basic-dynamodb-table.stream_arn
  function_name     = aws_lambda_function.test_lambda.arn
  starting_position = "LATEST"
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "src/first.py"
  output_path = "lambda_function_payload.zip"
}
