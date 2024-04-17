output "API_invoke_url" {
  value = aws_api_gateway_deployment.deployment.invoke_url
   depends_on = [
    aws_api_gateway_deployment.deployment
   ]
}

output "amplify_app_id" {
  value = aws_amplify_app.my_app.id
}

resource "null_resource" "write_output_to_file" {
  provisioner "local-exec" {
    command = "echo '${aws_api_gateway_deployment.deployment.invoke_url}' | tr -d '\n' > api_invoke_url.txt"
  }

  depends_on = [
    aws_api_gateway_deployment.deployment
  ]
}

# resource "null_resource" "write_output_to_file_user_pool_client" {
#   provisioner "local-exec" {
#     command = "echo '${aws_cognito_user_pool_client.my_user_pool_client.id}' | tr -d '\n' > user_pool_client_id.txt"
#   }
# }

# resource "null_resource" "write_output_to_file_user_pool" {
#   provisioner "local-exec" {
#     command = "echo '${aws_cognito_user_pool.my_user_pool.id}' | tr -d '\n' > user_pool_id.txt"
#   }
# }

# output "amplify_app_url" {
#   value = aws_amplify_domain_association.domain_association.domain_name
# }