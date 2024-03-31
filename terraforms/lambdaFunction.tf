locals {
  python_files = replace(path.cwd,"terraforms","Lambda_Functions")
}

data "archive_file" "zip_the_student_registration_code" {
  type        = "zip"
  source_dir  = "${local.python_files}/Function-1/"
  output_path = "${local.python_files}/Function-1/student_registration_tf.zip" 
}

data "archive_file" "zip_the_student_authentication_code" {
  type        = "zip"
  source_dir  = "${local.python_files}/Function-2/"
  output_path = "${local.python_files}/Function-2/student_authentication_tf.zip" 
}

resource "aws_lambda_function" "student_registration" {
  filename      = data.archive_file.zip_the_student_registration_code.output_path
  function_name = "student-registration_tf"
  role          = aws_iam_role.role_for_lamda_functions_tf.arn
  handler       = "student_registration_tf.lambda_handler"
  runtime       = "python3.8"
  memory_size   = 500
  timeout       = 50
}

resource "aws_lambda_function" "student_authentication" {
  filename      = data.archive_file.zip_the_student_authentication_code.output_path
  function_name = "student_authentication_tf"
  role          = aws_iam_role.role_for_lamda_functions_tf.arn
  handler       = "student_authentication.lambda_handler"
  runtime       = "python3.8"
  memory_size   = 500
  timeout       = 50
}
