#Converting the python file into zip to upload on 

locals {
  python_files = replace(path.cwd,"terraforms","Lambda_Functions")
}

data "archive_file" "zip_the_python_code" {
  type = "zip"
  source_dir = "${local.python_files}" 
  output_path = "${local.python_files}/student_registration.zip" 
}

resource "aws_lambda_function" "student_registration" {
 filename                       = "${local.python_files}/student_registration.zip"
 function_name                  = "student-registration"
 role                           = aws_iam_role.swen614_lambda_role.arn
 handler                        = "student_registration.lambda_handler"
 runtime                        = "python3.8"
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