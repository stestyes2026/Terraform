provider "aws"{
   region = "ap-south-1"
   access_key = var.access_key
   secret_key = var.secret
   }

module "lambda" {
  source = "./Modules/lambda"
}

resource "aws_lambda_function" "lambda" {
  function_name = "test"
  role = module.lambda.role
  memory_size = 1024
  timeout = 60
  filename = "script.zip"
  source_code_hash = filebase64sha256("script.zip")
  handler = "lambda_function.handler"
  runtime = "python3.12"
}

resource "aws_cloudwatch_event_rule" "rule" {
  name = "every-1-day"
  schedule_expression = "cron(30 12 * * ? * )"
  state = "DISABLED"

}

resource "aws_cloudwatch_event_target" "target" {
  rule = aws_cloudwatch_event_rule.rule.name
  target_id = "Run_lambda"
  arn = aws_lambda_function.lambda.arn
}

resource "aws_lambda_permission" "permission" {
  statement_id = "AllowExecutionFromEventBridge"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.rule.arn
}

output "lambda" {
  value = "Lambda ARN ${aws_lambda_function.lambda.arn}"
}