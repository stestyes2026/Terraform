resource "aws_iam_role" "lambdarole" {
  name = "lamda_role"
  assume_role_policy = jsonencode({
    version = "2012-10-17"
    statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        principal = {
            service = "lambda.amazon.com"
        }
    }
    ]
  }
  )
}

resource "aws_iam_policy_attachment" "name" {
  name = "lambda_log_attach"
  roles = [aws_iam_role.lambdarole]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

output "role" {
  value = aws_iam_role.lambdarole.arn
}