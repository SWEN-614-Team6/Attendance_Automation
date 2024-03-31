#Converting the python file into zip to upload on 

locals {
  python_files = replace(path.cwd,"terraforms","Lambda_Functions")
}

data "archive_file" "zip_the_python_code" {
  type = "zip"
  source_dir = "${local.python_files}/Function-1/"
  output_path = "${local.python_files}/Function-1/student_registration_tf.zip" 
}

resource "aws_lambda_function" "terraform_lambda_func" {
 filename                       = "${local.python_files}/Function-1/student_registration_tf.zip"
 function_name                  = "student-registration_tf"
 role                           = aws_iam_role.role_for_lamda_functions_tf.arn
 handler                        = "student_registration_tf.lambda_handler"
 runtime                        = "python3.8"
 memory_size = 500
 timeout = 50
 //depends_on                     = [aws_iam_role_policy_attachment.dynamodb_attach, aws_iam_role_policy_attachment.rekognition_attach, aws_iam_role_policy_attachment.s3_attach]

# filename         = "${local.python_files}/student_authentication.zip"  # Path to the ZIP file containing Python code
#   function_name    = "student-authentication"
#   handler          = "student_authentication.lambda_handler"
#   runtime          = "python3.8"
#   source_code_hash = filebase64sha256(data.archive_file.zip_the_python_code[each.key].output_path)
#   role             = aws_iam_role.swen614-lambda-role.arn
#   depends_on       = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]


#  environment {
#     variables = {
#       DYNAMODB_TABLE_NAME = "studentsdemo2"
#       BUCKET_NAME         = "swen614-dataset"
#       REKOGNITION_REGION = "us-east-1"
#       COLLECTION_ID      = "mycollection2"
#       # Add other environment variables here if needed
#     }
#   }
}

resource "aws_lambda_permission" "s3_invoke_permission" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terraform_lambda_func.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.new-student-registration-tf.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.new-student-registration-tf.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.terraform_lambda_func.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = ""
    filter_suffix       = ""
  }
}