
provider "aws" {
  region = "us-east-1"
}


  locals {
  relative_path_to_external_directory = "dataset"
#   dataset_path = "${path.root}/${local.relative_path_to_external_directory}"
  dataset_path = replace(path.cwd,"terraforms","dataset")
}



#Creating s3 bucket to upload the student image in a s3 bucket.
resource "aws_s3_bucket" "new-student-registration-tf" {
  bucket = "new-student-registration-tf"
  force_destroy = true

  tags = {
    Name        = "new-student-registration-tf"
    Environment = "Dev"
  }
}

#Creating bucket for student attendace authentication
resource "aws_s3_bucket" "class-images-tf" {
  bucket = "class-images-tf"
   force_destroy = true

  tags = {
    Name        = "class-images-tf"
    Environment = "Dev"
  }
}

data "local_file" "ses_email" {
  filename = replace(path.cwd,"terraforms","SES_EMAIL.txt")
}

locals {
  email_line = data.local_file.ses_email.content
  email_id   = trim(split("=", local.email_line)[1], " ")
}

output "email_id" {
  value = local.email_id
}

