
#Creating an IAM role for Lambda Use case
resource "aws_iam_role" "swen614_lambda_role" {
name               = "lambda_execution_role"
assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "swen614_cloudwatch_policy" {
  name        = "cloudwatch_policy"
  description = "Allows logging to CloudWatch Logs"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "swen614_s3_policy" {
  name        = "s3_policy"
  description = "Allows access to S3 buckets"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "swen614_dynamodb_policy" {
  name        = "dynamodb_policy"
  description = "Allows access to DynamoDB tables"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "swen614_rekognition_policy" {
  name        = "rekognition_policy"
  description = "Allows access to Rekognition service"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "rekognition:DetectLabels"
      ],
      "Resource": "*"
    }
  ]
} 
EOF
}

resource "aws_iam_role_policy_attachment" "swen614_cloudwatch_attach" {
  role       = aws_iam_role.swen614_lambda_role.name
  policy_arn = aws_iam_policy.swen614_cloudwatch_policy.arn
}

resource "aws_iam_role_policy_attachment" "s3_attach" {
  role       = aws_iam_role.swen614_lambda_role.name
  policy_arn = aws_iam_policy.swen614_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "dynamodb_attach" {
  role       = aws_iam_role.swen614_lambda_role.name
  policy_arn = aws_iam_policy.swen614_dynamodb_policy.arn
}

resource "aws_iam_role_policy_attachment" "rekognition_attach" {
  role       = aws_iam_role.swen614_lambda_role.name
  policy_arn = aws_iam_policy.swen614_rekognition_policy.arn
}


# #Attaching AWS lambda full access to the IAM role
# resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
#   role        = aws_iam_role.swen614-lambda-role.name
#   policy_arn  = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
# }