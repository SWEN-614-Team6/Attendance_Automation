output "API_invoke_url" {
  value = aws_api_gateway_deployment.deployment.invoke_url
   depends_on = [
    aws_api_gateway_deployment.deployment
   ]
}

output "amplify_app_id" {
  value = aws_amplify_app.my_app.id
}

# output "amplify_app_url" {
#   value = aws_amplify_domain_association.domain_association.domain_name
# }