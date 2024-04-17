resource "aws_ses_email_identity" "email_identity" {
  email = "naikpraneet44@gmail.com"
}

output "verified_email" {
  value = aws_ses_email_identity.email_identity.email
}
