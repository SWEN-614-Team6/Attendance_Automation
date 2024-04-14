provider "github" {
  token = var.token
}

# Save the API endpoint as a GitHub secret
resource "github_actions_secret" "api_secret" {
  repository      = "https://github.com/SWEN-614-Team6/Attendance_Automation"
  secret_name     = "API_ENDPOINT"
  plaintext_value = aws_api_gateway_deployment.deployment.invoke_url
  # This secret depends on the output to ensure it's created after the API deployment
  depends_on      = [aws_api_gateway_deployment.deployment]
}
