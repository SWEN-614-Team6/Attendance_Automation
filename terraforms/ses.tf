resource "aws_ses_email_identity" "email_identity" {
  email = local.email_id
}
